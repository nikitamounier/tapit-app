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
            name: "GlobalQueues",
            targets: ["GlobalQueues"]
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
        .library(
            name: "TapCore",
            targets: ["TapCore"]
        ),
        .library(
            name: "TapFeature",
            targets: ["TapFeature"]
        ),
        .library(
            name: "TCAHelpers",
            targets: ["TCAHelpers"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            .upToNextMajor(from: "0.21.0")
        ),
        .package(
            url: "https://github.com/marmelroy/PhoneNumberKit",
            .upToNextMajor(from: "3.3.3")
        ),
        .package(
            name: "swift-nonempty",
            url: "https://github.com/nikitamounier/swift-nonempty.git",
            .branch("main")
        ),
        .package(
            name: "swift-prelude",
            url: "https://github.com/pointfreeco/swift-prelude",
            .branch("main")
        ),
        .package(
            name: "Difference",
            url: "https://github.com/krzysztofzablocki/Difference.git",
            .branch("master")
        ),
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
            name: "GlobalQueues",
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
                "TCAHelpers",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "NonEmpty", package: "swift-nonempty"),
                .product(name: "Optics", package: "swift-prelude"),
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
                "GlobalQueues",
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
                .product(name: "Optics", package: "swift-prelude"),
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
        .target(
            name: "TapCore",
            dependencies: [
                "BeaconClient",
                "FeedbackGeneratorClient",
                "GeneralMocks",
                "OrientationClient",
                "P2PClient",
                "ProximitySensorClient",
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "TapCoreTests",
            dependencies: [
                "TapCore",
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
            name: "TCAHelpers",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Difference", package: "Difference"),
            ]
        ),
    ]
)
