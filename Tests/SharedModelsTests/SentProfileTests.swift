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
    
    func testSentProfile_DynamicMemberLookupGet() {
        let sentProfile: SentProfile = .mock(.notExpired)
        
        XCTAssert(sentProfile.id == sentProfile.profile.id)
        XCTAssert(sentProfile.name == sentProfile.profile.name)
        XCTAssert(sentProfile.profileImage == sentProfile.profile.profileImage)
        XCTAssert(sentProfile.socials == sentProfile.profile.socials)
    }
    
    func testSentProfile_DynamicMemberLookupSet() {
        var sentProfile: SentProfile = .mock(.notExpired)
        
        sentProfile.name = "John"
        XCTAssert(sentProfile.name == sentProfile.profile.name)
        
        sentProfile.profileImage = ProfileImage(UIImage(systemName: "pencil")!)
        XCTAssert(sentProfile.profileImage == sentProfile.profile.profileImage)
        
        sentProfile.socials.append(.email(.init(rawValue: "john@icloud.com")!))
        XCTAssert(sentProfile.socials == sentProfile.profile.socials)
    }
}
