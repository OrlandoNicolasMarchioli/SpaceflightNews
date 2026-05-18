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
    }
    
    weak var router: SpaceflightRouter?
    private let service: SpaceflightService
    @Published var model: Model
    
    
    init(router: SpaceflightRouter,
         service: SpaceflightService = SpaceflightService()
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
        }
    }
}

private extension HomePresenter {
    
    func fetchData() async {
        do {
            model.resetPagination()
            model.isLoading = true
            let resultArticles = try await service.fetchArticles(query: "", limit: model.pageSize, offset: 0)
            model.updateArticles(resultArticles.results)
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
            model.isLoadingMore = false
            
            SpaceflightLogger.shared.logSuccess(
                String(format:"MORE_ARTICLE_SUCCESS".translate, resultArticles.results.count,
                       model.currentOffset),
                category: .endpoint
            )
        } catch {
            model.isLoadingMore = false
            
            // 🔴 Logger: Registrar error de paginación
            SpaceflightLogger.shared.logArticlesFetchError(
                error,
                query: "",
                limit: model.pageSize,
                offset: model.currentOffset
            )
            
            print(String(format:"LOADING_ARTICLES_ERROR".translate),error.localizedDescription)
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
    }
}
