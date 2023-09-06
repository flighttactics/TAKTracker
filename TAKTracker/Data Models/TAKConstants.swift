//
//  TAKConstants.swift
//  TAKTracker
//
//  Created by Cory Foy on 8/25/23.
//

import Foundation
import UIKit

struct TAKConstants {
    // Ports
    static let DEFAULT_CSR_PORT = "8446"
    static let DEFAULT_WEB_PORT = "8443"
    static let DEFAULT_STREAMING_PORT = "8089"
    
    // Paths
    static let MANIFEST_FILE = "manifest.xml"
    static let PREF_FILE_SUFFIX = ".pref"
    static let CSR_PATH = "/api/tls/signClient?clientUid=$UID&version=$VERSION"
    func certificateSigningPath(clientUid: String, appVersion: String) -> String {
        return TAKConstants.CSR_PATH
            .replacingOccurrences(of: "$UID", with: clientUid)
            .replacingOccurrences(of: "$VERSION", with: appVersion)
    }
    
    func getAppVersion() -> String {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return appVersion
        }
        return "v1.0"
    }
    
    func getClientID() -> String {
        if let identifier = UIDevice.current.identifierForVendor {
            return identifier.uuidString
        }
        return UUID().uuidString
    }
}
