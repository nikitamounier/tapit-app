import Foundation

public struct BeaconClient {
  public var start: @BeaconActor @Sendable (_ major: UInt16, _ minor: UInt16) async -> AsyncThrowingStream<[Beacon], Error>

  public init(start: @escaping @Sendable (_ major: UInt16, _ minor: UInt16) async -> AsyncThrowingStream<[Beacon], Error>) {
    self.start = start
  }
}

public struct Beacon: Equatable {
  public let major: UInt16
  public let minor: UInt16
  public let proximity: Proximity
  public let accuracy: Double
  public let rssi: Int
  
  public enum Proximity: Int {
    case unknown, immediate, near, far
  }
}

@globalActor
actor BeaconActor {
  static let shared = BeaconActor()
  
  init() {
    let executor = RunLoopExecutor()
    self.executor = executor
    unownedExecutor = executor.asUnownedSerialExecutor()
    executor.start()
  }
  
  nonisolated let executor: SerialExecutor
  nonisolated let unownedExecutor: UnownedSerialExecutor
  
  
  private final class RunLoopExecutor: Thread, SerialExecutor, @unchecked Sendable {
    override init() {
      super.init()
      name = "AccessibilityElement.SystemObserver"
      qualityOfService = .userInitiated
    }
    override func main() {
      autoreleasepool {
        // Toss something on the run loop so it doesn't return right away
        Timer.scheduledTimer(timeInterval: Date.distantFuture.timeIntervalSince1970,
                             target: self,
                             selector: #selector(noop),
                             userInfo: nil,
                             repeats: true)
        while true {
          autoreleasepool {
            _ = RunLoop.current.run(mode: .default, before: Date(timeIntervalSinceNow: 1.0))
          }
        }
      }
    }
    @objc func noop() {}
    // Stick UnownedJob inside a reference type
    private class Job: NSObject {
      private let unownedJob: UnownedJob
      init(unownedJob: UnownedJob) {
        self.unownedJob = unownedJob
      }
      func runSynchronously(on unownedExecutor: UnownedSerialExecutor) {
        unownedJob._runSynchronously(on: unownedExecutor)
      }
    }
    
    func enqueue(_ job: UnownedJob) {
      perform(#selector(enqueueOnRunLoop),
              on: self,
              with: Job(unownedJob: job),
              waitUntilDone: false,
              modes: [RunLoop.Mode.default.rawValue])
    }
    
    func asUnownedSerialExecutor() -> UnownedSerialExecutor {
      UnownedSerialExecutor(ordinary: self)
    }
    
    @objc private func enqueueOnRunLoop(_ job: Job) {
      job.runSynchronously(on: asUnownedSerialExecutor())
    }
  }
}
