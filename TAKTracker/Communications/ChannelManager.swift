//
//  ChannelManager.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/10/24.
//

import Foundation

class TAKChannel: Equatable {
    var name: String
    var active: Bool
    var direction: String?
    var created: Date?
    var type: String?
    var bitpos: Int?
    
    public init(name: String, active: Bool, direction: String? = nil, created: Date? = nil, type: String? = nil, bitpos: Int? = nil) {
        self.name = name
        self.active = active
        self.direction = direction
        self.created = created
        self.type = type
        self.bitpos = bitpos
    }
    
    public static func == (lhs: TAKChannel, rhs: TAKChannel) -> Bool {
        return lhs.name == rhs.name &&
        lhs.active == rhs.active &&
        lhs.direction == rhs.direction &&
        lhs.created == rhs.created &&
        lhs.type == rhs.type &&
        lhs.bitpos == rhs.bitpos
    }
}

class ChannelManager: NSObject, ObservableObject, URLSessionDelegate {
    @Published var activeChannels: [TAKChannel] = []
    @Published var isLoading = false
    let ANON_CHANNEL_NAME = "__ANON__"
    
    func retrieveChannels() {
        isLoading = true
        let requestURLString = "https://\(SettingsStore.global.takServerUrl):\(SettingsStore.global .takServerSecureAPIPort)\(AppConstants.CHANNELS_LIST_PATH)"
        TAKLogger.debug("[ChannelManager] Requesting channels from \(requestURLString)")
        let requestUrl = URL(string: requestURLString)!
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "get"

        let session = URLSession(configuration: configuration,
                                 delegate: self,
                                 delegateQueue: OperationQueue.main)

        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            TAKLogger.debug("[ChannelManager] Session Data Task Returned...")
            self.isLoading = false
            if error != nil {
                self.logChannelsError(error!.localizedDescription)
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                self.logChannelsError("Non success response code \((response as? HTTPURLResponse)?.statusCode.description ?? "UNKNOWN")")
                return
            }
            if let mimeType = response.mimeType,
                (mimeType == "application/json" || mimeType == "text/plain"),
                let data = data {
                self.storeChannelsResponse(data)
            } else {
                self.logChannelsError("Unknown response from server when attempting channel retrieval")
            }
        })

        task.resume()
    }
    
    func storeChannelsResponse(_ data: Data) {
        TAKLogger.debug("[ChannelManager] storingChannelsResponse!")
        activeChannels = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                guard let channelList = json["data"] as? [[String: Any]] else { return }
                for channelData in channelList {
                    let name = channelData["name"] as! String
                    if(name == ANON_CHANNEL_NAME) {
                        continue
                    }
                    let active = channelData["active"] as! Int == 1
                    let direction = channelData["direction"] as! String
                    let createdString = channelData["created"] as! String
                    let created = dateFormatter.date(from: createdString)
                    let type = channelData["type"] as! String
                    let bitpos = channelData["bitpos"] as? Int
                    let channel = TAKChannel(name: name, active: active, direction: direction, created: created, type: type, bitpos: bitpos)
                    activeChannels.append(channel)
                }
            }
        } catch {
            TAKLogger.error("[ChannelManager]: Error processing channel list response \(error)")
        }
    }
    
    func logChannelsError(_ err: String) {
        TAKLogger.error("[ChannelManager]: Error while trying to retrieve channels \(err)")
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        let authenticationMethod = challenge.protectionSpace.authenticationMethod

        if authenticationMethod == NSURLAuthenticationMethodClientCertificate {
            TAKLogger.error("[ChannelManager]: Server requesting identity challenge")
            guard let clientIdentity = SettingsStore.global.retrieveIdentity(label: SettingsStore.global.takServerUrl) else {
                TAKLogger.error("[ChannelManager]: Identity was not stored in the keychain")
                completionHandler(.performDefaultHandling, nil)
                return
            }
            
            TAKLogger.error("[ChannelManager]: Using client identity")
            let credential = URLCredential(identity: clientIdentity,
                                               certificates: nil,
                                                persistence: .none)
            challenge.sender?.use(credential, for: challenge)
            completionHandler(.useCredential, credential)

        } else if authenticationMethod == NSURLAuthenticationMethodServerTrust {
            TAKLogger.debug("[ChannelManager]: Server not trusted with default certs, seeing if we have custom ones")
            
            var optionalTrust: SecTrust?
            var customCerts: [SecCertificate] = []

            let trustCerts = SettingsStore.global.serverCertificateTruststore
            TAKLogger.debug("[ChannelManager]: Truststore contains \(trustCerts.count) cert(s)")
            if !trustCerts.isEmpty {
                TAKLogger.debug("[ChannelManager]: Loading Trust Store Certs")
                trustCerts.forEach { cert in
                    if let convertedCert = SecCertificateCreateWithData(nil, cert as CFData) {
                        customCerts.append(convertedCert)
                    }
                }
            }
            
            if !customCerts.isEmpty {
                TAKLogger.debug("[ChannelManager]: We have custom certs, so disable hostname validation")
                let sslWithoutHostnamePolicy = SecPolicyCreateSSL(true, nil)
                let status = SecTrustCreateWithCertificates(customCerts as AnyObject,
                                                            sslWithoutHostnamePolicy,
                                                            &optionalTrust)
                guard status == errSecSuccess else {
                    completionHandler(.performDefaultHandling, nil)
                    return
                }
            }

            if optionalTrust != nil {
                TAKLogger.debug("[ChannelManager]: Retrying with local truststore")
                let credential = URLCredential(trust: optionalTrust!)
                challenge.sender?.use(credential, for: challenge)
                completionHandler(.useCredential, credential)
            } else {
                TAKLogger.debug("[ChannelManager]: No custom truststore ultimately found")
                completionHandler(.performDefaultHandling, nil)
            }
        }
    }
    
    func toggleChannel(channel: TAKChannel) {
        TAKLogger.debug("[ChannelManager] Request to toggle visibility of \(channel.name)")
        let updatedChannels = activeChannels
        updatedChannels.first(where: {$0 == channel})?.active.toggle()
        activeChannels = updatedChannels
        // TODO: We need to send the updated channel list back upstream
        // TODO: We need to update the list from the server after publishing
    }
}
