//
//  TAKConstants.swift
//  TAKTracker
//
//  Created by Cory Foy on 8/25/23.
//

import Foundation
import UIKit

struct AppConstants {
    // App Information
    static let TAK_PLATFORM = "iTAK-Tracker-CIV"    
    
    // Ports
    static let DEFAULT_CSR_PORT = "8446"
    static let DEFAULT_WEB_PORT = "8443"
    static let DEFAULT_STREAMING_PORT = "8089"
    static let UDP_BROADCAST_PORT = "6969"
    
    // Paths
    static let MANIFEST_FILE = "manifest.xml"
    static let PREF_FILE_SUFFIX = ".pref"
    
    static let CERT_CONFIG_PATH = "/Marti/api/tls/config"
    static let CSR_PATH = "/Marti/api/tls/signClient/v2?clientUid=$UID&version=$VERSION"
    
    // static let SITX_DOMAIN = "parteamconnect.com"
    // static let SITX_AUTH_CODE_REQUEST_PATH = "/api/v1/device/authorization/code"
    // static let SITX_AUTH_CODE_TOKEN_PATH = "/api/v1/device/authorization/token"
    // static let SITX_AUTH_CODE_ACCESS_TOKEN_PATH = "/api/v1/access/token"
    
    static let UDP_BROADCAST_URL = "239.2.3.1"
    
    // Helper Functions
    
    // static func sitxUrl(path: String) -> String {
    //     return "\(SettingsStore.global.sitxDomain).\(SITX_DOMAIN)\(path)"
    // }
    
    static func certificateSigningPath(clientUid: String, appVersion: String) -> String {
        return AppConstants.CSR_PATH
            .replacingOccurrences(of: "$UID", with: clientUid)
            .replacingOccurrences(of: "$VERSION", with: appVersion)
    }
    
    static func getAppReleaseVersion() -> String {
        if let appInfo = Bundle.main.infoDictionary {
            if let appVersion = appInfo["CFBundleShortVersionString"] as? String {
                return appVersion
            }
        }
        return "1.u"
    }
    
    static func getAppReleaseAndBuildVersion() -> String {
        if let appInfo = Bundle.main.infoDictionary {
            if let appVersion = appInfo["CFBundleShortVersionString"] as? String,
               let buildNumber = appInfo["CFBundleVersion"] as? String {
                return "\(appVersion).\(buildNumber)"
            }
        }
        return "0.0.u"
    }
    
    static func getAppName() -> String {
        if let appInfo = Bundle.main.infoDictionary {
            if let appName = appInfo["CFBundleName"] as? String {
                return appName
            }
        }
        return TAK_PLATFORM
    }
    
    static func getClientID() -> String {
        if let identifier = UIDevice.current.identifierForVendor {
            return identifier.uuidString
        }
        TAKLogger.debug("Failed to get identifierForVendor. Returning random clientID")
        return UUID().uuidString
    }
    
    static func getPhoneModel() -> String {
        return UIDevice.current.model
    }
    
    static func getPhoneOS() -> String {
        return UIDevice.current.systemName
    }
    
    static func getPhoneBatteryStatus() -> Float {
        if (UIDevice.current.isBatteryMonitoringEnabled) {
            return UIDevice.current.batteryLevel
        } else {
            TAKLogger.debug("Battery Monitoring is not enabled for this device!")
            return 0.0
        }
    }
}
