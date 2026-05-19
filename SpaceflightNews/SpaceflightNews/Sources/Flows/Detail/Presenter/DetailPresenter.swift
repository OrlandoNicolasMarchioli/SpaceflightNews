// DetailPresenter.swift
// SpaceNewsApp — Presentation/Detail
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class DetailPresenter: ObservableObject {

    enum Action: Equatable {
        case viewAppear
        case retry
    }

    weak var router: SpaceflightRouter?
    private let articleID: String
    private let service: SpaceflightServiceProtocol

    @Published var model: Model


    init(
        router: SpaceflightRouter,
        articleID: String,
        service: SpaceflightServiceProtocol = SpaceflightService()
    ) {
        self.router = router
        self.articleID = articleID
        self.service = service
        self.model = Model()
    }
}

extension DetailPresenter {

    func action(_ action: Action) async {
        switch action {
        case .viewAppear:
            await fetchDetail()
        case .retry:
            await fetchDetail()
        }
    }
}

private extension DetailPresenter {

    func fetchDetail() async {
        if let cachedArticle = ArticleCache.shared.getArticle(forID: articleID) {
            model.updateArticle(cachedArticle)
            model.isLoading = false
            return
        }
        
        do {
            let article = try await service.fetchArticle(by: articleID)
            model.updateArticle(article)
            ArticleCache.shared.setArticle(article)
            model.isLoading = false
            
            SpaceflightLogger.shared.logSuccess(
                "DETAIL_SUCCESS".translate,
                category: .endpoint
            )
        } catch {
            model.isLoading = false
            
            SpaceflightLogger.shared.logArticleDetailError(error, articleID: articleID)
            
            router?.popToRoot()
            let hostingController = UIHostingController(rootView: ErrorStateView(
                message: "FETCH_ERROR".translate,
                onRetry: { [weak self] in
                    Task {
                        self?.router?.navigateTo(.detail(id: self?.articleID ?? ""))
                    }
                }
            ))
            router?.push(viewController: hostingController)
        }
    }
}
