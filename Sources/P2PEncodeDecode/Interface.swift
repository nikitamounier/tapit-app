import ComposableArchitecture
import SharedModels

public struct P2PEncodeDecode {
    public var encodePeerInfo: (String) -> Data?
    public var encodeUserProfile: (UserProfile) -> Data?
    
    public var decodePeerInfo: (Data) -> String?
    public var decodeUserProfile: (Data) -> UserProfile?
    
    public init(
        encodePeerInfo: @escaping (String) -> Data?,
        encodeUserProfile: @escaping (UserProfile) -> Data?,
        decodePeerInfo: @escaping (Data) -> String?,
        decodeUserProfile: @escaping (Data) -> UserProfile?
    ) {
        self.encodePeerInfo = encodePeerInfo
        self.encodeUserProfile = encodeUserProfile
        self.decodePeerInfo = decodePeerInfo
        self.decodeUserProfile = decodeUserProfile
    }
}

