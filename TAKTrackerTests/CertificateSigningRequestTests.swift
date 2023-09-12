//
//  CertificateSigningRequestTests.swift
//  TAKTrackerTests
//
//  Created by Cory Foy on 9/5/23.
//

import Crypto
import _CryptoExtras
import Foundation
import SwiftASN1
import X509
import XCTest

final class CertificateSigningRequestTests: XCTestCase {
    
    var certString = ""
    var privateKey = ""
    let hostName = "tak.flighttactics.com"
    let privateKeyTag = "tak.flighttactics.com-pk"
    let publicKeyAccount = "foyc"
    let publicKeyService = "tak.flighttactics.com-public"
    let defaultPassword = "atakatak"

    override func setUpWithError() throws {
        certString = """
-----BEGIN CERTIFICATE-----
MIIDUzCCAjugAwIBAgIEI5gCQzANBgkqhkiG9w0BAQsFADBuMQswCQYDVQQGEwJV
UzELMAkGA1UECBMCTkMxFTATBgNVBAcTDEhJTExTQk9ST1VHSDEWMBQGA1UEChMN
RkxJR0hUVEFDVElDUzEMMAoGA1UECxMDVEFLMRUwEwYDVQQDEwxpbnRlcm1lZGlh
dGUwHhcNMjMwOTEwMTEwNjU5WhcNMjMxMDEwMjMwNjU5WjA1MQ0wCwYDVQQDEwRm
b3ljMRYwFAYDVQQKEw1GTElHSFRUQUNUSUNTMQwwCgYDVQQLEwNUQUswggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC+zguSLtOnTy2hRm6uPsViE4EFfiQu
g5/6IUVLNEHE19oEyiO7FZ6Ch5HVFJWwkib/P5aj2bb3mAmRVdVLo0qodgtkv6Bj
k/1YrvUg3Zs5rQbg9j/KY0CVAX1JZXFM/+LBZUjj6r8msKRgVb1FKkIk5brkGZPY
Gac2d/CDz0X4OV8X/Ag0J0Nb8pWllAktNBcHRGgw6bVm6M01atkyVZavNj9uu0x5
1BgsmHj0fOT6HrJYyZie74wbUUsubqIXX0H6HPgfQ6imoa+nga1XQd/LSpEVJsqQ
1F2aMGv0fgcWFW702+beqblKOSQp8+Bgvi86Xe9r7Xwfg/paVOrVB0EpAgMBAAGj
MjAwMB4GA1UdJQQXMBUGCCsGAQUFBwMCBgkqhkiG9w0BCQcwDgYDVR0PAQH/BAQD
AgPIMA0GCSqGSIb3DQEBCwUAA4IBAQA2gjh8h/k/Ate1TV+He6SCM94nXpq2996h
BW5Yw9MEul0zvC9rjyNa55JAPl2/rZehMcXSW8MzIyXGWsoAqjXjzIAtSLXkVpIG
KqpU//QfpdGHv2l5IwqMQ/Ep+40JwyFNREQtPPvgmgZAG1dS21vApPeQ6YdSeR2j
crxOt0JnEZxmsXe8C+/JkbRtgSE+eqIANigO0C2s1EHLdClMNnR344Jbx0C7w0RK
S1IIO016Dtg1/VQXu7Exap9k/T6YWHICVsZDpRGaFFN+0auKzErZk/qASED5qMew
MKoKrA3CS7eXJit8oLTELKOd+Pnc8Vw0jBj92DkFq3yvCbTKaxut
-----END CERTIFICATE-----
"""
        
        privateKey = """
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAvs4Lki7Tp08toUZurj7FYhOBBX4kLoOf+iFFSzRBxNfaBMoj
uxWegoeR1RSVsJIm/z+Wo9m295gJkVXVS6NKqHYLZL+gY5P9WK71IN2bOa0G4PY/
ymNAlQF9SWVxTP/iwWVI4+q/JrCkYFW9RSpCJOW65BmT2BmnNnfwg89F+DlfF/wI
NCdDW/KVpZQJLTQXB0RoMOm1ZujNNWrZMlWWrzY/brtMedQYLJh49Hzk+h6yWMmY
nu+MG1FLLm6iF19B+hz4H0OopqGvp4GtV0Hfy0qRFSbKkNRdmjBr9H4HFhVu9Nvm
3qm5SjkkKfPgYL4vOl3va+18H4P6WlTq1QdBKQIDAQABAoIBAFW70IAxUUIKtkaS
lrXtl5Q/jkgxC0HpO89Q9slZZDn2AU0IpPBxwOUG1HSpiK8rpKEpad8auvdaleX7
atlPOIMkc28kGYXU38/i4VsQqChMwlv/2d7vJPwvDKQXlEbUbYeXop5igtx4H4v3
ypFS8SCSJx1KDt/ZewRi9SvMzTRAj/RIi59NHTDljqQFn0GgIWo9F/43GNw7itJg
KLhzp2Eyhdd6Lt+vmArkFPOXT+NktdQbLwmYTHiPBeJ6VouPkMzpCIe+9E+S63I2
dZfxHY+esjCiNPpLoWFQhyfb3rh3wQJ4hh3x9hH1qxuFJB2PTVaFyKVIclCmTtEM
6rgzVb8CgYEA7oH+s/SPaBt+t2C+pZUojbcq5iNerM27bQ8NKw3KHL96RnQHQWlf
MQHVBe+lG+3UMT/rpPpOwGFk14RQLX/73WlZ4rkGd/6MZhw6yzerYm60K9R8ObVF
nelp6Qs1S0NOpU783rt0DCNNLIGXFZRRVckTSkxLfIeOeeBIQSVu0yMCgYEAzMxs
bGDdgiKfjolM/+d0zO58PMSS7lCyUcsaNsfonWuGe0SSOzxavPTI6zi5Gh8IgZF0
HLrtnn/5JimbNd1fsephOfdEdi2A8TnsrXJE8fpNNQXcQ+hcsvswDecmT7M7i4te
dZ1Advz+3cnohUebidNBwkSKPQd+plr0kitNdUMCgYEAjnpdm0bnPDvgkM9cVDIs
jav0FpLehcBIzLeHGEcei9new6OgifTWhsIfbXJhYbPLZLhYnq9gyA/mW9CQzP19
iiDbL1N0h84qNP18KdXRrfWP7/b5VsfxFIpRWIP3jERjAOGUscGta2rTOVkY1i1K
AUMjIOk+1t9rv2a6AyDHeZ0CgYBXteVptUKpDXMQdLVJlDNt4WXMENRsxJradQXR
GGUDpp1+BawrOnoSGzRBqZV9HnViKI12EIjcLSrjsUYMF7d4V000qjXj9zEWHxzC
XAIzMGQIpW3kl4u8C+BU0/6Qe86wwQu/i42kaE4vZt3y1uxCZvvu27Po12DilmnQ
gEM4SQKBgQCNVFqs7sAimlmshB2vnm9+0H39/yeJnMxvPmraTp4KNJj7GMpfCMbX
XINaNr6uVFIwfmReIav4qZwR7MjnFms/PimWsFnVkYwFTJ2RVi0bOlT6WhyMDxhU
O0Rzvxgh5YcI9Q82OoYNqjiMRKBOQyiRjulKS88CTV7hBHWzgvQcvw==
-----END RSA PRIVATE KEY-----
"""
    }

    override func tearDownWithError() throws {
        let query: [NSString: Any] = [
            kSecClass: kSecClassCertificate,
            kSecAttrLabel: hostName ]
        
        SecItemDelete(query as CFDictionary)
        
        let pkQuery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: privateKeyTag,
                                       kSecValueRef as String: privateKey]
        SecItemDelete(pkQuery as CFDictionary)
    }

    func testStoringIdentityStoresInKeychain() throws {
        let parsedCert = try Certificate(pemEncoded: certString)

        var serializer = DER.Serializer()
        try serializer.serialize(parsedCert)
        let derData = Data(serializer.serializedBytes)
        
        try CertificateManager.addIdentity(clientCertificate: derData, label: hostName)
        XCTAssertNotNil(CertificateManager.getIdentity(label: hostName), "Identity not found for hostName \(hostName)")
        XCTAssertNotNil(SettingsStore.global.retrieveIdentity(label: hostName), "Identity not found in SettingsStore for \(hostName)")
    }
}
