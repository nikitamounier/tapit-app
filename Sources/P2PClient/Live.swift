import Combine
import ComposableArchitecture
import GlobalQueues
import Network
import OSLog

public extension P2PClient {
    static let live = Self(
        browser: .live,
        listener: .live,
        connection: .live
    )
}

public extension BrowserClient {
    static var live: Self {
        let logger = Logger(subsystem: "P2P", category: "BrowserClient")
        return Self(
            create: { id, bonjourService in
                .run { subscriber in
                    logger.debug("Creating browser")
                    let params = NWParameters(includePeerToPeer: true, interfaceType: .wifi)
                    let browser = NWBrowser(for: .bonjour(type: bonjourService, domain: nil), using: params)
                    
                    browser.stateUpdateHandler = { state in
                        logger.log("Browser state updated to \(state.debugDescription, privacy: .public)")
                        subscriber.send(.stateUpdated(state))
                    }
                    
                    browser.browseResultsChangedHandler = { _, change in
                        logger.log("Browser results changed with \(change.debugDescription)")
                        subscriber.send(.browseResultsChanged(change))
                    }
                    
                    browserDependencies[id] = browser
                    
                    return AnyCancellable {
                        browserDependencies[id]?.cancel()
                        browserDependencies[id] = nil
                    }
                }
            },
            startBrowsing: { id in
                .fireAndForget {
                    logger.debug("Starting to browse")
                    browserDependencies[id]?.start(queue: GlobalQueues.p2pQueue)
                }
            },
            stopBrowsing: { id in
                .fireAndForget {
                    logger.debug("Stopping browsing")
                    browserDependencies[id]?.cancel()
                    browserDependencies[id] = nil
                }
            }
        )
    }
}

public extension ListenerClient {
    static var live: Self {
        let logger = Logger(subsystem: "P2P", category: "ListenerClient")
        return Self(
            create: { id, bonjourService, presharedKey, identity, myPeerID in
                .run { subscriber in
                    do {
                        logger.debug("Creating listener")
                        
                        let listener = try NWListener(using: NWParameters(secret: presharedKey, identity: identity))
                        listener.service = NWListener.Service(
                            name: myPeerID, type: bonjourService, domain: nil, txtRecord: nil
                        )
                        listener.stateUpdateHandler = { state in
                            logger.debug("Listener state updated to \(state.debugDescription, privacy: .public)")
                            subscriber.send(.stateUpdated(state))
                        }
                        listener.newConnectionHandler = { connection in
                            logger.debug("Listener found new connection \(connection.debugDescription, privacy: .public)")
                            subscriber.send(.foundNewConnection(connection))
                        }
                        
                        listenerDependencies[id] = listener
                    } catch {
                        logger.log(level: .error, "Failed to create NWListener: \(error.localizedDescription)")
                        subscriber.send(.failedToCreate)
                    }
                    
                    return AnyCancellable {
                        browserDependencies[id]?.cancel()
                        browserDependencies[id] = nil
                    }
                }
            },
            startListening: { id in
                .fireAndForget {
                    logger.debug("Starting listener")
                    listenerDependencies[id]?.start(queue: GlobalQueues.p2pQueue)
                }
            },
            stopListening: { id in
                .fireAndForget {
                    logger.debug("Stopping listener")
                    listenerDependencies[id]?.cancel()
                    listenerDependencies[id] = nil
                }
            }
        )
    }
}

public extension ConnectionClient {
    static var live: Self {
        let logger = Logger(subsystem: "P2P", category: "ConnectionClient")
        return Self(
            create: { id, connection in
                .run { subscriber in
                    logger.debug("Creating connection")
                    
                    connection.stateUpdateHandler = { state in
                        logger.debug("Connection state updated to \(state.debugDescription, privacy: .public)")
                    }
                    
                    connectionDependencies[id] = connection
                    
                    return AnyCancellable {
                        connectionDependencies[id]?.cancel()
                        connectionDependencies[id] = nil
                    }
                }
            },
            startConnection: { id in
                .run { subscriber in
                    logger.debug("Starting connection on queue")
                    connectionDependencies[id]?.start(queue: GlobalQueues.p2pQueue)
                    
                    func receiveNextMessage() {
                        connectionDependencies[id]?.receiveMessage { data, context, _, error in
                            if let message = context?.protocolMetadata(definition: TLVMessageProtocol.definition) as? NWProtocolFramer.Message {
                                logger.debug("Received message")
                                subscriber.send(.receivedMessage(type: message.messageType, data: data ?? Data()))
                            }
                            
                            if let error = error {
                                logger.log(level: .error, "Error when receiving message: \(error.localizedDescription)")
                                subscriber.send(.receivedMessageError)
                            } else {
                                receiveNextMessage()
                            }
                        }
                    }
                    receiveNextMessage()
                    
                    return AnyCancellable {}
                }
            },
            stopConnection: { id in
                .fireAndForget {
                    logger.debug("Stopping connection")
                    connectionDependencies[id]?.cancel()
                    connectionDependencies[id] = nil
                }
            },
            sendMessage: { id, messageType, content in
                .fireAndForget {
                    guard connectionDependencies[id]?.state == .ready else { return }
                    logger.debug("Sending message")
                    
                    let framerMessage = NWProtocolFramer.Message(messageType: messageType.rawValue)
                    let context = NWConnection.ContentContext(identifier: "Message", metadata: [framerMessage])
                    
                    connectionDependencies[id]?.send(
                        content: content, contentContext: context, isComplete: true, completion: .idempotent
                    )
                }
            }
        )
    }
}

private var browserDependencies: [AnyHashable: NWBrowser] = [:]
private var listenerDependencies: [AnyHashable: NWListener] = [:]
private var connectionDependencies: [AnyHashable: NWConnection] = [:]
