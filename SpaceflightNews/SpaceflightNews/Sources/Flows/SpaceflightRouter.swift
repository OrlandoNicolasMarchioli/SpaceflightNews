//
//  SpaceflightRouter.swift
//  SpaceflightNews
//
//  Created by Orlando Nicola Marchioli on 17/05/2026.
//

import UIKit
import SwiftUI

@MainActor
protocol SpaceflightRouterProtocol {
    associatedtype Destination
    var navigationController: UINavigationController? { get }
    func startFlow()
    func navigateTo(_ destination: Destination)
    func popToRoot()
    func pop()
    func push(viewController: UIViewController, menuItems: UIMenu?, animated: Bool?)
    init(navigationController: UINavigationController)
}

@MainActor
final class SpaceflightRouter: SpaceflightRouterProtocol {
    
    weak var navigationController: UINavigationController?
    
    enum Destination {
        case home
        case detail(id: String)
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}

extension SpaceflightRouter {
    func startFlow() {
        self.navigateTo(.home)
    }
    
    func navigateTo(_ destination: Destination) {
        switch destination {
        case .home:
            let homeView = HomeView(router: self)
            let hostingController = UIHostingController(rootView: homeView)
            push(viewController: hostingController)
        case .detail(let id):
            let detailView = DetailView(router: self, id: id)
            let hostingController = UIHostingController(rootView: detailView)
            push(viewController: hostingController)
        }
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func push(viewController: UIViewController, menuItems: UIMenu? = nil, animated: Bool? = nil) {
        let shouldAnimate = animated ?? true
        navigationController?.pushViewController(viewController, animated: shouldAnimate)
    }
}
