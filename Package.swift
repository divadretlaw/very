// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "very",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.4.0"),
        .package(url: "https://github.com/divadretlaw/Shell", from: "0.7.0"),
        .package(url: "https://github.com/divadretlaw/macos-wallpaper", from: "2.3.2"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1")
    ],
    targets: [
        .executableTarget(
            name: "very",
            dependencies: [
                .product(name: "Shell", package: "Shell"),
                .product(name: "Rainbow", package: "Rainbow"),
                .product(name: "Wallpaper", package: "macos-wallpaper"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
