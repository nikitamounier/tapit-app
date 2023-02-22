// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TapIt",
  platforms: [
    .iOS("15.1"),
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
      name: "BiometricsClient",
      targets: ["BiometricsClient"]
    ),
    .library(
      name: "BottomSheet",
      targets: ["BottomSheet"]
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
      name: "HapticClient",
      targets: ["HapticClient"]
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
      name: "ImageLibraryClient",
      targets: ["ImageLibraryClient"]
    ),
    .library(
      name: "OpenSocialClient",
      targets: ["OpenSocialClient"]
    ),
    .library(
      name: "OpenSocialFeature",
      targets: ["OpenSocialFeature"]
    ),
    .library(
      name: "OrientationClient",
      targets: ["OrientationClient"]
    ),
    .library(
      name: "MultipeerClient",
      targets: ["MultipeerClient"]
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
      name: "SpringboardFeature",
      targets: ["SpringboardFeature"]
    ),
    .library(
      name: "Styleguide",
      targets: ["Styleguide"]
    ),
    .library(
      name: "SwiftHelpers",
      targets: ["SwiftHelpers"]
    ),
    .library(
      name: "SwiftUIHelpers",
      targets: ["SwiftUIHelpers"]
    ),
    .library(
      name: "TapFeature",
      targets: ["TapFeature"]
    ),
    .library(
      name: "UserProfileFeature",
      targets: ["UserProfileFeature"]
    ),
    .library(
      name: "VisualEffects",
      targets: ["VisualEffects"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture.git",
      .upToNextMajor(from: "0.31.0")
    ),
    .package(
      url: "https://github.com/insidegui/MultipeerKit",
      .upToNextMajor(from: "0.4.0")
    ),
    .package(
      url: "https://github.com/marmelroy/PhoneNumberKit",
      .upToNextMajor(from: "3.3.3")
    ),
    .package(
      url: "https://github.com/nikitamounier/swift-nonempty.git",
      branch: "main"
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-prelude",
      branch: "main"
    ),
    .package(
      url: "https://github.com/apple/swift-collections",
      .upToNextMajor(from: "1.0.1")
    ),
    .package(
      url: "https://github.com/apple/swift-algorithms",
      .upToNextMajor(from: "1.0.0")
    ),
    .package(
      url: "https://github.com/nikitamounier/PagerTabStripView",
      branch: "main"
    ),
    .package(
      url: "https://github.com/krzysztofzablocki/Inject.git",
      from: "1.0.2"
    )
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
      name: "BiometricsClient",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "BottomSheet",
      dependencies: []
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
      name: "HapticClient",
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
        "HapticClient",
        "ExpirationClient",
        "OpenSocialClient",
        "SentProfileFeature",
        "SharedModels",
        "SwiftHelpers",
        .product(name: "Algorithms", package: "swift-algorithms"),
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
        .product(name: "Optics", package: "swift-prelude"),
      ]
    ),
    .target(
      name: "ImageLibraryClient",
      dependencies: [
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
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
      name: "OpenSocialFeature",
      dependencies: [
        "CombineHelpers",
        "HapticClient",
        "OpenSocialClient",
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
      name: "MultipeerClient",
      dependencies: [
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "MultipeerKit", package: "MultipeerKit"),
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
        "HapticClient",
        "OpenSocialClient",
        "OpenSocialFeature",
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
      name: "SpringboardFeature",
      dependencies: [
        "SharedModels",
        "SwiftUIHelpers",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "Algorithms", package: "swift-algorithms"),
      ]
    ),
    .testTarget(
      name: "SpringboardFeatureTests",
      dependencies: [
        "SharedModels",
        "SpringboardFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "Styleguide",
      dependencies: [
        "SharedModels",
        .product(name: "PagerTabStripView", package: "PagerTabStripView"),
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
      name: "SwiftUIHelpers",
      dependencies: []
    ),
    .target(
      name: "TapFeature",
      dependencies: [
        "BeaconClient",
        "HapticClient",
        "OrientationClient",
        "MultipeerClient",
        "ProximitySensorClient",
        "SharedModels",
        "Styleguide",
        "SwiftHelpers",
        "SwiftUIHelpers",
        .product(name: "Optics", package: "swift-prelude"),
        .product(name: "Algorithms", package: "swift-algorithms"),
        .product(name: "OrderedCollections", package: "swift-collections"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "Inject", package: "Inject"),
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
      name: "UserProfileFeature",
      dependencies: [
        "BottomSheet",
        "HapticClient",
        "ImageLibraryClient",
        "OpenSocialClient",
        "OpenSocialFeature",
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .testTarget(
      name: "UserProfileFeatureTests",
      dependencies: [
        "UserProfileFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "VisualEffects",
      dependencies: []
    ),
  ]
)
