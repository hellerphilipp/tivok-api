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
		.package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "tivok-api",
			dependencies: ["Vapor", "FluentPostgreSQL"]),
    ]
)
