//
//  PKCS12.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/11/23.
//

import Foundation

public class PKCS12 {
    let label: String?
    let keyID: NSData?
    let trust: SecTrust?
    let certChain: [SecTrust]?
    let identity: SecIdentity?

    // Creates a PKCS12 instance from a piece of data.
    // - Parameters:
    //   - pkcs12Data:
    //          the actual data we want to parse.
    //   - password:
    //          The password required to unlock the PKCS12 data.
    public init(data: Data, password: String) {
        let importPasswordOption: NSDictionary
          = [kSecImportExportPassphrase as NSString: password]
        var items: CFArray?
        let secError: OSStatus
          = SecPKCS12Import(data as NSData,
                            importPasswordOption, &items)
        guard secError == errSecSuccess else {
            if secError == errSecAuthFailed {
                TAKLogger.debug("Fatal Error trying to import PKCS12 data: Incorrect password?")
            } else {
                TAKLogger.debug("Fatal Error trying to import PKCS12 data")
                TAKLogger.debug("Error code: \(String(describing: secError))")
            }
            SettingsStore.global.isConnectedToServer = false
            SettingsStore.global.shouldTryReconnect = false
            self.label = nil
            self.keyID = nil
            self.trust = nil
            self.certChain = nil
            self.identity = nil
            return
        }

        guard let theItemsCFArray = items else { fatalError() }
        let theItemsNSArray: NSArray = theItemsCFArray as NSArray
        guard let dictArray
          = theItemsNSArray as? [[String: AnyObject]] else {
            fatalError()
          }
        func f<T>(key: CFString) -> T? {
            for dict in dictArray {
                if let value = dict[key as String] as? T {
                    return value
                }
              }
            return nil
        }
        self.label = f(key: kSecImportItemLabel)
        self.keyID = f(key: kSecImportItemKeyID)
        self.trust = f(key: kSecImportItemTrust)
        self.certChain = f(key: kSecImportItemCertChain)
        self.identity = f(key: kSecImportItemIdentity)
    }
}

//public class PKCS12  {
//    var label:String?
//    var keyID:Data?
//    var trust:SecTrust?
//    var certChain:[SecTrust]?
//    var identity:SecIdentity?
//
//    let securityError:OSStatus
//
//    public init(data:Data, password:String) {
//
//        //self.securityError = errSecSuccess
//
//        var items:CFArray?
//        let certOptions:NSDictionary = [kSecImportExportPassphrase as NSString:password as NSString]
//
//        // import certificate to read its entries
//        self.securityError = SecPKCS12Import(data as NSData, certOptions, &items);
//
//        if securityError == errSecSuccess {
//            let certItems:Array = (items! as Array)
//            TAKLogger.debug("PKCS12: Unwrapping")
//            TAKLogger.debug(String(describing: certItems))
//            let dict:Dictionary<String, AnyObject> = certItems.first! as! Dictionary<String, AnyObject>;
//
//            self.label = dict[kSecImportItemLabel as String] as? String;
//            self.keyID = dict[kSecImportItemKeyID as String] as? Data;
//            self.trust = dict[kSecImportItemTrust as String] as! SecTrust?;
//            self.certChain = dict[kSecImportItemCertChain as String] as? Array<SecTrust>;
//            self.identity = dict[kSecImportItemIdentity as String] as! SecIdentity?;
//        }
//
//
//    }
//
//    public convenience init(mainBundleResource:String, resourceType:String, password:String) {
//        self.init(data: NSData(contentsOfFile: Bundle.main.path(forResource: mainBundleResource, ofType:resourceType)!)! as Data, password: password);
//    }
//
//    public func urlCredential()  -> URLCredential  {
//        return URLCredential(
//            identity: self.identity!,
//            certificates: self.certChain!,
//            persistence: URLCredential.Persistence.forSession);
//
//    }
//}
