//
//  CertificateManager.swift
//  TAKTracker
//
//  Created by Cory Foy on 9/9/23.
//

import Foundation

enum KeychainError: Error {
    // Attempted read for an item that does not exist.
    case itemNotFound
    
    // Attempted save to override an existing item.
    // Use update instead of save to update existing items
    case duplicateItem
    
    // A read of an item in any format other than Data
    case invalidItemFormat
    
    // Any operation result status than errSecSuccess
    case unexpectedStatus(OSStatus)
    
    case generateKeyPairFailed(any Error)
    
    case publicKeyNotFound(OSStatus)
    
    case privateKeyNotFound(OSStatus)
    
    case cannotAddPublicKeyToKeychain(OSStatus)
    
    case invalidX509Data
    
    case cannotDeletePublicKeyFromKeychain(OSStatus)
    
    case cannotCreateIdentityPersistentRef(OSStatus)
    
    case cannotAddCertificateToKeychain(OSStatus)
}

// Code adapted from https://stackoverflow.com/a/50321496
class CertificateManager {
    // Returns the private key binary data in ASN1 format (DER encoded without the key usage header)
    static func generateKeyPairWithPublicKeyAsGenericPassword(privateKeyTag: String, publicKeyAccount: String, publicKeyService: String) throws -> Data {
        var error: Unmanaged<CFError>?

        let privateKeyAttr: [NSString: Any] = [
            kSecAttrApplicationTag: privateKeyTag.data(using: .utf8)!,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            kSecAttrIsPermanent: true ]

        let keyPairAttr: [NSString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits: 2048,
            kSecPrivateKeyAttrs: privateKeyAttr ]
        
        guard let privateKey = SecKeyCreateRandomKey(keyPairAttr as CFDictionary, &error) else {
            throw KeychainError.generateKeyPairFailed(error!.takeRetainedValue() as Error)
        }

        let findPrivKeyArgs: [NSString: Any] = [
            kSecClass: kSecClassKey,
            kSecValueRef: privateKey,
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecReturnData: true ]

        var resultRef:AnyObject?
        let status = SecItemCopyMatching(findPrivKeyArgs as CFDictionary, &resultRef)
        guard status == errSecSuccess, let privateKeyData = resultRef as? Data else {
            TAKLogger.error("Private Key not found: \(status))")
            throw KeychainError.privateKeyNotFound(status)
        }

        return privateKeyData
    }
    
    
    static func addIdentity(clientCertificate: Data, label: String) throws {
        TAKLogger.info("Adding client certificate to keychain with label \(label)")

        guard let certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, clientCertificate as CFData) else {
            TAKLogger.error("Could not create certificate, data was not valid DER encoded X509 cert")
            throw KeychainError.invalidX509Data
        }

        // Add the client certificate to the keychain to create the identity
        let addArgs: [NSString: Any] = [
            kSecClass: kSecClassCertificate,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            kSecAttrLabel: label,
            kSecValueRef: certificateRef,
            kSecReturnAttributes: true ]

        var resultRef: AnyObject?
        let addStatus = SecItemAdd(addArgs as CFDictionary, &resultRef)
        guard addStatus == errSecSuccess, let certAttrs = resultRef as? [NSString: Any] else {
            TAKLogger.error("Failed to add certificate to keychain, error: \(addStatus)")
            throw KeychainError.cannotAddCertificateToKeychain(addStatus)
        }

        // Retrieve the client certificate issuer and serial number which will be used to retrieve the identity
        let issuer = certAttrs[kSecAttrIssuer] as! Data
        let serialNumber = certAttrs[kSecAttrSerialNumber] as! Data
        
        let issuerString = String(data: issuer, encoding: String.Encoding.utf8) as String?
        let serialNumberString = String(data: serialNumber, encoding: String.Encoding.utf8) as String?
        
        TAKLogger.debug(String(describing: certAttrs))
        TAKLogger.debug("Issuer: " + String(describing: issuer))
        TAKLogger.debug("serialNumber: " + String(describing: serialNumber))
        TAKLogger.debug("Issuer: " + String(describing: issuerString))
        TAKLogger.debug("serialNumber: " + String(describing: serialNumberString))

        // Retrieve a persistent reference to the identity consisting of the client certificate and the pre-existing private key
        let copyArgs: [NSString: Any] = [
            kSecClass: kSecClassIdentity,
            //kSecAttrIssuer: issuer,
            //kSecAttrSerialNumber: serialNumber,
            kSecAttrLabel: label,
            kSecReturnPersistentRef: true] // we need returnPersistentRef here or the keychain makes a temporary identity that doesn't stick around, even though we don't use the persistentRef

        let copyStatus = SecItemCopyMatching(copyArgs as CFDictionary, &resultRef);
        guard copyStatus == errSecSuccess, let _ = resultRef as? Data else {
            TAKLogger.error("Identity not found, error: \(copyStatus) - returned attributes were \(certAttrs)")
            throw KeychainError.cannotCreateIdentityPersistentRef(addStatus)
        }

        // no CFRelease(identityRef) due to swift
    }
    
    
    // Remember any OBJECTIVE-C code that calls this method needs to call CFRetain
    static func getIdentity(label: String) -> SecIdentity? {
        let copyArgs: [NSString: Any] = [
            kSecClass: kSecClassIdentity,
            kSecAttrLabel: label,
            kSecReturnRef: true ]

        var resultRef: AnyObject?
        let copyStatus = SecItemCopyMatching(copyArgs as CFDictionary, &resultRef)
        guard copyStatus == errSecSuccess else {
            TAKLogger.error("Identity not found, error: \(copyStatus)")
            return nil
        }

        // back when this function was all ObjC we would __bridge_transfer into ARC, but swift can't do that
        // It wants to manage CF types on it's own which is fine, except they release when we return them out
        // back into ObjC code.
        return (resultRef as! SecIdentity)
    }

    // Remember any OBJECTIVE-C code that calls this method needs to call CFRetain
    static func getCertificate(label: String) -> SecCertificate? {
        let copyArgs: [NSString: Any] = [
            kSecClass: kSecClassCertificate,
            kSecAttrLabel: label,
            kSecReturnRef: true]

        var resultRef: AnyObject?
        let copyStatus = SecItemCopyMatching(copyArgs as CFDictionary, &resultRef)
        guard copyStatus == errSecSuccess else {
            TAKLogger.error("Identity not found, error: \(copyStatus)")
            return nil
        }

        // back when this function was all ObjC we would __bridge_transfer into ARC, but swift can't do that
        // It wants to manage CF types on it's own which is fine, except they release when we return them out
        // back into ObjC code.
        return (resultRef as! SecCertificate)
    }
}
