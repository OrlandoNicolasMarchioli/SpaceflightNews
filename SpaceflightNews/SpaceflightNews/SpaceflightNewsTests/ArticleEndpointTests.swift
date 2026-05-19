// ArticleEndpointTests.swift
// SpaceNewsApp — Tests/NetworkingKitTests
//
// Tests unitarios de la construcción de endpoints y URLs.

import XCTest
@testable import SpaceflightNews

final class ArticleEndpointTests: XCTestCase {

    // MARK: - Articles Endpoint

    func test_articlesEndpoint_buildsCorrectURL_noQuery() throws {
        // Given
        let endpoint = ArticleEndpoint.articles(query: nil, limit: 20, offset: 0)

        // When
        let request = try endpoint.asURLRequest()

        // Then
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "api.spaceflightnewsapi.net")
        XCTAssertTrue(url.path.contains("/v4/articles"))

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let items = components?.queryItems ?? []
        XCTAssertTrue(items.contains(URLQueryItem(name: "limit", value: "20")))
        XCTAssertTrue(items.contains(URLQueryItem(name: "offset", value: "0")))
        XCTAssertFalse(items.contains(where: { $0.name == "search" }))
    }

    func test_articlesEndpoint_buildsCorrectURL_withQuery() throws {
        // Given
        let endpoint = ArticleEndpoint.articles(query: "SpaceX", limit: 10, offset: 0)

        // When
        let request = try endpoint.asURLRequest()

        // Then
        let url = try XCTUnwrap(request.url)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let items = components?.queryItems ?? []
        XCTAssertTrue(items.contains(URLQueryItem(name: "search", value: "SpaceX")))
    }

    func test_articlesEndpoint_usesGETMethod() throws {
        let endpoint = ArticleEndpoint.articles(query: nil, limit: 10, offset: 0)
        let request = try endpoint.asURLRequest()
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func test_articlesEndpoint_pagination_correctOffset() throws {
        // Given
        let endpoint = ArticleEndpoint.articles(query: nil, limit: 20, offset: 40)

        // When
        let request = try endpoint.asURLRequest()

        // Then
        let url = try XCTUnwrap(request.url)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let items = components?.queryItems ?? []
        XCTAssertTrue(items.contains(URLQueryItem(name: "offset", value: "40")))
    }

    // MARK: - Article Detail Endpoint

    func test_detailEndpoint_buildsCorrectURL() throws {
        // Given
        let endpoint = ArticleEndpoint.articleDetail(id: 42)

        // When
        let request = try endpoint.asURLRequest()

        // Then
        let url = try XCTUnwrap(request.url)
        XCTAssertTrue(url.path.contains("/v4/articles/42"))
    }

    // MARK: - DTO Mapping

    func test_articleDTO_mapsCorrectlyToDomain() {
        // Given
        let dto = ArticleDTO(
            id: 1,
            title: "Test Title",
            url: "https://example.com",
            imageUrl: "https://example.com/img.jpg",
            newsSite: "NASA",
            summary: "Test summary",
            publishedAt: Date(timeIntervalSince1970: 0),
            updatedAt: Date(timeIntervalSince1970: 60),
            featured: false,
            launches: [],
            events: []
        )

        // When
        let article = dto.toDomain()

        // Then
        XCTAssertEqual(article.id, 1)
        XCTAssertEqual(article.title, "Test Title")
        XCTAssertEqual(article.url, "https://example.com")
        XCTAssertEqual(article.imageURL, "https://example.com/img.jpg")
        XCTAssertEqual(article.newsSite, "NASA")
        XCTAssertEqual(article.summary, "Test summary")
    }
}
