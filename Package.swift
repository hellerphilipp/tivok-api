// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "tivok-api",
    products: [
        .library(
            name: "tivok-api",
            targets: ["tivok-api"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "tivok-api",
            dependencies: []),
        .testTarget(
            name: "tivok-apiTests",
            dependencies: ["tivok-api"]),
    ]
)
