import Foundation

public extension UUID {
  static let deadbeef = Self(uuidString: "deadbeef-dead-beef-dead-beefdeadbeef")!
  static let deadbeef1 = Self(uuidString: "deadbeef-dead-beef-dead-beefdeadbee1")!
  static let deadbeef2 = Self(uuidString: "deadbeef-dead-beef-dead-beefdeadbee2")!
  
  static let major1 = Self(uuidString: "deadbeef-dead-beef-dead-6d616a6f7231")!
  static let minor1 = Self(uuidString: "deadbeef-dead-beef-dead-6d696e6f7231")!
  
  static let major2 = Self(uuidString: "deadbeef-dead-beef-dead-6d616a6f7232")!
  static let minor2 = Self(uuidString: "deadbeef-dead-beef-dead-6d616a6f7231")!
  
  static let major3 = Self(uuidString: "deadbeef-dead-beef-dead-6d616a6f7233")!
  static let minor3 = Self(uuidString: "deadbeef-dead-beef-dead-6d696e6f7233")!
  
}

public extension UUID {
  static var incrementing: () -> UUID {
    var uuid = 0
    return {
      defer { uuid += 1 }
      return UUID(uuidString: "00000000-0000-0000-0000\(String(format: "%012x", uuid))")!
    }
  }
}
