import Foundation
import MapKit
import XCTest
@testable import SharedModels

extension JSONEncoder {
  convenience init(outputFormatting: OutputFormatting) {
    self.init()
    self.outputFormatting = outputFormatting
  }
}

func assertCodable<T: Codable & Equatable>(
  _ value: T,
  isEqual: (T, T) -> Bool = { $0 == $1 },
  decoder: JSONDecoder = .init(),
  encoder: JSONEncoder = .init(outputFormatting: [.prettyPrinted, .sortedKeys])
) throws -> Bool {
  let encoded = try encoder.encode(value)
  let decoded = try decoder.decode(T.self, from: encoded)
  
  return isEqual(value, decoded)
}

final class CodableTests: XCTestCase {
  let image = UIImage(systemName: "applelogo")!
  let socials: [Social] = .mock
  
  func testSocialCodable() throws {
    try XCTAssertTrue(assertCodable(socials))
  }
  
  func testCoordinateCodable() throws {
    let coordinates: Coordinate = .mock
    try XCTAssertTrue(assertCodable(coordinates))
  }
  
  func testProfileImageCodable() throws {
    let profileImage = ProfileImage(image)
    try XCTAssertTrue(assertCodable(profileImage))
    
  }
  
  func testEmailAddressCodable() throws {
    let emailAddress = EmailAddress(rawValue: "emailAddress123@icloud.com")
    try XCTAssertTrue(assertCodable(emailAddress))
  }
  
  func testUserProfileCodable() throws {
    let userProfile = UserProfile(id: .init(), name: "Bob Joe", profileImage: ProfileImage(image), socials: socials)
    try XCTAssertTrue(assertCodable(userProfile))
  }
  
  func testSentProfileCodable() throws {
    let sentProfile = SentProfile(
      profile: UserProfile(id: .init(), name: "Bob Joe", profileImage: ProfileImage(image), socials: socials),
      sendDate: .init(),
      expirationInterval: Days(5)
    )
    try XCTAssertTrue(assertCodable(sentProfile))
  }
}

