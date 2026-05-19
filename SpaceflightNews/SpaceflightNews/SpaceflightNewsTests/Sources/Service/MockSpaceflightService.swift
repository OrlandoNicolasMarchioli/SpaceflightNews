//
//  MockSpaceflightService.swift
//  SpaceflightNewsTests
//
//  Created by Orlando Nicola Marchioli on 18/05/2026.
//

import Foundation
@testable import SpaceflightNews

enum NetworkError: Error {
    case invalidResponse
    case notFound
    case serverError
}

final class MockSpaceflightService: SpaceflightServiceProtocol, @unchecked Sendable {
    
    private let lock = NSLock()
    
    private var _articlesResponse: Result<SpaceflightService.DTO.ArticleListResponse, Error> = .success(.mock)
    var articlesResponse: Result<SpaceflightService.DTO.ArticleListResponse, Error> {
        get {
            return _articlesResponse
        }
        set {
            _articlesResponse = newValue
        }
    }
    
    private var _articleResponse: Result<SpaceflightService.DTO.Article, Error> = .success(.mock)
    var articleResponse: Result<SpaceflightService.DTO.Article, Error> {
        get {
            return _articleResponse
        }
        set {
            _articleResponse = newValue
        }
    }
    
    private var _fetchArticlesCallCount = 0
    var fetchArticlesCallCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return _fetchArticlesCallCount
    }
    
    private var _fetchArticleCallCount = 0
    var fetchArticleCallCount: Int {
        return _fetchArticleCallCount
    }
    
    private var _lastQuery: String?
    var lastQuery: String? {
        return _lastQuery
    }
    
    private var _lastLimit: Int?
    var lastLimit: Int? {
        return _lastLimit
    }
    
    private var _lastOffset: Int?
    var lastOffset: Int? {
        return _lastOffset
    }
    
    private var _lastArticleID: String?
    var lastArticleID: String? {
        return _lastArticleID
    }
    
    func fetchArticles(query: String?, limit: Int, offset: Int) async throws -> SpaceflightService.DTO.ArticleListResponse {
        _fetchArticlesCallCount += 1
        _lastQuery = query
        _lastLimit = limit
        _lastOffset = offset
        let response = _articlesResponse
        
        switch response {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    func fetchArticle(by id: String) async throws -> SpaceflightService.DTO.Article {
        _fetchArticleCallCount += 1
        _lastArticleID = id
        let response = _articleResponse
        
        switch response {
        case .success(let article):
            return article
        case .failure(let error):
            throw error
        }
    }
}
