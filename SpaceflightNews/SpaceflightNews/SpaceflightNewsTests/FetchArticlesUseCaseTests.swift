// FetchArticlesUseCaseTests.swift
// SpaceNewsApp — Tests/DomainTests
//
// Tests unitarios del caso de uso FetchArticlesUseCase.

import XCTest
@testable import SpaceflightNews

final class FetchArticlesUseCaseTests: XCTestCase {

    // MARK: - Properties

    private var sut: FetchArticlesUseCase!
    private var mockRepository: MockArticleRepository!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        mockRepository = MockArticleRepository()
        sut = FetchArticlesUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_execute_withEmptyQuery_passesNilToRepository() async throws {
        // Given
        mockRepository.fetchArticlesResult = .success(
            ArticleListResult(articles: [.stub()], totalCount: 1)
        )

        // When
        _ = try await sut.execute(query: "", limit: 10, offset: 0)

        // Then
        XCTAssertNil(mockRepository.lastQuery, "Query vacía debería convertirse en nil")
    }

    func test_execute_withValidQuery_passesQueryToRepository() async throws {
        // Given
        let query = "SpaceX"
        mockRepository.fetchArticlesResult = .success(
            ArticleListResult(articles: [.stub()], totalCount: 1)
        )

        // When
        _ = try await sut.execute(query: query, limit: 10, offset: 0)

        // Then
        XCTAssertEqual(mockRepository.lastQuery, "SpaceX")
    }

    func test_execute_withWhitespaceQuery_trimsAndPassesNil() async throws {
        // Given
        mockRepository.fetchArticlesResult = .success(
            ArticleListResult(articles: [], totalCount: 0)
        )

        // When
        _ = try await sut.execute(query: "   ", limit: 10, offset: 0)

        // Then
        XCTAssertNil(mockRepository.lastQuery)
    }

    func test_execute_propagatesRepositoryError() async {
        // Given
        mockRepository.fetchArticlesResult = .failure(NetworkError.noConnection)

        // When / Then
        do {
            _ = try await sut.execute(query: nil, limit: 10, offset: 0)
            XCTFail("Se esperaba un error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.noConnection)
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }

    func test_execute_returnsCorrectArticleCount() async throws {
        // Given
        let stubs = (1...5).map { Article.stub(id: $0) }
        mockRepository.fetchArticlesResult = .success(
            ArticleListResult(articles: stubs, totalCount: 100)
        )

        // When
        let result = try await sut.execute(query: nil, limit: 5, offset: 0)

        // Then
        XCTAssertEqual(result.articles.count, 5)
        XCTAssertEqual(result.totalCount, 100)
    }
}
