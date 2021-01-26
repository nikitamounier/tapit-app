# Tap It

Tap It enables two people to seamlessly share their social media information (e.g. Instagram, Snapchat, phone number) by simply placing one screen on top of the other horizontally (aka "tapping"). This app is privacy-centric: all information, which is inherently sensitive, is stored on-device, and all wireless data transfer is encrypted.

## Frameworks

Tap It uses:

  * [SwiftUI](https://developer.apple.com/documentation/swiftui)
  
  * [Combine](https://developer.apple.com/documentation/combine)
  
  * [Network Framework](https://developer.apple.com/documentation/network) ([P2PShareKit](https://github.com/dobster/P2PShareKit))
  
  * [Core Location](https://developer.apple.com/documentation/corelocation) and [Core Bluetooth](https://developer.apple.com/documentation/corebluetooth) ([iBeacon](https://developer.apple.com/documentation/corelocation/clbeacon))
  
  * [Core Data](https://developer.apple.com/documentation/coredata)
  

## Motivation

When meeting someone, it takes a nail-bitingly long time to share each other's social media details. Finding the person's account, requesting them, them accepting, then vice versa; in a day and age where everyone has an account on at least two or more platforms, this takes a laughibly long time.

Tap It aims to drastically streamline this process, to both parties simply pressing "share" and then placing one phone on top of the other.

## Current Progress

Tap It is in its initial stages of development (therefore, since the code is at its most volatile, the code in this repo does not reflect my actual code) - current progress is centred around **networking**. Using the **Network** framework, Tap It transfers the data (social media details), through a secure **WebSocket connection** which simulates a peer-to-peer connection, created by the two phones' users. 


The **networking events timeline** is as follows:

1. User selects which social media accounts they want to share, and presses "share".
2. Our device creates random UInt64, and starts emitting a bluetooth signal (with custom service type) with the custom UInt64 in its characteristics data, while simultaneously browsing for other bluetooth signals of the same service type and monitoring their signal strength (RSSI).
3. In the background, our device also creates an [NWListener](https://developer.apple.com/documentation/network/nwlistener) (a server) advertising our TCP Bonjour service with a TXT record containing the custom UInt64 – which will accept any connection. 
4. When our device detects a bluetooth signal which has passed a certain RSSI threshold, meaning that the device is right next to/on top/under our device, the signal's UInt64 which they were advertising is saved and stored, and our device terminates all bluetooth activity. 
4. Our device then creates an [NWBrowser](https://developer.apple.com/documentation/network/nwlbrowser) (a client - which would be dropped the moment the NWListener accepts a connection) and searches for other devices advertising our Bonjour service. As it discovers devices, it checks if the UInt64 in their TXT record matches the one previously saved (which would mean it's the same device which passed the RSSI threshold). If so, it drops their NWListener, and connects to this device. If not, it continues browsing.
5. When the connection is made, each device (regardless of being server or client) makes sure they are approximately horizontal (±45° any direction) using the accelorometer and gyroscope ([CMAttitude](https://nshipster.com/cmdevicemotion/#getting-an-attitude)), and that their proximity sensor is triggered – meaning both phones are on top of each other screen-to-screen horizontally, as is intended in the app's user experience.
6.  An NWConnection is created as a [WebSocket connection](https://developer.apple.com/documentation/network/nwprotocolwebsocket) to provide full duplex communication between the two devices, sending the data to the other phone using the optimal interface chosen by Network Framework (might limit to peer-to-peer, depends on speed).
7. When the data transfer is completed, our device sends a message to the other device saying the transfer is done on their side. Once the client (whichever device it is) receives the message and sees if they have also finished trasnferring the data, they close the WebSocket connection.
8. The data which our device received (which is the other device's chosen social media information) is thus saved to Core Data.

## Author

Nikita Mounier, nikita.mounier@gmail.com

## Copyright

This project does not have an open-source license, hence default copyright laws apply, meaning that I retain all rights to my source code and no one may reproduce, distribute, or create derivative works from my work. Of course, you have the right to view and fork this repository, and any help in the form of pull requests would be greatly appreciated! Just had to make this little disclaimer so that no one steals. Thanks for reading this README.md!


