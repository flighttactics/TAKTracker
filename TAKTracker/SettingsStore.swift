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
    
    @Published var takServerIP: String {
        didSet {
            UserDefaults.standard.set(takServerIP, forKey: "takServerIP")
        }
    }
    
    @Published var takServerPort: String {
        didSet {
            UserDefaults.standard.set(takServerPort, forKey: "takServerPort")
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

    
    init() {
        let defaultSign = "TRACKER-\(Int.random(in: 1..<40))"
        self.callSign = (UserDefaults.standard.object(forKey: "callSign") == nil ? defaultSign : UserDefaults.standard.object(forKey: "callSign") as! String)
        
        self.cotType = (UserDefaults.standard.object(forKey: "cotType") == nil ? "a-f-G-U-C" : UserDefaults.standard.object(forKey: "cotType") as! String)
        
        self.cotHow = (UserDefaults.standard.object(forKey: "cotHow") == nil ? "m-g" : UserDefaults.standard.object(forKey: "cotHow") as! String)
        
        self.takServerIP = (UserDefaults.standard.object(forKey: "takServerIP") == nil ? "" : UserDefaults.standard.object(forKey: "takServerIP") as! String)
        
        self.takServerPort = (UserDefaults.standard.object(forKey: "takServerPort") == nil ? "8089" : UserDefaults.standard.object(forKey: "takServerPort") as! String)
        
        self.staleTimeMinutes = (UserDefaults.standard.object(forKey: "staleTimeMinutes") == nil ? 5.0 : UserDefaults.standard.object(forKey: "staleTimeMinutes") as! Double)
        
        self.broadcastIntervalSeconds = (UserDefaults.standard.object(forKey: "broadcastIntervalSeconds") == nil ? 10.0 : UserDefaults.standard.object(forKey: "broadcastIntervalSeconds") as! Double)
        
        self.enableAdvancedMode = (UserDefaults.standard.object(forKey: "enableAdvancedMode") == nil ? false : UserDefaults.standard.object(forKey: "enableAdvancedMode") as! Bool)
        
        self.disableScreenSleep = (UserDefaults.standard.object(forKey: "disableScreenSleep") == nil ? true : UserDefaults.standard.object(forKey: "disableScreenSleep") as! Bool)

    }
}
