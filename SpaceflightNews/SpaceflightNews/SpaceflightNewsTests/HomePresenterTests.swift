// HomePresenterTests.swift
// SpaceNewsApp — Tests/PresentationTests
//
// Tests unitarios del HomePresenter.
// Verifican la gestión de estados, paginación y búsqueda.

import XCTest
import Combine
@testable import SpaceflightNews

@MainActor
final class HomePresenterTests: XCTestCase {

    // MARK: - Properties

    private var sut: HomePresenter!
    private var mockRepository: MockArticleRepository!
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        mockRepository = MockArticleRepository()
        let useCase = FetchArticlesUseCase(repository: mockRepository)
        sut = HomePresenter(fetchArticlesUseCase: useCase)
    }

    override func tearDown() {
        cancellables.removeAll()
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Tests: Initial State

    func test_initialState_isIdle() {
        XCTAssertEqual(sut.viewState, .idle)
    }

    // MARK: - Tests: onAppear

    func test_onAppear_withSuccessfulResponse_transitionsToLoaded() async {
        // Given
        let articles = [Article.stub(id: 1, title: "NASA Article")]
        mockRepository.fetchArticlesResult = .success(
            ArticleListResult(articles: articles, totalCount: 1)
        )

        // When
        sut.onAppear()

        // Wait for async task
        await Task.yield()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        if case .loaded(let items) = sut.viewState {
            XCTAssertEqual(items.count, 1)
            XCTAssertEqual(items.first?.title, "NASA Article")
        } else {
            XCTFail("Se esperaba estado .loaded, se obtuvo: \(sut.viewState)")
        }
    }

    func test_onAppear_withEmptyResponse_transitionsToEmpty() async {
        // Given
        mockRepository.fetchArticlesResult = .success(
            ArticleListResult(articles: [], totalCount: 0)
        )

        // When
        sut.onAppear()
        await Task.yield()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertEqual(sut.viewState, .empty)
    }

    func test_onAppear_withNetworkError_transitionsToError() async {
        // Given
        mockRepository.fetchArticlesResult = .failure(NetworkError.noConnection)

        // When
        sut.onAppear()
        await Task.yield()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        if case .error = sut.viewState {
            // Correcto
        } else {
            XCTFail("Se esperaba estado .error, se obtuvo: \(sut.viewState)")
        }
    }

    // MARK: - Tests: Retry

    func test_retry_afterError_retriesSuccessfully() async {
        // Given: primer fetch falla
        mockRepository.fetchArticlesResult = .failure(NetworkError.noConnection)
        sut.onAppear()
        await Task.yield()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Given: segundo fetch tiene éxito
        let articles = [Article.stub(id: 1)]
        mockRepository.fetchArticlesResult = .success(
            ArticleListResult(articles: articles, totalCount: 1)
        )

        // When
        sut.retry()
        await Task.yield()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        if case .loaded(let items) = sut.viewState {
            XCTAssertEqual(items.count, 1)
        } else {
            XCTFail("Se esperaba estado .loaded tras retry")
        }
    }

    // MARK: - Tests: onAppear Called Only Once

    func test_onAppear_calledTwice_fetchesOnce() async {
        // Given
        mockRepository.fetchArticlesResult = .success(
            ArticleListResult(articles: [.stub()], totalCount: 1)
        )

        // When
        sut.onAppear()
        await Task.yield()
        try? await Task.sleep(nanoseconds: 100_000_000)
        sut.onAppear() // Segunda llamada: debería ignorarse (ya no es .idle)

        // Then
        XCTAssertEqual(mockRepository.fetchArticlesCallCount, 1)
    }
}
