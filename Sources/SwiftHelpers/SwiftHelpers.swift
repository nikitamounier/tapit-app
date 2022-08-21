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

public extension Array {
  func removingAll(where predicate: (Element) throws -> Bool) rethrows -> Self {
    var new = self
    try new.removeAll { try predicate($0) }
    return new
  }
}
