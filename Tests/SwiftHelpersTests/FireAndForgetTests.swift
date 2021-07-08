import XCTest

@testable import SwiftHelpers


class FireAndForgetTests: XCTestCase {
    func testFireAndForget() {
        enum Fruit { // Value type
            case apple
            case banana
            case pear
            case pineapple
            case eaten
            
            mutating func eat() {
                guard self != .eaten else { return }
                self = .eaten
            }
        }
        
        var fruitsArray: [Fruit] = [.banana, .pear, .apple, .banana, .eaten]
        
        fruitsArray
            .firstIndex { $0 == .apple }
            .map { fruitsArray[$0].eat() }
            .fireAndForget()
        
        XCTAssert(
            fruitsArray
                .filter { $0 == .eaten }
                .count == 2
            &&
            !fruitsArray.contains(.apple)
        )
    }
}
