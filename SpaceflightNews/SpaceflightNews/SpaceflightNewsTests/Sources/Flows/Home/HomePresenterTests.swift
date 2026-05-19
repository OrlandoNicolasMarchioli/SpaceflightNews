//
//  HomePresenterTests.swift
//  SpaceflightNewsTests
//
//  Created by Orlando Nicola Marchioli on 18/05/2026.
//

import XCTest
import SwiftUI
@testable import SpaceflightNews

@MainActor
final class HomePresenterTests: XCTestCase {
    private var spyNav: SpyNavigationController!
    private var router: SpaceflightRouter!
    private var mockService: MockSpaceflightService!
    
    override func setUp() async throws {
        try await super.setUp()
        
        spyNav = SpyNavigationController()
        router = SpaceflightRouter(navigationController: spyNav)
        mockService = MockSpaceflightService()
        
        UIView.setAnimationsEnabled(false)
    }
    
    override func tearDown() async throws {
        spyNav = nil
        router = nil
        mockService = nil
        
        try await super.tearDown()
    }
    
    func test_action_viewAppear_shouldPopulateData() async {
        let sut = HomePresenter(
            router: router,
            service: mockService
        )
        
        mockService.articlesResponse = .success(
            SpaceflightService.DTO.ArticleListResponse.mock
        )
        
        XCTAssertTrue(sut.model.isLoading)
        
        await sut.action(.viewAppear)
        
        XCTAssertFalse(sut.model.isLoading)
        XCTAssertEqual(sut.model.articles.count, 3)
    }
    
    func test_action_refresh_shouldReloadData() async {
        let sut = HomePresenter(
            router: router,
            service: mockService
        )
        
        mockService.articlesResponse = .success(
            SpaceflightService.DTO.ArticleListResponse.mock
        )
        
        await sut.action(.resfresh)
        
        XCTAssertFalse(sut.model.isLoading)
        XCTAssertEqual(sut.model.articles.count, 3)
    }
    
    func test_action_detail_shouldNavigateToDetailScreen() async {
        let sut = HomePresenter(
            router: router,
            service: mockService
        )
        
        mockService.articlesResponse = .success(
            SpaceflightService.DTO.ArticleListResponse.mock
        )
        
        await sut.action(.viewAppear)
        await sut.action(.detail(id: "123"))
        
        guard let pushedView = spyNav.pushedViewController as? UIHostingController<DetailView> else {
            XCTFail("Expected UIHostingController<DetailView> to be pushed")
            return
        }
        
        XCTAssertNotNil(pushedView.rootView)
    }
    
    func test_action_loadMore_whenAlreadyLoading_shouldNotLoadAgain() async {
        let sut = HomePresenter(
            router: router,
            service: mockService
        )
        
        mockService.articlesResponse = .success(
            SpaceflightService.DTO.ArticleListResponse.mock
        )
        
        await sut.action(.viewAppear)
        
        sut.model.isLoadingMore = true
        let countBefore = mockService.fetchArticlesCallCount
        
        await sut.action(.loadMore)
        
        XCTAssertEqual(mockService.fetchArticlesCallCount, countBefore)
    }
    
    func test_action_filter_withValidText_shouldFilterArticles() async {
        let sut = HomePresenter(
            router: router,
            service: mockService
        )
        
        mockService.articlesResponse = .success(
            SpaceflightService.DTO.ArticleListResponse.mock
        )
        
        await sut.action(.viewAppear)
        
        let totalArticles = sut.model.articles.count
        
        await sut.action(.filter(text: "SpaceX"))
        
        XCTAssertLessThanOrEqual(sut.model.articles.count, totalArticles)
    }
    
    func test_action_filter_withEmptyText_shouldShowAllArticles() async {
        let sut = HomePresenter(
            router: router,
            service: mockService
        )
        
        mockService.articlesResponse = .success(
            SpaceflightService.DTO.ArticleListResponse.mock
        )
        
        await sut.action(.viewAppear)
        
        let totalArticles = sut.model.articles.count
        
        await sut.action(.filter(text: "SpaceX"))
        await sut.action(.filter(text: ""))
        
        XCTAssertEqual(sut.model.articles.count, totalArticles)
    }
    
    func test_action_showSheet_shouldSetShowSortSheetToTrue() async {
        let sut = HomePresenter(
            router: router,
            service: mockService
        )
        
        XCTAssertFalse(sut.model.showSortSheet)
        
        await sut.action(.showSheet)
        
        XCTAssertTrue(sut.model.showSortSheet)
    }
    
    func test_action_setSortOrder_ascending_shouldSortAscending() async {
        let sut = HomePresenter(
            router: router,
            service: mockService
        )
        
        mockService.articlesResponse = .success(
            SpaceflightService.DTO.ArticleListResponse.mock
        )
        
        await sut.action(.viewAppear)
        await sut.action(.setSortOrder(.ascending))
        
        XCTAssertEqual(sut.model.sortOrder, .ascending)
        XCTAssertFalse(sut.model.showSortSheet)
        
        // Verify articles are sorted in ascending order
        let sortedDates = sut.model.articles.map { $0.publishedAt }
        let expectedSorted = sortedDates.sorted { $0 < $1 }
        XCTAssertEqual(sortedDates, expectedSorted)
    }
    
    func test_action_setSortOrder_descending_shouldSortDescending() async {
        let sut = HomePresenter(
            router: router,
            service: mockService
        )
        
        mockService.articlesResponse = .success(
            SpaceflightService.DTO.ArticleListResponse.mock
        )
        
        await sut.action(.viewAppear)
        await sut.action(.setSortOrder(.descending))
        
        XCTAssertEqual(sut.model.sortOrder, .descending)
        XCTAssertFalse(sut.model.showSortSheet)
        
        // Verify articles are sorted in descending order
        let sortedDates = sut.model.articles.map { $0.publishedAt }
        let expectedSorted = sortedDates.sorted { $0 > $1 }
        XCTAssertEqual(sortedDates, expectedSorted)
    }
    
    func test_model_updateArticles_shouldUpdateArticlesAndAllArticles() {
        var model = HomePresenter.Model()
        
        let articles = SpaceflightService.DTO.ArticleListResponse.mock.results
        
        model.updateArticles(articles)
        
        XCTAssertEqual(model.articles.count, articles.count)
        XCTAssertEqual(model.allArticles.count, articles.count)
    }
    
    func test_model_appendArticles_shouldAppendToExistingArticles() {
        var model = HomePresenter.Model()
        
        let firstBatch = SpaceflightService.DTO.ArticleListResponse.mock.results
        let secondBatch = SpaceflightService.DTO.ArticleListResponse.mockPage2.results
        
        model.updateArticles(firstBatch)
        let initialCount = model.articles.count
        
        model.appendArticles(secondBatch)
        
        XCTAssertEqual(model.articles.count, initialCount + secondBatch.count)
        XCTAssertEqual(model.currentOffset, model.pageSize)
    }
    
    func test_model_resetPagination_shouldClearArticles() {
        var model = HomePresenter.Model()
        
        let articles = SpaceflightService.DTO.ArticleListResponse.mock.results
        model.updateArticles(articles)
        model.currentOffset = 20
        model.hasMorePages = false
        
        model.resetPagination()
        
        XCTAssertEqual(model.articles.count, 0)
        XCTAssertEqual(model.allArticles.count, 0)
        XCTAssertEqual(model.currentOffset, 0)
        XCTAssertTrue(model.hasMorePages)
    }
}
