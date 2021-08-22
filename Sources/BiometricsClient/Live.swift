import ComposableArchitecture
import LocalAuthentication

public extension BiometricsClient {
    static let live = Self(
        authenticate: {
            .future { promise in
                let context = LAContext()
                var error: NSError?
                
                guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
                    promise(.success(.cancelled))
                    return
                }
                
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authentication") { success, error in
                    guard error == nil else {
                        promise(.success(.cancelled))
                        return
                    }
                    
                    promise(.success(success ? .passed : .failed))
                }
            }
        }
    )
}
