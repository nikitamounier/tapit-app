//
//  FileManager+Combine.swift
//  Tap It
//
//  Created by Nikita Mounier on 18/02/2021.
//

import Combine
import SwiftUI

extension FileManager {
    func load(from name: String, in directory: SearchPathDirectory) -> AnyPublisher<Data, Error> {
        return Deferred {
            return Future { promise in
                do {
                    let documentsURL = try self.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    let fileURL = documentsURL.appendingPathComponent(name)
                    promise(.success(try Data(contentsOf: fileURL)))
                } catch {
                    print("Error loading from disk: \(error)") // temporary
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save(data: Data, to name: String, in directory: SearchPathDirectory) -> AnyPublisher<URL, Error> {
        return Deferred {
            return Future { promise in
                do {
                    let documentsURL = try self.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    let fileURL = documentsURL.appendingPathComponent(name)
                    
                    try data.write(to: fileURL, options: .atomic)
                    promise(.success(fileURL))
                } catch {
                    print("Error reading to disk: \(error)") // temporary
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

