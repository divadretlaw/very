// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "very",
    platforms: [.macOS(.v10_13)],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.0"),
        .package(name: "Wallpaper", url: "https://github.com/divadretlaw/macos-wallpaper", from: "2.2.0"),
        .package(name: "Rainbow", url: "https://github.com/onevcat/Rainbow", from: "4.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "very",
            dependencies: ["SwiftCLI", "Rainbow", "Wallpaper", "Shell"]
        ),
        .target(name: "Shell",
                dependencies: ["ShellCore"]),
        .target(name: "ShellCore",
                dependencies: [])
    ]
)
