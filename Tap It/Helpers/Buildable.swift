//
//  Buildable.swift
//  Tap It
//
//  Created by Nikita Mounier on 06/02/2021.
//

// Taken from https://github.com/fermoya/SwiftUIPager/blob/develop/Sources/SwiftUIPager/Helpers/Buildable.swift
protocol Buildable {}

extension Buildable {
    /// Helper function to mutate the property of an instance using Builder pattern
    /// - Parameters:
    ///   - keyPath: `WriteableKeyPath`to the instance property being modified
    ///   - value: The new vlaue of the instance property
    func mutating<T>(keyPath: WritableKeyPath<Self, T>, value: T) -> Self {
        var newSelf = self
        newSelf[keyPath: keyPath] = value
        return newSelf
    }
}
