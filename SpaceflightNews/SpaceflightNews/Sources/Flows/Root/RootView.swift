import SwiftUI
import UIKit

public struct RootView: UIViewControllerRepresentable {
    public init() {}

    public func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        let router = SpaceflightRouter(navigationController: navigationController)
        router.startFlow()
        return navigationController
    }

    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
