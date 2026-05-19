//
//  SpaceflightRouterTests.swift
//  SpaceflightNewsTests
//
//  Created by Orlando Nicola Marchioli on 18/05/2026.
//

import XCTest
import SwiftUI
@testable import SpaceflightNews

@MainActor
final class SpaceflightRouterTests: XCTestCase {
    private var spyNav: SpyNavigationController!
    private var sut: SpaceflightRouter!
    
    override func setUp() async throws {
        try await super.setUp()
        
        spyNav = SpyNavigationController()
        sut = SpaceflightRouter(navigationController: spyNav)
        
        UIView.setAnimationsEnabled(false)
    }
    
    override func tearDown() async throws {
        spyNav = nil
        sut = nil
        
        try await super.tearDown()
    }
    
    func test_init_shouldSetNavigationController() {
        XCTAssertNotNil(sut.navigationController)
        XCTAssertTrue(sut.navigationController === spyNav)
    }
    
    func test_startFlow_shouldNavigateToHome() {
        sut.startFlow()
        
        XCTAssertNotNil(spyNav.pushedViewController)
        XCTAssertTrue(spyNav.pushedViewController is UIHostingController<HomeView>)
    }
    
    func test_navigateTo_home_shouldPushHomeView() {
        sut.navigateTo(.home)
        
        guard let pushedView = spyNav.pushedViewController as? UIHostingController<HomeView> else {
            XCTFail("Expected UIHostingController<HomeView> to be pushed")
            return
        }
        
        XCTAssertNotNil(pushedView.rootView)
    }
    
    func test_navigateTo_detail_shouldPushDetailView() {
        let testID = "123"
        
        sut.navigateTo(.detail(id: testID))
        
        guard let pushedView = spyNav.pushedViewController as? UIHostingController<DetailView> else {
            XCTFail("Expected UIHostingController<DetailView> to be pushed")
            return
        }
        
        XCTAssertNotNil(pushedView.rootView)
    }
    
    func test_push_withAnimationTrue_shouldPushAnimated() {
        let viewController = UIViewController()
        
        sut.push(viewController: viewController, menuItems: nil, animated: true)
        
        XCTAssertTrue(spyNav.pushedAnimated)
        XCTAssertTrue(spyNav.pushedViewController === viewController)
    }
    
    func test_push_withAnimationFalse_shouldPushWithoutAnimation() {
        let viewController = UIViewController()
        
        sut.push(viewController: viewController, menuItems: nil, animated: false)
        
        XCTAssertFalse(spyNav.pushedAnimated)
        XCTAssertTrue(spyNav.pushedViewController === viewController)
    }
    
    func test_push_withDefaultAnimation_shouldPushAnimated() {
        let viewController = UIViewController()
        
        sut.push(viewController: viewController)
        
        XCTAssertTrue(spyNav.pushedAnimated)
        XCTAssertTrue(spyNav.pushedViewController === viewController)
    }
    
    func test_pop_shouldCallPopViewController() {
        sut.pop()
        
        XCTAssertTrue(spyNav.popCalled)
    }
    
    func test_popToRoot_shouldCallPopToRootViewController() {
        sut.popToRoot()
        
        XCTAssertTrue(spyNav.popToRootCalled)
    }
}
