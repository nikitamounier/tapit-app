import ComposableArchitecture
import ContactsUI
import MessageUI
import MapKit
import SharedModels
import UIKit

public extension OpenSocialClient {
    static let live = Self(
        open: { social, option in
            .future { promise in
                switch social {
                case
                    .instagram(let components),
                    .snapchat(let components),
                    .twitter(let components),
                    .facebook(let components),
                    .reddit(let components),
                    .tikTok(let components),
                    .weChat(let components),
                    .github(let components),
                    .linkedIn(let components):
                    guard let url = components.url else {
                        promise(.failure(.components(.failedConvertingComponentsToURL)))
                        return
                    }
                    UIApplication.shared.open(url, options: [:]) { completion in
                        guard completion else {
                            promise(.failure(.components(.failedOpeningURL)))
                            return
                        }
                        promise(.success(.success))
                    }
                    
                case let .address(coordinates):
                    let mapItem = MKMapItem(placemark: .init(coordinate: coordinates))
                    
                    mapItem.openInMaps(launchOptions: nil, from: nil) { completion in
                        guard completion else {
                            promise(.failure(.maps(.failedOpeningMaps)))
                            return
                        }
                        promise(.success(.success))
                    }
                    
                case let .email(email):
                    guard MFMailComposeViewController.canSendMail() else {
                        guard let url = URL(string: "mailto:\(email.rawValue)") else {
                            promise(.failure(.email(.failedConvertingEmailToURL)))
                            return
                        }
                        
                        UIApplication.shared.open(url, options: [:]) { completion in
                            promise(.success(.success))
                        }
                        return
                    }
                    
                    final class Delegate: NSObject, MFMailComposeViewControllerDelegate {
                        let promise: (Result<OpenEvent, OpenError>) -> Void
                        
                        init(_ promise: @escaping (Result<OpenEvent, OpenError>) -> Void) {
                            self.promise = promise
                        }
                        
                        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                            controller.dismiss(animated: true, completion: nil)
                            promise(.success(.success))
                        }
                    }
                    
                    let controller = MFMailComposeViewController()
                    let delegate: Optional = Delegate(promise)
                    controller.mailComposeDelegate = delegate
                    controller.setToRecipients([email.rawValue])
                    
                    controller.present()
                    
                case let .phone(phoneNumber):
                    guard case let .phone(phoneOption) = option else {
                        fatalError("Chose phone without choosing a phone option, which is a logic error")
                    }
                    
                    switch phoneOption {
                    case .showUserContact:
                        let store = CNContactStore()
                        break
                        
                    case let .addContact(name, image):
                        let store = CNContactStore()
                        
                        func showContactController() {
                            let contact = CNMutableContact()
                            let nameComponents = name.components(separatedBy: .whitespaces)
                            
                            contact.givenName = nameComponents.first!
                            
                            if nameComponents.indices ~= 1 {
                                contact.familyName = nameComponents[1]
                            }
                            
                            contact.phoneNumbers = [
                                CNLabeledValue(
                                    label: CNLabelPhoneNumberMobile,
                                    value: CNPhoneNumber(stringValue: phoneNumber.numberString)
                                )
                            ]
                            
                            contact.imageData = image.pngData()
                            
                            let controller = CNContactViewController(forNewContact: contact)
                            controller.contactStore = store
                            
                            controller.present()
                            promise(.success(.success))
                        }
                        
                        switch CNContactStore.authorizationStatus(for: .contacts) {
                        case .notDetermined, .restricted, .denied:
                            store.requestAccess(for: .contacts) { access, error in
                                guard access else {
                                    promise(.failure(.phone(.failedHavingContactsAuthorization)))
                                    return
                                }
                                showContactController()
                            }
                        case .authorized:
                            showContactController()
                            
                        @unknown default:
                            promise(.failure(.phone(.failedHavingContactsAuthorization)))
                        }
                    case .call:
                        guard let phoneURL = URL(string: "tel:\(phoneNumber.numberString)") else {
                            promise(.failure(.phone(.failedConvertingPhoneToURL)))
                            return
                        }
                        UIApplication.shared.open(phoneURL, options: [:]) { completion in
                            guard completion else {
                                promise(.failure(.phone(.failedConvertingPhoneToURL)))
                                return
                            }
                            
                        }
                    }
                }
            }
        }
    )
    
}

extension UIViewController {
    func present() {
        UIApplication.shared.windows
            .first(where: \.isKeyWindow)?
            .rootViewController?
            .present(self, animated: true, completion: nil)
    }
}
