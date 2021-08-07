// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TapIt",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
        .library(
            name: "BeaconClient",
            targets: ["BeaconClient"]
        ),
        .library(
            name: "CombineHelpers",
            targets: ["CombineHelpers"]
        ),
        .library(
            name: "ComposablePhoneNumberValidation",
            targets: ["ComposablePhoneNumberValidation"]
        ),
        .library(
            name: "ExpirationClient",
            targets: ["ExpirationClient"]
        ),
        .library(
            name: "FeedbackGeneratorClient",
            targets: ["FeedbackGeneratorClient"]
        ),
        .library(
            name: "FileClient",
            targets: ["FileClient"]
        ),
        .library(
            name: "GeneralMocks",
            targets: ["GeneralMocks"]
        ),
        .library(
            name: "HistoryFeature",
            targets: ["HistoryFeature"]
        ),
        .library(
            name: "OpenSocialClient",
            targets: ["OpenSocialClient"]
        ),
        .library(
            name: "OrientationClient",
            targets: ["OrientationClient"]
        ),
        .library(
            name: "P2PClient",
            targets: ["P2PClient"]
        ),
        .library(
            name: "TapFeature",
            targets: ["TapFeature"]
        ),
        .library(
            name: "ProximitySensorClient",
            targets: ["ProximitySensorClient"]
        ),
        .library(
            name: "SentProfileFeature",
            targets: ["SentProfileFeature"]
        ),
        .library(
            name: "SharedModels",
            targets: ["SharedModels"]
        ),
        .library(
            name: "SwiftHelpers",
            targets: ["SwiftHelpers"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", .upToNextMajor(from: "0.21.0")),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", .upToNextMajor(from: "3.3.3")),
        .package(name: "swift-nonempty", url: "https://github.com/nikitamounier/swift-nonempty", .branch("main")),
        .package(name: "Prelude", url: "https://github.com/pointfreeco/swift-prelude", .branch("main"))
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "HistoryFeature",
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: [
                "AppFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "BeaconClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "CombineHelpers",
            dependencies: []
        ),
        .target(
            name: "ComposablePhoneNumberValidation",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "PhoneNumberKit", package: "PhoneNumberKit"),
            ]
        ),
        .testTarget(
            name: "ComposablePhoneNumberValidationTests",
            dependencies: [
                "ComposablePhoneNumberValidation"
            ]
        ),
        .target(
            name: "ExpirationClient",
            dependencies: [
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "FeedbackGeneratorClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "FileClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "GeneralMocks",
            dependencies: []
        ),
        .target(
            name: "HistoryFeature",
            dependencies: [
                "FeedbackGeneratorClient",
                "ExpirationClient",
                "OpenSocialClient",
                "SentProfileFeature",
                "SharedModels",
                "SwiftHelpers",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "NonEmpty", package: "swift-nonempty"),
            ]
        ),
        .testTarget(
            name: "HistoryFeatureTests",
            dependencies: [
                "HistoryFeature",
                "GeneralMocks",
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "NonEmpty", package: "swift-nonempty"),
                .product(name: "Optics", package: "Prelude"),
            ]
        ),
        .target(
            name: "OpenSocialClient",
            dependencies: [
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "OrientationClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "P2PClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "TapFeature",
            dependencies: [
                "BeaconClient",
                "FeedbackGeneratorClient",
                "OrientationClient",
                "P2PClient",
                "ProximitySensorClient",
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "TapFeatureTests",
            dependencies: [
                "TapFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ProximitySensorClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "SentProfileFeature",
            dependencies: [
                "CombineHelpers",
                "FeedbackGeneratorClient",
                "OpenSocialClient",
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "SharedModels",
            dependencies: [
                "GeneralMocks",
                .product(name: "Optics", package: "Prelude"),
                .product(name: "PhoneNumberKit", package: "PhoneNumberKit"),
            ]
        ),
        .testTarget(
            name: "SharedModelsTests",
            dependencies: [
                "SharedModels",
            ]
        ),
        .target(
            name: "SwiftHelpers",
            dependencies: []
        ),
        .testTarget(
            name: "SwiftHelpersTests",
            dependencies: [
                "SwiftHelpers",
            ]
        ),
    ]
)
