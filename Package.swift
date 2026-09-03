// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-html-prism",
    platforms: [
        .iOS(.v27),
        .macOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .macCatalyst(.v27),
    ],
    products: [
        .library(name: "HTMLPrism", targets: ["HTMLPrism"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-compositions/swift-html.git", branch: "main"),
        .package(
            url: "https://github.com/swift-compositions/swift-dependencies.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-compositions/swift-html-render.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "HTMLPrism",
            dependencies: [
                .product(name: "HTML", package: "swift-html"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .testTarget(
            name: "HTMLPrism Tests",
            dependencies: [
                .target(name: "HTMLPrism"),
                .product(name: "HTML Rendering Core Test Support", package: "swift-html-render"),
            ]
        ),
    ]
)

