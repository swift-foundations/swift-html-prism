// swift-tools-version: 6.4

import PackageDescription

extension String {
    static let htmlPrism: Self = "HTMLPrism"
}

extension Target.Dependency {
    static var htmlPrism: Self { .target(name: .htmlPrism) }
}

extension Target.Dependency {
    static var html: Self { .product(name: "HTML", package: "swift-html") }
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var htmlRenderingCoreTestSupport: Self {
        .product(name: "HTML Rendering Core Test Support", package: "swift-html-render")
    }
}

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
        .library(name: .htmlPrism, targets: [.htmlPrism])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-html.git", branch: "main"),
        .package(
            url: "https://github.com/swift-foundations/swift-dependencies.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-foundations/swift-html-render.git", branch: "main"),
    ],
    targets: [
        .target(
            name: .htmlPrism,
            dependencies: [
                .html,
                .dependencies,
            ]
        ),
        .testTarget(
            name: .htmlPrism.tests,
            dependencies: [
                .htmlPrism,
                .htmlRenderingCoreTestSupport,
            ]
        ),
    ]
)

extension String {
    var tests: Self { "\(self) Tests" }
}
