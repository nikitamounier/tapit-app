# Tap It

Tap It enables two people to seamlessly share their social media information (e.g. Instagram, Snapchat, phone number) by simply placing one screen on top of the other horizontally (aka "tapping"). This app is privacy-centric: all information, which is inherently sensitive, is stored on-device, and all wireless data transfer is encrypted.

## Frameworks

Tap It uses:

   *  [SwiftUI](https://developer.apple.com/documentation/swiftui)
   
   *  [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) by [Pointfree](https://www.pointfree.co)
  
   *  [Combine](https://developer.apple.com/documentation/combine)
  
   *  [Network Framework](https://developer.apple.com/documentation/network)
  
   *  [Core Location](https://developer.apple.com/documentation/corelocation) and [Core Bluetooth](https://developer.apple.com/documentation/corebluetooth) ([iBeacon](https://developer.apple.com/documentation/corelocation/clbeacon))
   
   *  [Non-Empty](https://github.com/pointfreeco/swift-nonempty)
   
   *  [Prelude](https://github.com/pointfreeco/swift-prelude)
   
   *  [PhoneNumberKit](https://github.com/marmelroy/PhoneNumberKit)
   
   *  [Difference](https://github.com/krzysztofzablocki/Difference)
   
   * [Sourcery Pro](https://merowing.info/sourcery-pro/)
  

## Motivation

When meeting someone, it takes a nail-bitingly long time to share each other's social media details. Finding the person's account, requesting them, them accepting, then vice versa; in a day and age where everyone has an account on at least two or more platforms, this takes a laughably long time.

Tap It aims to drastically streamline this process, to both parties simply pressing "share" and then placing one phone on top of the other.

## Current Progress

Tap It now has the structure to become hyper-modularized, allowing for better testing, build times, and dependency management. Development will go feature by feature, with the core business logic built before the thin, lightweight views laid on top.

## Author

Nikita Mounier, nikita.mounier@gmail.com

## Licence / Copyright

View [LICENSE.md](LICENSE.md)
