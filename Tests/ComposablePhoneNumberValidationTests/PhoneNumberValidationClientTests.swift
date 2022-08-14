import Combine
import PhoneNumberKit
import XCTest

@testable import ComposablePhoneNumberValidation

final class PhoneNumberValidationClientTests: XCTestCase {
  var cancellables = Set<AnyCancellable>()
  let validationClient: PhoneNumberValidationClient = .live
  
  func testHappyPath() {
    struct HappyValidationID: Hashable {}
    let goodPhoneNumber = "+44 7700 900477"
    
    validationClient.create(HappyValidationID())
      .sink { _ in }
      .store(in: &cancellables)
    
    validationClient.parse(HappyValidationID(), goodPhoneNumber)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        XCTAssert(completion == .finished)
      } receiveValue: { number in
        XCTAssert(Thread.isMainThread)
        
        XCTAssert(number.countryCode == 44)
        XCTAssert(number.type == .mobile)
        XCTAssert(number.numberString == goodPhoneNumber)
      }
      .store(in: &cancellables)
    
    validationClient.end(HappyValidationID())
      .sink { _ in }
      .store(in: &cancellables)
    
  }
  
  func testUnhappyPath() { // should be physically impossible since will be using PhoneNumberTextField subclass
    struct UnhappyValidationID: Hashable {}
    let badPhoneNumber = "+44 7700 9004777"
    
    validationClient.create(UnhappyValidationID())
      .sink { _ in }
      .store(in: &cancellables)
    
    validationClient.parse(UnhappyValidationID(), badPhoneNumber)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .finished:
          XCTFail() // should never finish successfully
        case .failure(let error):
          XCTAssert(error == .tooLong)
        }
      } receiveValue: { _ in
        XCTFail() // should never receive value
      }
      .store(in: &cancellables)
    
    validationClient.end(UnhappyValidationID())
      .sink { _ in }
      .store(in: &cancellables)
  }
}
