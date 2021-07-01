import XCTest

@testable import SharedModels

class EmailAddressTests: XCTestCase {
    func testEmailAddress_HappyPath() {
        let emailAddress = EmailAddress(rawValue: "support@tapit.com")
        XCTAssertNotNil(emailAddress)
    }
    
    func testEmailAddress_ForgotAtSign() {
        let emailAddress = EmailAddress(rawValue: "support.tapit.com")
        XCTAssertNil(emailAddress)
    }
    
    func testEmailAddress_ForgotTopLevelDomain() {
        let emailAddress = EmailAddress(rawValue: "support@tapit")
        XCTAssertNil(emailAddress)
    }
    
    func testEmailAddress_ForgotFirstPart() {
        let emailAddress = EmailAddress(rawValue: "@tapit.com")
        XCTAssertNil(emailAddress)
    }
    
    func testEmailAddress_NoInput() {
        let emailAddress = EmailAddress(rawValue: "")
        XCTAssertNil(emailAddress)
    }
}
