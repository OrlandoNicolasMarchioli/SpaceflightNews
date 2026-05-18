// Mocks.swift
// SpaceNewsApp — Tests
//
// Mocks e implementaciones stub para tests unitarios.
// Usan protocolos para ser intercambiables con las implementaciones reales.

import Foundation
@testable import Networking
@testable import SpaceflightNews

// MARK: - MockHTTPClient

/// Cliente HTTP mock que retorna datos hardcodeados sin tocar la red.
final class MockHTTPClient: HTTPClient {

    // MARK: - Configuration

    /// Closure que define el resultado para cualquier request.
    var resultProvider: ((any Endpoint) throws -> Any)?

    func request<T: Decodable>(
        endpoint: any Endpoint,
        responseType: T.Type
    ) async throws -> T {
        if let provider = resultProvider {
            let result = try provider(endpoint)
            guard let typed = result as? T else {
                throw NetworkError.decodingError("Mock type mismatch")
            }
            return typed
        }
        throw NetworkError.unknown("No result configured in MockHTTPClient")
    }
}

// MARK: - MockArticleRepository

/// Repositorio mock para testear casos de uso y presenters sin red.
final class MockArticleRepository: ArticleRepository {

    var fetchArticlesResult: Result<ArticleListResult, Error> = .success(
        ArticleListResult(articles: [], totalCount: 0)
    )
    var fetchArticleDetailResult: Result<Article, Error> = .success(
        Article.stub()
    )

    var fetchArticlesCallCount  = 0
    var fetchDetailCallCount    = 0
    var lastQuery: String?

    func fetchArticles(query: String?, limit: Int, offset: Int) async throws -> ArticleListResult {
        fetchArticlesCallCount += 1
        lastQuery = query
        return try fetchArticlesResult.get()
    }

    func fetchArticle(by id: Int) async throws -> Article {
        fetchDetailCallCount += 1
        return try fetchArticleDetailResult.get()
    }
}

// MARK: - Article Stub

extension Article {
    static func stub(
        id: Int = 1,
        title: String = "Test Article Title",
        url: String = "https://example.com",
        imageURL: String? = "https://example.com/image.jpg",
        newsSite: String = "NASA",
        summary: String = "Test summary",
        publishedAt: Date = Date(),
        updatedAt: Date = Date()
    ) -> Article {
        Article(
            id: id,
            title: title,
            url: url,
            imageURL: imageURL,
            newsSite: newsSite,
            summary: summary,
            publishedAt: publishedAt,
            updatedAt: updatedAt
        )
    }
}
