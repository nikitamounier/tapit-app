public struct Days: Codable, Equatable {
  public let amount: Int
  
  public init(_ amount: Int) {
    self.amount = amount
  }
}
