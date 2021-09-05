import CryptoKit
import Network

public extension NWParameters {

    // Create parameters for use with Connection and Listener.
    convenience init(secret: String, identity: String) {
        
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.enableKeepalive = true
        tcpOptions.keepaliveIdle = 2
                
        let tlsOptions = NWProtocolTLS.Options()
        
        let authenticationKey = SymmetricKey(data: secret.data(using: .utf8)!)
        var authenticationCode = HMAC<SHA256>.authenticationCode(for: identity.data(using: .utf8)!, using: authenticationKey)
        let authenticationDispatchData = withUnsafeBytes(of: &authenticationCode) { (ptr: UnsafeRawBufferPointer) in
            DispatchData(bytes: ptr)
        }
        let psk = authenticationDispatchData as __DispatchData
        
        var identityData = identity.data(using: .unicode)!
        let identityDispatchData = withUnsafeBytes(of: &identityData) { (ptr: UnsafeRawBufferPointer) in
            DispatchData(bytes: ptr)
        }
        let psk_identity = identityDispatchData as __DispatchData
        
        sec_protocol_options_add_pre_shared_key(tlsOptions.securityProtocolOptions, psk, psk_identity)

        let ciphersuite = tls_ciphersuite_t(rawValue: TLS_PSK_WITH_AES_128_GCM_SHA256)!
        sec_protocol_options_append_tls_ciphersuite(tlsOptions.securityProtocolOptions, ciphersuite)

        self.init(tls: tlsOptions, tcp: tcpOptions)

        self.includePeerToPeer = true

        let customProtocol = NWProtocolFramer.Options(definition: TLVMessageProtocol.definition)
        self.defaultProtocolStack.applicationProtocols.insert(customProtocol, at: 0)
    }
    
    convenience init(enableKeepAlive: Bool, keepAliveIdle: Int, includePeerToPeer: Bool) {
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.enableKeepalive = enableKeepAlive
        tcpOptions.keepaliveIdle = keepAliveIdle
        
        self.init(tls: nil, tcp: tcpOptions)
        self.includePeerToPeer = includePeerToPeer
        
        let customProtocol = NWProtocolFramer.Options(definition: TLVMessageProtocol.definition)
        self.defaultProtocolStack.applicationProtocols.insert(customProtocol, at: 0)
    }
    
    convenience init(includePeerToPeer: Bool, interfaceType: NWInterface.InterfaceType) {
        self.init()
        self.includePeerToPeer = includePeerToPeer
        self.requiredInterfaceType = interfaceType
    }
}

