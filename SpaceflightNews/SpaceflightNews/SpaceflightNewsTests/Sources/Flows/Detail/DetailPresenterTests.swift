//
//  DetailPresenterTests.swift
//  SpaceflightNewsTests
//
//  Created by Orlando Nicola Marchioli on 18/05/2026.
//

import XCTest
import SwiftUI
@testable import SpaceflightNews

@MainActor
final class DetailPresenterTests: XCTestCase {
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
    
    func test_action_viewAppear_shouldPopulateArticleData() async {
        let sut = DetailPresenter(
            router: router,
            articleID: "123",
            service: mockService
        )
        
        mockService.articleResponse = .success(SpaceflightService.DTO.Article.mock)
        
        XCTAssertTrue(sut.model.isLoading)
        XCTAssertNil(sut.model.article)
        
        await sut.action(.viewAppear)
        
        XCTAssertFalse(sut.model.isLoading)
        XCTAssertNotNil(sut.model.article)
        XCTAssertEqual(sut.model.article?.id, SpaceflightService.DTO.Article.mock.id)
    }
    
    func test_action_viewAppear_withFailResponse_shouldNavigateToErrorView() async {
        let sut = DetailPresenter(
            router: router,
            articleID: "999",
            service: mockService
        )
        
        mockService.articleResponse = .failure(NetworkError.notFound)
        
        XCTAssertTrue(sut.model.isLoading)
        
        await sut.action(.viewAppear)
        
        XCTAssertFalse(sut.model.isLoading)
        XCTAssertNil(sut.model.article)
        XCTAssertNotNil(spyNav.pushedViewController)
    }
    
    func test_action_retry_shouldRetryFetchingArticle() async {
        let sut = DetailPresenter(
            router: router,
            articleID: "123",
            service: mockService
        )
        
        mockService.articleResponse = .failure(NetworkError.invalidResponse)
        
        await sut.action(.viewAppear)
        
        XCTAssertNil(sut.model.article)
        
        mockService.articleResponse = .success(SpaceflightService.DTO.Article.mock)
        
        await sut.action(.retry)
        
        XCTAssertFalse(sut.model.isLoading)
        XCTAssertNotNil(sut.model.article)
    }
    
    func test_model_updateArticle_shouldUpdateArticleProperty() {
        var model = DetailPresenter.Model()
        
        XCTAssertNil(model.article)
        
        let article = SpaceflightService.DTO.Article.mock
        model.updateArticle(article)
        
        XCTAssertNotNil(model.article)
        XCTAssertEqual(model.article?.id, article.id)
        XCTAssertEqual(model.article?.title, article.title)
    }
}
