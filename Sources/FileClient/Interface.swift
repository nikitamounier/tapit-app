import Foundation
import Combine
import ComposableArchitecture
import Dependencies

public struct FileClient: DependencyKey {
  
  public var load: (_ filename: String) async throws -> Data
  
  public var save: (_ filename: String, _ data: Data) async throws -> ()
  
  public var delete: (_ filename: String) async throws -> ()
  
  public func load<T: Decodable>(
    _ type: T.Type, from fileName: String
  ) async throws -> T {
    return try await JSONDecoder().decode(T.self, from: self.load(fileName))
  }
  
  public func save<T: Encodable>(
    _ data: T, to fileName: String
  ) async throws {
    @Dependency(\.fireAndForget) var fireAndForget;
    await fireAndForget {
      try await self.save(fileName, JSONEncoder().encode(data))
    }
  }
  
  public init(
    load: @escaping (String) async throws -> Data,
    save: @escaping (String, Data) async throws -> Void,
    delete: @escaping (String) async throws -> Void
  ) {
    self.load = load
    self.save = save
    self.delete = delete
  }
}

public extension DependencyValues {
  var fileClient: FileClient {
    get { self[FileClient.self] }
    set { self[FileClient.self] = newValue}
  }
}
