//
//  SettingsStore.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/12/23.
//  Adapted from https://blog.maximeheckel.com/snippets/2020-11-27-storing-user-settings-swift/
//

import MapKit
import SwiftTAK
import UIKit

class SettingsStore: ObservableObject {
    static let global = SettingsStore()
    
    static func generateDefaultCallSign() -> String {
        
        let appendValue: String = Int.random(in: 1..<40).description
        
        guard let firstIdBlock = AppConstants.getClientID().split(separator: "-").first else {
            return "TRACKER-\(appendValue)"
        }
        
        if(firstIdBlock.isEmpty) {
            return "TRACKER-\(appendValue)"
        }
        
        return "TRACKER-\(String(firstIdBlock))"
    }
    
    
    func storeIdentity(identity: SecIdentity, label: String) {
        
        //Clean up any existing identities
        clearAllIdentities()
        
        //Add the new identity in
        let addQuery: [String: Any] = [kSecValueRef as String: identity,
                                       kSecAttrLabel as String: label]

        TAKLogger.debug("[SettingsStore]: Adding Identity to Keychain")
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            TAKLogger.error("[SettingsStore]: Error adding identity to keychain \(String(describing: status))")
            return
        }
    }
    
    func retrieveIdentity(label: String) -> SecIdentity? {
        let getquery: [String: Any] = [kSecClass as String:  kSecClassIdentity,
                                       kSecAttrLabel as String: label,
                                       kSecReturnRef as String: kCFBooleanTrue!]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            TAKLogger.error("[SettingsStore]: Identity was not stored in the keychain \(String(describing: status))")
            return nil
        }
        let clientIdentity = item as! SecIdentity
        return clientIdentity
    }
    
    func clearAllIdentities() {
        TAKLogger.debug("[SettingsStore]: Clearing out all existing identities")
        let cleanUpQuery: [String: Any] = [kSecClass as String:  kSecClassIdentity]
        SecItemDelete(cleanUpQuery as CFDictionary)
    }
    
    @Published var callSign: String {
        didSet {
            UserDefaults.standard.set(callSign, forKey: "callSign")
        }
    }
    
    @Published var team: String {
        didSet {
            UserDefaults.standard.set(team, forKey: "team")
        }
    }
    
    @Published var role: String {
        didSet {
            UserDefaults.standard.set(role, forKey: "role")
        }
    }
    
    @Published var cotType: String {
        didSet {
            UserDefaults.standard.set(cotType, forKey: "cotType")
        }
    }
    
    @Published var cotHow: String {
        didSet {
            UserDefaults.standard.set(cotHow, forKey: "cotHow")
        }
    }
    
    @Published var takServerUrl: String {
        didSet {
            UserDefaults.standard.set(takServerUrl, forKey: "takServerUrl")
        }
    }
    
    @Published var takServerPort: String {
        didSet {
            UserDefaults.standard.set(takServerPort, forKey: "takServerPort")
        }
    }
    
    @Published var takServerCSRPort: String {
        didSet {
            UserDefaults.standard.set(takServerCSRPort, forKey: "takServerCSRPort")
        }
    }
    
    @Published var takServerSecureAPIPort: String {
        didSet {
            UserDefaults.standard.set(takServerSecureAPIPort, forKey: "takServerSecureAPIPort")
        }
    }
    
    @Published var takServerProtocol: String {
        didSet {
            UserDefaults.standard.set(takServerProtocol, forKey: "takServerProtocol")
        }
    }
    
    @Published var staleTimeMinutes: Double {
        didSet {
            UserDefaults.standard.set(staleTimeMinutes, forKey: "staleTimeMinutes")
        }
    }
    
    @Published var broadcastIntervalSeconds: Double {
        didSet {
            UserDefaults.standard.set(broadcastIntervalSeconds, forKey: "broadcastIntervalSeconds")
        }
    }
    
    @Published var enableAdvancedMode: Bool {
        didSet {
            UserDefaults.standard.set(enableAdvancedMode, forKey: "enableAdvancedMode")
        }
    }
    
    @Published var disableScreenSleep: Bool {
        didSet {
            UserDefaults.standard.set(disableScreenSleep, forKey: "disableScreenSleep")
        }
    }
    
    @Published var serverCertificateTruststore: [Data] {
        didSet {
            UserDefaults.standard.set(serverCertificateTruststore, forKey: "serverCertificateTruststore")
            UserDefaults.standard.set(true, forKey: "shouldTryReconnect")
        }
    }
    
    @Published var serverCertificate: Data {
        didSet {
            UserDefaults.standard.set(serverCertificate, forKey: "serverCertificate")
            UserDefaults.standard.set(true, forKey: "shouldTryReconnect")
        }
    }
    
    @Published var serverCertificatePassword: String {
        didSet {
            UserDefaults.standard.set(serverCertificatePassword, forKey: "serverCertificatePassword")
            UserDefaults.standard.set(true, forKey: "shouldTryReconnect")
        }
    }
    
    @Published var userCertificate: Data {
        didSet {
            UserDefaults.standard.set(userCertificate, forKey: "userCertificate")
            UserDefaults.standard.set(true, forKey: "shouldTryReconnect")
        }
    }
    
    @Published var userCertificatePassword: String {
        didSet {
            UserDefaults.standard.set(userCertificatePassword, forKey: "userCertificatePassword")
            UserDefaults.standard.set(true, forKey: "shouldTryReconnect")
        }
    }
    
    @Published var takServerUsername: String {
        didSet {
            UserDefaults.standard.set(takServerUsername, forKey: "takServerUsername")
        }
    }
    
    @Published var takServerPassword: String {
        didSet {
            UserDefaults.standard.set(takServerPassword, forKey: "takServerPassword")
        }
    }
    
    @Published var shouldTryReconnect: Bool {
        didSet {
            UserDefaults.standard.set(shouldTryReconnect, forKey: "shouldTryReconnect")
        }
    }
    
    @Published var isConnectedToServer: Bool {
        didSet {
            UserDefaults.standard.set(isConnectedToServer, forKey: "isConnectedToServer")
        }
    }
    
    @Published var isConnectingToServer: Bool {
        didSet {
            UserDefaults.standard.set(isConnectingToServer, forKey: "isConnectingToServer")
        }
    }
    
    @Published var connectionStatus: String {
        didSet {
            UserDefaults.standard.set(connectionStatus, forKey: "connectionStatus")
        }
    }
    
    @Published var takServerChanged: Bool {
        didSet {
            UserDefaults.standard.set(takServerChanged, forKey: "takServerChanged")
        }
    }
    
    @Published var mapTypeDisplay: UInt {
        didSet {
            UserDefaults.standard.set(mapTypeDisplay, forKey: "mapTypeDisplay")
        }
    }
    
    @Published var isAlertActivated: Bool {
        didSet {
            UserDefaults.standard.set(isAlertActivated, forKey: "isAlertActivated")
        }
    }
    
    @Published var activeAlertType: String {
        didSet {
            UserDefaults.standard.set(activeAlertType, forKey: "activeAlertType")
        }
    }
    
    @Published var hasOnboarded: Bool {
        didSet {
            UserDefaults.standard.set(hasOnboarded, forKey: "hasOnboarded")
        }
    }
    
    @Published var lastAppVersionRun: String {
        didSet {
            UserDefaults.standard.set(lastAppVersionRun, forKey: "lastAppVersionRun")
        }
    }

    private init() {
        let defaultSign = SettingsStore.generateDefaultCallSign()
        self.lastAppVersionRun = (UserDefaults.standard.object(forKey: "lastAppVersionRun") == nil ? "" : UserDefaults.standard.object(forKey: "lastAppVersionRun") as! String)
        
        self.callSign = (UserDefaults.standard.object(forKey: "callSign") == nil ? defaultSign : UserDefaults.standard.object(forKey: "callSign") as! String)
        
        self.team = (UserDefaults.standard.object(forKey: "team") == nil ? TeamColor.Cyan.rawValue : UserDefaults.standard.object(forKey: "team") as! String)
        
        self.role = (UserDefaults.standard.object(forKey: "role") == nil ? TeamRole.TeamMember.rawValue : UserDefaults.standard.object(forKey: "role") as! String)
        
        self.cotType = (UserDefaults.standard.object(forKey: "cotType") == nil ? "a-f-G-U-C" : UserDefaults.standard.object(forKey: "cotType") as! String)
        
        self.cotHow = (UserDefaults.standard.object(forKey: "cotHow") == nil ? "m-g" : UserDefaults.standard.object(forKey: "cotHow") as! String)
        
        self.takServerUrl = (UserDefaults.standard.object(forKey: "takServerUrl") == nil ? "" : UserDefaults.standard.object(forKey: "takServerUrl") as! String)
        
        self.takServerPort = (UserDefaults.standard.object(forKey: "takServerPort") == nil ? TAKConstants.DEFAULT_STREAMING_PORT : UserDefaults.standard.object(forKey: "takServerPort") as! String)
        
        self.takServerCSRPort = (UserDefaults.standard.object(forKey: "takServerCSRPort") == nil ? TAKConstants.DEFAULT_CSR_PORT : UserDefaults.standard.object(forKey: "takServerCSRPort") as! String)
        
        self.takServerSecureAPIPort = (UserDefaults.standard.object(forKey: "takServerSecureAPIPort") == nil ? TAKConstants.DEFAULT_SECURE_API_PORT : UserDefaults.standard.object(forKey: "takServerSecureAPIPort") as! String)
        
        self.takServerProtocol = (UserDefaults.standard.object(forKey: "takServerProtocol") == nil ? "ssl" : UserDefaults.standard.object(forKey: "takServerProtocol") as! String)
        
        self.staleTimeMinutes = (UserDefaults.standard.object(forKey: "staleTimeMinutes") == nil ? 5.0 : UserDefaults.standard.object(forKey: "staleTimeMinutes") as! Double)
        
        self.broadcastIntervalSeconds = (UserDefaults.standard.object(forKey: "broadcastIntervalSeconds") == nil ? 10.0 : UserDefaults.standard.object(forKey: "broadcastIntervalSeconds") as! Double)
        
        self.enableAdvancedMode = (UserDefaults.standard.object(forKey: "enableAdvancedMode") == nil ? false : UserDefaults.standard.object(forKey: "enableAdvancedMode") as! Bool)
        
        self.disableScreenSleep = (UserDefaults.standard.object(forKey: "disableScreenSleep") == nil ? true : UserDefaults.standard.object(forKey: "disableScreenSleep") as! Bool)
        
        self.serverCertificateTruststore = (UserDefaults.standard.object(forKey: "serverCertificateTruststore") == nil ? [] : UserDefaults.standard.object(forKey: "serverCertificateTruststore") as! [Data])
        
        self.serverCertificate = (UserDefaults.standard.object(forKey: "serverCertificate") == nil ? Data() : UserDefaults.standard.object(forKey: "serverCertificate") as! Data)
        
        self.serverCertificatePassword = (UserDefaults.standard.object(forKey: "serverCertificatePassword") == nil ? "" : UserDefaults.standard.object(forKey: "serverCertificatePassword") as! String)
        
        self.userCertificate = (UserDefaults.standard.object(forKey: "userCertificate") == nil ? Data() : UserDefaults.standard.object(forKey: "userCertificate") as! Data)
        
        self.userCertificatePassword = (UserDefaults.standard.object(forKey: "userCertificatePassword") == nil ? "" : UserDefaults.standard.object(forKey: "userCertificatePassword") as! String)
        
        self.takServerUsername = (UserDefaults.standard.object(forKey: "takServerUsername") == nil ? "" : UserDefaults.standard.object(forKey: "takServerUsername") as! String)
        
        self.takServerPassword = (UserDefaults.standard.object(forKey: "takServerPassword") == nil ? "" : UserDefaults.standard.object(forKey: "takServerPassword") as! String)
        
        self.shouldTryReconnect = (UserDefaults.standard.object(forKey: "shouldTryReconnect") == nil ? true : UserDefaults.standard.object(forKey: "shouldTryReconnect") as! Bool)
        
        self.isConnectedToServer = (UserDefaults.standard.object(forKey: "isConnectedToServer") == nil ? false : UserDefaults.standard.object(forKey: "isConnectedToServer") as! Bool)
        
        self.isConnectingToServer = (UserDefaults.standard.object(forKey: "isConnectingToServer") == nil ? false : UserDefaults.standard.object(forKey: "isConnectingToServer") as! Bool)
        
        self.connectionStatus = (UserDefaults.standard.object(forKey: "connectionStatus") == nil ? "Disconnected" : UserDefaults.standard.object(forKey: "connectionStatus") as! String)
        
        self.takServerChanged = (UserDefaults.standard.object(forKey: "takServerChanged") == nil ? false : UserDefaults.standard.object(forKey: "takServerChanged") as! Bool)
        
        self.mapTypeDisplay = (UserDefaults.standard.object(forKey: "mapTypeDisplay") == nil ? MKMapType.standard.rawValue : UserDefaults.standard.object(forKey: "mapTypeDisplay") as! UInt)

        self.isAlertActivated = (UserDefaults.standard.object(forKey: "isAlertActivated") == nil ? false : UserDefaults.standard.object(forKey: "isAlertActivated") as! Bool)
        
        self.activeAlertType = (UserDefaults.standard.object(forKey: "activeAlertType") == nil ? "" : UserDefaults.standard.object(forKey: "activeAlertType") as! String)
        
        self.hasOnboarded = (UserDefaults.standard.object(forKey: "hasOnboarded") == nil ? false : UserDefaults.standard.object(forKey: "hasOnboarded") as! Bool)
    }
}
