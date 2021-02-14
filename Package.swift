// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-http-framework",
    products: [
        .executable(name: "swift-http-framework", targets: ["Run"]),
    ],
    dependencies: [
        //.package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(name: "HTTP", url: "https://github.com/vapor/http.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "Run",
            dependencies: [
                "Framework",
                .product(name: "HTTP", package: "HTTP"),
            ]),
        .target(
            name: "Framework",
            dependencies: [
                //.product(name: "NIO", package: "swift-nio"),
                //.product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "HTTP", package: "HTTP"),
            ]),
        .testTarget(
            name: "FrameworkTests",
            dependencies: ["Framework"]),
    ]
)
