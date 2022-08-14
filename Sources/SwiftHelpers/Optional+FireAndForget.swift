public extension Optional {
  /// A method for returning void after using ``Optional/map(_:)`` on an optional and passing a void closure inside it.
  /// ```
  /// fruitsArray
  ///     .firstIndex(where: { $0 == .apple })
  ///     .map { fruitsArray[$0].eat() }
  ///     .fireAndForget()
  ///```
  
  /// - Returns: `Void`
  func fireAndForget() -> Void {
    return ()
  }
}
