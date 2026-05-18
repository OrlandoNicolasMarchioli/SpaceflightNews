//
//  DetailPresenter+Model.swift
//  SpaceflightNews
//
//  Created by Orlando Nicola Marchioli on 17/05/2026.
//

extension DetailPresenter {
    struct Model {
        
        var isLoading: Bool = true
        
        var loadingMessage: String = "HOME_LOADING_MESSAGE".translate
        
        var article: SpaceflightService.DTO.Article?
        
        var seeCompleteArticleButton: String = "DETAIL_SEE_COMPLETE_ARTICLE_BUTTON".translate
        
        mutating func updateArticle(_ article: SpaceflightService.DTO.Article) {
            self.article = article
        }
    }
}
