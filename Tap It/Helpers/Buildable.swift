//
//  Buildable.swift
//  Tap It
//
//  Created by Nikita Mounier on 06/02/2021.
//

// Taken from https://github.com/fermoya/SwiftUIPager/blob/develop/Sources/SwiftUIPager/Helpers/Buildable.swift
protocol Buildable {}

extension Buildable {
    /// Returns a new instance whose property defined by the keypath is set to `value`.
    /// - Parameters:
    ///   - keyPath: `WriteableKeyPath` to the property which shall be modified
    ///   - value: The value which will be set to the property
    ///
    /// This function is used for types with value semantics.
    func build<Value>(keyPath: WritableKeyPath<Self, Value>, value: Value) -> Self {
        var newSelf = self
        newSelf[keyPath: keyPath] = value
        return newSelf
    }
    
    /// Returns a new instance whose property defined by the keypath is set to `value`.
    /// - Parameters:
    ///   - keyPath: `ReferenceWriteableKeyPath` to the property which shall be modified
    ///   - value: The value which will be set to the property
    ///
    /// This function is used for types with reference semantics.
    func build<Value>(keyPath: ReferenceWritableKeyPath<Self, Value>, value: Value) -> Self {
        let newSelf = self
        newSelf[keyPath: keyPath] = value
        return newSelf
    }
}
