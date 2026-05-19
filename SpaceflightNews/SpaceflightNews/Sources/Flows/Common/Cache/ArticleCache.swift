//
//  ArticleCache.swift
//  SpaceflightNews
//
//  Cache manager for articles to avoid unnecessary network calls
//

import Foundation

@MainActor
final class ArticleCache {
    
    static let shared = ArticleCache()
    
    private var cachedArticles: [String: SpaceflightService.DTO.Article] = [:]
    private var cachedArticleList: [SpaceflightService.DTO.Article] = []
    
    private init() {}
        
    func setArticle(_ article: SpaceflightService.DTO.Article) {
        cachedArticles[String(article.id)] = article
    }
    
    func getArticle(forID id: String) -> SpaceflightService.DTO.Article? {
        return cachedArticles[id]
    }
    
    func setArticleList(_ articles: [SpaceflightService.DTO.Article]) {
        cachedArticleList = articles
        articles.forEach { setArticle($0) }
    }
    
    func getArticleList() -> [SpaceflightService.DTO.Article]? {
        return cachedArticleList.isEmpty ? nil : cachedArticleList
    }
    
    func appendArticles(_ articles: [SpaceflightService.DTO.Article]) {
        cachedArticleList.append(contentsOf: articles)
        articles.forEach { setArticle($0) }
    }
        
    func clearAll() {
        cachedArticles.removeAll()
        cachedArticleList.removeAll()
    }
    
    func clearArticleList() {
        cachedArticleList.removeAll()
    }
}

