// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "very",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.4.0"),
        .package(url: "https://github.com/divadretlaw/macos-wallpaper", from: "2.3.2"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1")
    ],
    targets: [
        .executableTarget(
            name: "very",
            dependencies: [
                "Shell",
                .product(
                    name: "Rainbow",
                    package: "Rainbow"
                ),
                .product(
                    name: "Wallpaper",
                    package: "macos-wallpaper"
                ),
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .target(
            name: "Shell",
            dependencies: ["ShellCore"]
        ),
        .target(
            name: "ShellCore",
            dependencies: []
        )
    ]
)
