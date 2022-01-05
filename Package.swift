// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "WaniKani",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        .library(
            name: "WaniKani",
            targets: ["WaniKani"]
        )
    ],
    targets: [
        .target(
            name: "WaniKani",
            dependencies: []
        ),
        // Examples
        .executableTarget(
            name: "apitest",
            dependencies: ["WaniKani"],
            path: "Examples/apitest"
        ),
        // Tests
        .testTarget(
            name: "WaniKaniTests",
            dependencies: ["WaniKani"]
        ),
    ]
)
