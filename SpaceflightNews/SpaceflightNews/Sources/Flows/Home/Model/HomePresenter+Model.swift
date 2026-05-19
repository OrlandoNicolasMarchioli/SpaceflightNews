//
//  HomePresenter+Model.swift
//  SpaceflightNews
//
//  Created by Orlando Nicola Marchioli on 17/05/2026.
//

extension HomePresenter {
    
    enum SortOrder {
        case ascending
        case descending
        
        var title: String {
            switch self {
            case .ascending:
                return "ASCENDANT_SORT_TITLE".translate
            case .descending:
                return "DESCENDANT_SORT_TITLE".translate
            }
        }
        
        var icon: String {
            switch self {
            case .ascending:
                return "arrow.up"
            case .descending:
                return "arrow.down"
            }
        }
    }
    
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
        
        var sortOrder: SortOrder = .descending
        var showSortSheet: Bool = false
        
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
