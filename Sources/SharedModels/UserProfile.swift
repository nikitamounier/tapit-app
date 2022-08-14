import Foundation

public struct UserProfile: Codable, Identifiable, Equatable {
  public let id: UUID
  
  public var name: String
  public var profileImage: ProfileImage
  
  public var socials: [Social]
  
  public init(
    id: UUID,
    name: String,
    profileImage: ProfileImage,
    socials: [Social]
  ) {
    self.id = id
    self.name = name
    self.profileImage = profileImage
    self.socials = socials
  }
}
