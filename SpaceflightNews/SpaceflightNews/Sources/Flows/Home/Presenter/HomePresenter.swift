import Foundation
import SwiftUI
import Combine

@MainActor
final class HomePresenter: ObservableObject {
    
    enum Action: Equatable {
        case viewAppear
        case resfresh
        case detail(id: String)
        case loadMore
        case filter(text: String)
        case showSheet
        case setSortOrder(HomePresenter.SortOrder)
    }
    
    weak var router: SpaceflightRouter?
    private let service: SpaceflightServiceProtocol
    @Published var model: Model
    
    
    init(router: SpaceflightRouter,
         service: SpaceflightServiceProtocol = SpaceflightService()
    ) {
        self.router = router
        self.service = service
        model = Model()
    }
    
}

extension HomePresenter {
    
    func action(_ action: Action) async {
        switch action {
        case .viewAppear:
            await fetchData()
        case .resfresh:
            await fetchData()
        case .detail(let id):
            router?.navigateTo(.detail(id: id))
        case .loadMore:
            await loadMoreArticles()
        case .filter(let text):
            filterArticles(by: text)
        case .showSheet:
            model.showSortSheet = true
        case .setSortOrder(let order):
            model.sortOrder = order
            applySortOrder()
            model.showSortSheet = false
        }
    }
}

private extension HomePresenter {
    
    func fetchData() async {
        if let cachedArticles = ArticleCache.shared.getArticleList() {
            model.updateArticles(cachedArticles)
            model.currentOffset = cachedArticles.count
            model.hasMorePages = cachedArticles.count >= model.pageSize
            applySortOrder()
            model.isLoading = false
            return
        }
        
        do {
            model.resetPagination()
            model.isLoading = true
            let resultArticles = try await service.fetchArticles(query: "", limit: model.pageSize, offset: 0)
            model.updateArticles(resultArticles.results)
            ArticleCache.shared.setArticleList(resultArticles.results)
            applySortOrder()
            model.currentOffset = model.pageSize
            model.hasMorePages = resultArticles.results.count == model.pageSize
            model.isLoading = false
            
            SpaceflightLogger.shared.logSuccess(
                String(format: "ARTICLE_SUCCESS".translate, String(resultArticles.results.count)),
                category: .endpoint)
        } catch {
            model.isLoading = false
            
            SpaceflightLogger.shared.logArticlesFetchError(
                error,
                query: "",
                limit: model.pageSize,
                offset: 0
            )
            
            router?.popToRoot()
            let hostingController = UIHostingController(rootView: ErrorStateView(
                message: "FETCH_ERROR".translate,
                onRetry: { [weak self] in
                    Task {
                        self?.router?.navigateTo(.home)
                    }
                }
            ))
            router?.push(viewController: hostingController)
        }
    }
    
    func loadMoreArticles() async {
        guard !model.isLoadingMore && model.hasMorePages else { return }
        
        do {
            model.isLoadingMore = true
            let resultArticles = try await service.fetchArticles(
                query: "",
                limit: model.pageSize,
                offset: model.currentOffset
            )
            model.appendArticles(resultArticles.results)
            ArticleCache.shared.appendArticles(resultArticles.results)
            applySortOrder()
            model.isLoadingMore = false
            
            SpaceflightLogger.shared.logSuccess(
                String(format:"MORE_ARTICLE_SUCCESS".translate, String(resultArticles.results.count),
                       String(model.currentOffset)),
                category: .endpoint
            )
        } catch {
            model.isLoadingMore = false
            
            SpaceflightLogger.shared.logArticlesFetchError(
                error,
                query: "",
                limit: model.pageSize,
                offset: model.currentOffset
            )
        }
    }
    
    func filterArticles(by query: String) {
        if query.isEmpty {
            model.articles = model.allArticles
        } else {
            model.articles = model.allArticles.filter { article in
                article.title.localizedCaseInsensitiveContains(query) ||
                article.summary.localizedCaseInsensitiveContains(query) ||
                article.newsSite.localizedCaseInsensitiveContains(query)
            }
        }
        applySortOrder()
    }
    
    func applySortOrder() {
        model.articles = sortedArticles(model.articles)
    }
    
    func sortedArticles(_ articles: [SpaceflightService.DTO.Article]) -> [SpaceflightService.DTO.Article] {
        switch model.sortOrder {
        case .ascending:
            return articles.sorted { $0.publishedAt < $1.publishedAt }
        case .descending:
            return articles.sorted { $0.publishedAt > $1.publishedAt }
        }
    }
}
