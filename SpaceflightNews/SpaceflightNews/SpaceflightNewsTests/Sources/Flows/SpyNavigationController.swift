//
//  SpyNavigationController.swift
//  SpaceflightNewsTests
//
//  Created by Orlando Nicola Marchioli on 18/05/2026.
//

import UIKit

@MainActor
final class SpyNavigationController: UINavigationController {
    
    var pushedViewController: UIViewController?
    var pushedAnimated: Bool = false
    var popToRootCalled: Bool = false
    var popCalled: Bool = false
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        pushedAnimated = animated
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        popCalled = true
        return super.popViewController(animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        popToRootCalled = true
        return super.popToRootViewController(animated: animated)
    }
}
