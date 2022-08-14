import Foundation
import SharedModels

public struct ExpirationClient {
  public var isExpired: (_ sendDate: Date, _ expirationInterval: Days) -> Bool
  
  public init(
    isExpired: @escaping (Date, Days) -> Bool
  ) {
    self.isExpired = isExpired
  }
  
  public func isExpired(sendDate: Date, expirationInterval: Days) -> Bool {
    self.isExpired(sendDate, expirationInterval)
  }
}
