import ComposableArchitecture

public extension ImageLibraryClient {
    static let noop = Self(
        openImagePicker: { .none }
    )
    
    #if DEBUG
    static let unimplemented = Self(
        openImagePicker: { .unimplemented("\(Self.self).openImagePicker.") }
    )
    #endif
}
