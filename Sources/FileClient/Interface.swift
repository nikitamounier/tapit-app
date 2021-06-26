import Combine
import ComposableArchitecture

public struct FileClient {
    public var load: (_ filename: String) -> Effect<Data, Error>
    
    public var save: (_ filename: String, _ data: Data) -> Effect<Never, Error>
    
    public var delete: (_ filename: String) -> Effect<Never, Error>
    
    public func load<T: Decodable>(
        _ type: T.Type, from fileName: String
    ) -> Effect<Result<T, NSError>, Never> {
        self.load(fileName)
            .decode(type: type, decoder: JSONDecoder())
            .mapError { $0 as NSError }
            .catchToEffect()
    }
    
    public func save<T: Encodable>(
        _ data: T, to fileName: String, on queue: AnySchedulerOf<DispatchQueue>
    ) -> Effect<Never, Never> {
        Just(data)
            .subscribe(on: queue)
            .encode(encoder: JSONEncoder())
            .flatMap { data in self.save(fileName, data) }
            .catch { _ in Empty() }
            .setFailureType(to: Never.self)
            .eraseToEffect()
    }
    
    public init(
        load: @escaping (_ filename: String) -> Effect<Data, Error>,
        save: @escaping (_ filename: String, _ data: Data) -> Effect<Never, Error>,
        delete: @escaping (_ filename: String) -> Effect<Never, Error>
    ) {
        self.load = load
        self.save = save
        self.delete = delete
    }
}
