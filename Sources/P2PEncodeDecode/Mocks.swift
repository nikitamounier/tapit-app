import ComposableArchitecture
import SharedModels

public extension P2PEncodeDecode {
    static let noop = Self(
        encodePeerInfo: { _ in return Data() },
        encodeUserProfile: { _ in return Data() },
        decodePeerInfo: { _ in return "" },
        decodeUserProfile: { _ in return UserProfile(id: UUID(), name: "", profileImage: .init(.init()), socials: []) }
    )
}
