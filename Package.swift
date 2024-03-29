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
		.package(url: "https://github.com/vapor/jwt-kit.git", from: "3.1.1"),
		.package(url: "https://github.com/vapor/auth.git", from: "2.0.4"),
    ],
    targets: [
        .target(
            name: "tivok-api",
			dependencies: ["Vapor", "FluentPostgreSQL", "JWT", "Authentication"]),
    ]
)
