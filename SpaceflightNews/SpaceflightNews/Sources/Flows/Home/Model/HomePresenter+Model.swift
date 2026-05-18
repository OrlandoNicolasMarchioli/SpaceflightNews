//
//  HomePresenter+Model.swift
//  SpaceflightNews
//
//  Created by Orlando Nicola Marchioli on 17/05/2026.
//

extension HomePresenter {
    struct Model {
        
        var isLoading: Bool = true
        
        var isLoadingMore: Bool = false
        
        var title: String = "HOME_NAV_BAR_TITLE".translate
        
        var headerTitle: String = "HOME_HEADER_TITLE".translate
        
        var searchPlaceholder = "HOME_SEARCH_PLACEHOLDER".translate
        
        var loadingMessage: String = "HOME_LOADING_MESSAGE".translate
        
        var emptySeachStateTitle: String = "EMPTY_STATE_TITLE".translate
        
        var emptySeachStateMessage: String = "EMPTY_STATE_MESSAGE".translate
        
        var articles: [SpaceflightService.DTO.Article] = []
        
        var allArticles: [SpaceflightService.DTO.Article] = []
        
        var currentOffset: Int = 0
        var hasMorePages: Bool = true
        let pageSize: Int = 10
        
        mutating func updateArticles(_ articles: [SpaceflightService.DTO.Article]) {
            self.allArticles = articles
            self.articles = articles
        }
        
        mutating func appendArticles(_ newArticles: [SpaceflightService.DTO.Article]) {
            self.allArticles.append(contentsOf: newArticles)
            self.articles = self.allArticles
            self.currentOffset += pageSize
            self.hasMorePages = newArticles.count == pageSize
        }
        
        mutating func resetPagination() {
            self.articles = []
            self.allArticles = []
            self.currentOffset = 0
            self.hasMorePages = true
        }
    }
}
