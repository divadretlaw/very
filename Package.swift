// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "very",
    platforms: [.macOS(.v10_13)],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(name: "Wallpaper", url: "https://github.com/sindresorhus/macos-wallpaper", from: "2.3.1"),
        .package(name: "Rainbow", url: "https://github.com/onevcat/Rainbow", from: "4.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .executableTarget(
            name: "very",
            dependencies: ["Shell",
                           "Rainbow",
                           "Wallpaper",
                           .product(
                               name: "ArgumentParser",
                               package: "swift-argument-parser"
                           )]
        ),
        .target(name: "Shell",
                dependencies: ["ShellCore"]),
        .target(name: "ShellCore",
                dependencies: [])
    ]
)
