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
		.package(url: "https://github.com/vapor/vapor.git", from: "3.3.1"),
    ],
    targets: [
        .target(
            name: "tivok-api",
			dependencies: ["Vapor"]),
        .testTarget(
            name: "tivok-apiTests",
            dependencies: ["tivok-api"]),
    ]
)
