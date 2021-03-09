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
    ///z
    /// Say you have a person type, like so:
    ///
    ///     struct Person {
    ///         var name: String?
    ///         var age: Int?
    ///         var city: String?
    ///         var country: String?
    ///         var planet: String?
    ///     }
    ///
    /// You declare the builder functions:
    ///
    ///     extension Person: Buildable {
    ///         func called(_ name: String) -> Self {
    ///             build(keyPath: \.name, value: name)
    ///         }
    ///
    ///         func aged(_ age: Int) -> Self {
    ///             build(keyPath: \.age, value: age)
    ///         }
    ///
    ///         func living(in city: String, country: String, planet: String) -> Self {
    ///             build(keyPath: \.city, value: city)
    ///             .build(keyPath: \.country, value: country)
    ///             .build(keyPath: \.planet, value: planet) // highly composable
    ///         }
    ///
    /// And at declaration, build your type:
    ///
    ///     let person = Person()
    ///         .called("Chris")
    ///         .aged(25)
    ///         .living(in: "San Francisco", country: "United States", planet: "Earth")
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
    /// This function is used for reference types.
    /// For additional documentation, refer to the other `build` function made for value types.
    func build<Value>(keyPath: ReferenceWritableKeyPath<Self, Value>, value: Value) -> Self {
        let newSelf = self
        newSelf[keyPath: keyPath] = value
        return newSelf
    }
}
