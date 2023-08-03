import LocalAuthentication

public extension BiometricsClient {
  static let liveValue = Self {
    await withCheckedContinuation { continuation in
      let context = LAContext()
      
      guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else {
        continuation.resume(with: .success(.cancelled))
        return
      }
      
      context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authentication") { success, error in
        guard error == nil else {
          continuation.resume(with: .success(.cancelled))
          return
        }
        
        continuation.resume(with: .success(success ? .passed : .failed))
      }
      
    }
  }
}
