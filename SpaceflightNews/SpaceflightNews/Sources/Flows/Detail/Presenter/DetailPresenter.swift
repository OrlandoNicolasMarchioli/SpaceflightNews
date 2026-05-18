// DetailPresenter.swift
// SpaceNewsApp — Presentation/Detail
//
// Presenter del módulo de detalle de artículo.

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
    private let service: SpaceflightService

    @Published var model: Model


    init(
        router: SpaceflightRouter,
        articleID: String,
        service: SpaceflightService = SpaceflightService()
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

// MARK: - Private

private extension DetailPresenter {

    func fetchDetail() async {
        do {
            let article = try await service.fetchArticle(by: articleID)
            model.updateArticle(article)
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
