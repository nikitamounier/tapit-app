import ComposableArchitecture
import SwiftUI

public struct BiometricsClient {
  public enum AuthenticationResult {
    case passed
    case failed
    case cancelled
  }
  
  public var authenticate: () -> Effect<AuthenticationResult, Never>
  
  public init(authenticate: @escaping () -> Effect<AuthenticationResult, Never>) {
    self.authenticate = authenticate
  }
}
