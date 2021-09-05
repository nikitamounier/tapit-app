import ComposableArchitecture
import Foundation
import SharedModels

public extension P2PEncodeDecode {
    static let live = Self(
        encodePeerInfo: { peerInfo in
            return try? JSONEncoder().encode(peerInfo)
        },
        encodeUserProfile: { userProfile in
            return try? JSONEncoder().encode(userProfile)
        },
        decodePeerInfo: { data in
            return try? JSONDecoder().decode(String.self, from: data)
        },
        decodeUserProfile: { data in
            return try? JSONDecoder().decode(UserProfile.self, from: data)
        }
    )
}
