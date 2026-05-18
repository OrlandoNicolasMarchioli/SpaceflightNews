import SwiftUI

@main
struct SpaceflightNewsApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        let router = SpaceflightRouter(navigationController: navigationController)
        router.startFlow()
        return navigationController
    }
}
