//
//  SettingsStore.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/12/23.
//  Adapted from https://blog.maximeheckel.com/snippets/2020-11-27-storing-user-settings-swift/
//

import UIKit

class SettingsStore: ObservableObject {
    
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
            NSLog("Setting takServerURL")
            UserDefaults.standard.set(takServerUrl, forKey: "takServerUrl")
        }
    }
    
    @Published var takServerPort: String {
        didSet {
            NSLog("Setting takServerPort")
            UserDefaults.standard.set(takServerPort, forKey: "takServerPort")
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
    
    @Published var serverCertificate: Data {
        didSet {
            UserDefaults.standard.set(serverCertificate, forKey: "serverCertificate")
        }
    }
    
    @Published var serverCertificatePassword: String {
        didSet {
            UserDefaults.standard.set(serverCertificatePassword, forKey: "serverCertificatePassword")
        }
    }
    
    @Published var userCertificate: Data {
        didSet {
            UserDefaults.standard.set(userCertificate, forKey: "userCertificate")
        }
    }
    
    @Published var userCertificatePassword: String {
        didSet {
            UserDefaults.standard.set(userCertificatePassword, forKey: "userCertificatePassword")
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

    
    init() {
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

    }
}
