import XCTest

@testable import SharedModels

class SentProfileTests: XCTestCase {
    func testSentProfile_NotExpired() {
        let sentProfile: SentProfile = .mock(.notExpired)
        
        XCTAssert(!sentProfile.isExpired)
    }
    
    func testSentProfile_Expired() {
        let sentProfile: SentProfile = .mock(.expired)
        
        XCTAssert(sentProfile.isExpired)
    }
}
