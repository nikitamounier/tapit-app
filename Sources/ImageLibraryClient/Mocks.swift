import ComposableArchitecture

public extension ImageLibraryClient {
    static let noop = Self(
        openImagePicker: { .none }
    )
    
    #if DEBUG
    static let failing = Self(
        openImagePicker: { .failing("\(Self.self).openImagePicker is unimplemented.") }
    )
}
