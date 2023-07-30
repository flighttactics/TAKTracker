//
//  SettingsStore.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/12/23.
//  Adapted from https://blog.maximeheckel.com/snippets/2020-11-27-storing-user-settings-swift/
//

import UIKit

class SettingsStore: ObservableObject {
    static let global = SettingsStore()
    
    /*
     Settings Remaining:
        - TAK Server Username
        - TAK Server Password
        - TAK Server Certificate (+ Password)
        - TAK Server Client Certificate (+ Password)
        - Metric vs Imperial
     */
    
    @Published var callSign: String {
        didSet {
            UserDefaults.standard.set(callSign, forKey: "callSign")
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
            TAKLogger.debug("Setting takServerURL")
            UserDefaults.standard.set(takServerUrl, forKey: "takServerUrl")
            UserDefaults.standard.set(true, forKey: "shouldTryReconnect")
        }
    }
    
    @Published var takServerPort: String {
        didSet {
            TAKLogger.debug("Setting takServerPort")
            UserDefaults.standard.set(takServerPort, forKey: "takServerPort")
            UserDefaults.standard.set(true, forKey: "shouldTryReconnect")
        }
    }
    
    @Published var takServerProtocol: String {
        didSet {
            UserDefaults.standard.set(takServerProtocol, forKey: "takServerProtocol")
            UserDefaults.standard.set(true, forKey: "shouldTryReconnect")
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
            UserDefaults.standard.set(true, forKey: "shouldTryReconnect")
        }
    }
    
    @Published var takServerPassword: String {
        didSet {
            UserDefaults.standard.set(takServerPassword, forKey: "takServerPassword")
            UserDefaults.standard.set(true, forKey: "shouldTryReconnect")
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
    
    @Published var connectionStatus: String {
        didSet {
            UserDefaults.standard.set(connectionStatus, forKey: "connectionStatus")
        }
    }
    
    private init() {
        let defaultSign = "TRACKER-\(Int.random(in: 1..<40))"
        self.callSign = (UserDefaults.standard.object(forKey: "callSign") == nil ? defaultSign : UserDefaults.standard.object(forKey: "callSign") as! String)
        
        self.cotType = (UserDefaults.standard.object(forKey: "cotType") == nil ? "a-f-G-U-C" : UserDefaults.standard.object(forKey: "cotType") as! String)
        
        self.cotHow = (UserDefaults.standard.object(forKey: "cotHow") == nil ? "m-g" : UserDefaults.standard.object(forKey: "cotHow") as! String)
        
        self.takServerUrl = (UserDefaults.standard.object(forKey: "takServerUrl") == nil ? "" : UserDefaults.standard.object(forKey: "takServerUrl") as! String)
        
        self.takServerPort = (UserDefaults.standard.object(forKey: "takServerPort") == nil ? "8089" : UserDefaults.standard.object(forKey: "takServerPort") as! String)
        
        self.takServerProtocol = (UserDefaults.standard.object(forKey: "takServerProtocol") == nil ? "ssl" : UserDefaults.standard.object(forKey: "takServerProtocol") as! String)
        
        self.staleTimeMinutes = (UserDefaults.standard.object(forKey: "staleTimeMinutes") == nil ? 5.0 : UserDefaults.standard.object(forKey: "staleTimeMinutes") as! Double)
        
        self.broadcastIntervalSeconds = (UserDefaults.standard.object(forKey: "broadcastIntervalSeconds") == nil ? 10.0 : UserDefaults.standard.object(forKey: "broadcastIntervalSeconds") as! Double)
        
        self.enableAdvancedMode = (UserDefaults.standard.object(forKey: "enableAdvancedMode") == nil ? false : UserDefaults.standard.object(forKey: "enableAdvancedMode") as! Bool)
        
        self.disableScreenSleep = (UserDefaults.standard.object(forKey: "disableScreenSleep") == nil ? true : UserDefaults.standard.object(forKey: "disableScreenSleep") as! Bool)
        
        self.serverCertificate = (UserDefaults.standard.object(forKey: "serverCertificate") == nil ? Data() : UserDefaults.standard.object(forKey: "serverCertificate") as! Data)
        
        self.serverCertificatePassword = (UserDefaults.standard.object(forKey: "serverCertificatePassword") == nil ? "" : UserDefaults.standard.object(forKey: "serverCertificatePassword") as! String)
        
        self.userCertificate = (UserDefaults.standard.object(forKey: "userCertificate") == nil ? Data() : UserDefaults.standard.object(forKey: "userCertificate") as! Data)
        
        self.userCertificatePassword = (UserDefaults.standard.object(forKey: "userCertificatePassword") == nil ? "" : UserDefaults.standard.object(forKey: "userCertificatePassword") as! String)
        
        self.takServerUsername = (UserDefaults.standard.object(forKey: "takServerUsername") == nil ? "" : UserDefaults.standard.object(forKey: "takServerUsername") as! String)
        
        self.takServerPassword = (UserDefaults.standard.object(forKey: "takServerPassword") == nil ? "" : UserDefaults.standard.object(forKey: "takServerPassword") as! String)
        
        self.shouldTryReconnect = (UserDefaults.standard.object(forKey: "shouldTryReconnect") == nil ? true : UserDefaults.standard.object(forKey: "shouldTryReconnect") as! Bool)
        
        self.isConnectedToServer = (UserDefaults.standard.object(forKey: "isConnectedToServer") == nil ? false : UserDefaults.standard.object(forKey: "isConnectedToServer") as! Bool)
        
        self.connectionStatus = (UserDefaults.standard.object(forKey: "connectionStatus") == nil ? "Disconnected" : UserDefaults.standard.object(forKey: "connectionStatus") as! String)

    }
}
