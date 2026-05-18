// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SpaceflightNews",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "SpaceflightNews",
            targets: ["SpaceflightNews"]
        ),
        .library(
            name: "Networking",
            targets: ["Networking"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Networking",
            dependencies: [],
            path: "Networking"
        ),
        .target(
            name: "SpaceflightNews",
            dependencies: ["Networking"],
            path: "SpaceflightNews/Sources",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "SpaceflightNewsTests",
            dependencies: ["SpaceflightNews"],
            path: "SpaceflightNews/SpaceflightNewsTests"
        ),
    ]
)
