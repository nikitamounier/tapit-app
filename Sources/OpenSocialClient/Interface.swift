import ComposableArchitecture
import SharedModels
import UIKit

public struct OpenSocialClient {
  public enum OpenEvent: Equatable {
    case success
  }
  
  public enum OpenError: Error, Equatable {
    public enum URLComponentsError {
      case failedConvertingComponentsToURL
      case failedOpeningURL
    }
    
    public enum MapsError: Equatable {
      case failedOpeningMaps
    }
    
    public enum EmailError: Equatable {
      case failedConvertingEmailToURL
    }
    
    public enum PhoneError: Equatable {
      case failedHavingContactsAuthorization
      case failedConvertingPhoneToURL
      case failedOpeningPhoneURL
    }
    
    case components(URLComponentsError)
    case maps(MapsError)
    case email(EmailError)
    case phone(PhoneError)
  }
  
  public enum Option: Equatable {
    public enum PhoneOption: Equatable {
      case showUserContact
      case addContact(name: String, image: UIImage)
      case call
    }
    
    case phone(PhoneOption)
  }
  
  public var open: (Social, Option?) -> Effect<OpenEvent, OpenError>
  
  public init(open: @escaping (Social, Option?) -> Effect<OpenEvent, OpenError>) {
    self.open = open
  }
  
  public func open(_ social: Social, option: Option?) -> Effect<OpenEvent, OpenError> {
    self.open(social, option)
  }
}
