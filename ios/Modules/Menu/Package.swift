// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Menu",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Menu",
            targets: ["Menu"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "Core"),
        .package(path: "HTTP"),
        .package(path: "OrderLibrary"),
        .package(path: "Navigation"),
        .package(path: "Checkout"),
        .package(url: "https://github.com/GustavoVergara/Resourceful.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Menu",
            dependencies: [
                "Core",
                "HTTP",
                "OrderLibrary",
                "Navigation",
                "Resourceful",
                "Checkout",
                .product(name: "Collections", package: "swift-collections"),
            ]),
        .testTarget(
            name: "MenuTests",
            dependencies: [
                "Menu",
                .product(name: "CoreTestKit", package: "Core"),
                "HTTP",
                .product(name: "HTTPTestKit", package: "HTTP")
            ]),
    ]
)
