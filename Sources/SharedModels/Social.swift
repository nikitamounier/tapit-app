import Foundation
import MapKit
@_exported import PhoneNumberKit
import SwiftUI

public enum Social: Codable, Hashable, Identifiable, Equatable {
  case instagram(URLComponents)
  case snapchat(URLComponents)
  case twitter(URLComponents)
  case facebook(URLComponents)
  case reddit(URLComponents)
  case tikTok(URLComponents)
  case weChat(URLComponents)
  case github(URLComponents)
  case linkedIn(URLComponents)
  case address(Coordinate)
  case email(EmailAddress)
  case phone(PhoneNumber)
  
  public var id: Int {
    self.hashValue
  }
}

public extension Image {
  init(social: Social) {
    self.init("Whatsapp")
//    switch social {
//    case .instagram:
//      self.init("Instagram")
//    case .snapchat:
//      self.init("Snapchat")
//    case .twitter:
//      self.init("Twitter")
//    case .facebook:
//      self.init("Facebook")
//    case .reddit:
//      self.init("Reddit")
//    case .tikTok:
//      self.init("TikTok")
//    case .weChat:
//      self.init("WeChat")
//    case .github:
//      self.init("Github")
//    case .linkedIn:
//      self.init("LinkedIn")
//    case .address:
//      self.init("Address")
//    case .email:
//      self.init("Email")
//    case .phone:
//      self.init("Phone")
//    }
  }
}

public extension Text {
  init(social: Social) {
    switch social {
    case .instagram:
      self.init("Instagram")
    case .snapchat:
      self.init("Snapchat")
    case .twitter:
      self.init("Twitter")
    case .facebook:
      self.init("Facebook")
    case .reddit:
      self.init("Reddit")
    case .tikTok:
      self.init("TikTok")
    case .weChat:
      self.init("WeChat")
    case .github:
      self.init("Github")
    case .linkedIn:
      self.init("LinkedIn")
    case .address:
      self.init("Address")
    case .email:
      self.init("Email")
    case .phone:
      self.init("Phone")
    }
  }
}
