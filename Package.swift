// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "baklava-server",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.92.4"),
		.package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
		.package(url: "https://github.com/vapor/fluent-mongo-driver", from: "1.3.1")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
				.product(name: "Fluent", package: "fluent"),
				.product(name: "FluentMongoDriver", package: "fluent-mongo-driver"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableExperimentalFeature("StrictConcurrency"),
] }
