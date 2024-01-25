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

final class CertificateSigningRequestTests: TAKTrackerTestCase {
    
    var certString = ""
    var updatedCertString = ""
    var updatedCertStringSignedCert = ""
    var updatedCertStringca0 = ""
    var updatedCertStringca1 = ""
    var privateKey = ""
    let hostName = "tak.flighttactics.com"
    let privateKeyTag = "tak.flighttactics.com-pk"
    let publicKeyAccount = "foyc"
    let publicKeyService = "tak.flighttactics.com-public"
    let defaultPassword = "atakatak"

    override func setUpWithError() throws {
        try _cleanUpKeychain()
        
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
        
        updatedCertStringSignedCert = """
-----BEGIN CERTIFICATE-----
MIIDczCCAlugAwIBAgIEcpubxzANBgkqhkiG9w0BAQsFADCBgjELMAkGA1UEBhMC
VVMxCzAJBgNVBAgTAk5DMRUwEwYDVQQHEwxISUxMU0JPUk9VR0gxFjAUBgNVBAoT
DUNvcnkgRm95LCBMTEMxFzAVBgNVBAsTDkZsaWdodCBUYWN0aWNzMR4wHAYDVQQD
ExV0YWsuZmxpZ2h0dGFjdGljcy5jb20wHhcNMjMxMTI0MDYzMDA1WhcNMjMxMjI0
MTgzMDA1WjBAMQ0wCwYDVQQDEwRmb3ljMRYwFAYDVQQKEw1Db3J5IEZveSwgTExD
MRcwFQYDVQQLEw5GbGlnaHQgVGFjdGljczCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAOR2NqNfyrm98cumtCDt4S1uOXUANkynEUuJf7nRuxtZyv3P0B98
v6k9KL0yFHsl4b+qM+Y14LtN7D20OiuHLsezeBdvCD0oLOK/RAj+IKgOdDnz5gCa
gdvs+EtNOR9xybUhG6VCxA4BToEUrObJ6hPP+Q/YQVxJCSyc8juFMxvXLizbZb62
kas493iyOTJUrMWwUjOCaYPUy5qNCDH2x0BZf2dON8THxtX0MG5RVBKHH94oLG43
Ay6h8SYlZ6RC2tf3jPahdf2iUodgmU5/vaq7xfbWy7yt5p0kwrnhYrXRCmdmEWBQ
F5suiIWCBfQkG8eM3dJv7eTXYuW4+2mfSCkCAwEAAaMyMDAwHgYDVR0lBBcwFQYI
KwYBBQUHAwIGCSqGSIb3DQEJBzAOBgNVHQ8BAf8EBAMCA8gwDQYJKoZIhvcNAQEL
BQADggEBAJAE2RFO5BA/skwuCFII3+f75u+6HDa2kyRgt4DcilE+uPjUG9QMVn1G
2nA8fx5nr3K8lSckbPGZXjlQwF9rBMU6v6JHRbZml39m0W93vfbwyE8DBIS1b8Bs
1vGJQ4yqh+hTF4fCXI4WPDqlVbznyghUy9IE/XoCpFoKVhZerMt/gcuKFvMFkuwT
K4deg+f4xLIHyE0aReXCM5Wwc/YD0ut8hK7TQ8mT++Mz4hsC1C1P44jAKv9Vl7aD
/95mQ93rCifuQSMEyMmkTPGE/wlu0TwYl/MlEP5xut8s60JhaDmwCahYHYqThRDD
AFGQtxNhNgAhsgywYZrfN298AIp4GzU=
-----END CERTIFICATE-----
"""
        
        updatedCertStringca0 = """
-----BEGIN CERTIFICATE-----
MIID1TCCAr2gAwIBAgICLVIwDQYJKoZIhvcNAQELBQAwczELMAkGA1UEBhMCVVMx
CzAJBgNVBAgMAk5DMRUwEwYDVQQHDAxISUxMU0JPUk9VR0gxFjAUBgNVBAoMDUNv
cnkgRm95LCBMTEMxFzAVBgNVBAsMDkZsaWdodCBUYWN0aWNzMQ8wDQYDVQQDDAZ0
YWstY2EwHhcNMjMxMTAzMDMyMzAxWhcNMjUxMTAyMDMyMzAxWjCBgjELMAkGA1UE
BhMCVVMxCzAJBgNVBAgMAk5DMRUwEwYDVQQHDAxISUxMU0JPUk9VR0gxFjAUBgNV
BAoMDUNvcnkgRm95LCBMTEMxFzAVBgNVBAsMDkZsaWdodCBUYWN0aWNzMR4wHAYD
VQQDDBV0YWsuZmxpZ2h0dGFjdGljcy5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQCgKiSrZPHOn5/A86KiJsFju/VxQqwq/BQB5XIc3yOJuw8G/Q8Y
FefE0zpuRPQK6NKJnKeDEKYs0qVs5HVpkt01BVGmdTNOk0cYPLfd2GSD7L3/s4Lq
227R9lEHSDE06IejxBO6DhPrHoPVqNL85VUi0gjRuZSR3vvv4L7dFLzzP3w5DQab
6KP5N22k0OilAOsC1EIO8ipkmReQqjKcqBxg41gSQChkOHgg29VWHc/RJvUMhhGL
Q7ZZ5Fg3MDarvtq2VyB7S5cPOXuhMg/Qn0VpH4ZIDzfyCgoXytrW7/9VuD20m5OI
EHJtevva0vpUJoCoaqi2lZrAvi2Qo6D2gEDBAgMBAAGjYzBhMA8GA1UdEwEB/wQF
MAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBQk0QzEs0tl8g8RGsw7RYq+
NaH5BTAfBgNVHSMEGDAWgBSJL2cJsZHCVHdpF22pSLfC3ytkTjANBgkqhkiG9w0B
AQsFAAOCAQEAQ3wlP0ppepfOVtFqEOL4P5FXGPmxmFBSG4ffuo1ndobKOYuwHpZq
I/P3E/kQPU+IFqxhYEQ0O9ooVbLcxMpSSHcIyK43osHiIGCMAWj6fHd9pM1rkUX0
JnjBrXjIkZIc/1bLH3LLMm7yCZX7UQitpzEyYDA/TLQ5XMm5gGqNXCmpkScU6F1L
plvcqeRZXQZ4fi3T23n79LhpMtb2CT5+7l8gVzz3Z61fpkij9HyCelhcnVMgj9Yx
193J+qMWyrJW/PvBjPp5enymShM/7S34xsgfOkzQ++fDLK4WYc+3JC5ryIvpWd/6
p80U9LeDuOKW6VSZ0VrlNel8gHg0Gzm3Bg==
-----END CERTIFICATE-----
"""
        
        updatedCertStringca1 = """
-----BEGIN CERTIFICATE-----
MIIDtjCCAp6gAwIBAgIUB4sjU0EIxFPCDtuzEmzqJ2b3onYwDQYJKoZIhvcNAQEL
BQAwczELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAk5DMRUwEwYDVQQHDAxISUxMU0JP
Uk9VR0gxFjAUBgNVBAoMDUNvcnkgRm95LCBMTEMxFzAVBgNVBAsMDkZsaWdodCBU
YWN0aWNzMQ8wDQYDVQQDDAZ0YWstY2EwHhcNMjMxMTAzMDMxNjExWhcNMzMxMTAy
MDMxNjExWjBzMQswCQYDVQQGEwJVUzELMAkGA1UECAwCTkMxFTATBgNVBAcMDEhJ
TExTQk9ST1VHSDEWMBQGA1UECgwNQ29yeSBGb3ksIExMQzEXMBUGA1UECwwORmxp
Z2h0IFRhY3RpY3MxDzANBgNVBAMMBnRhay1jYTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBALvf97HqBVZmk6C+ZBqnUphpvYuyeF7D7uWEksaw7x6vYVar
HEN8ubwxZM5o6f+4SK1oGXn4toyPZ/5jWn3Hkd3lBjyZQs+y5NcUK01oG22v8e0p
ExGueAKXeD0dLuhG7JLno0Eq2xkbcUtMAgJaujv/OVWc524PpnGXRl6l7IXCx1yN
0fIl9pLx1ZFLqkXXH0Kxbh4WVeBRP0SpubURNFfBMywZhvy7UnC5wFFnRal2A01E
UCMJcB2RsYcaZ2vFjl4v4BPfK7kv3zOo9sW0kQT51ITAuewnaCJNHw9448bca+FJ
Yun4UOTZFSExfkrd6kUERwzq0ZFkREMTtWzw7w8CAwEAAaNCMEAwDwYDVR0TAQH/
BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0OBBYEFIkvZwmxkcJUd2kXbalI
t8LfK2ROMA0GCSqGSIb3DQEBCwUAA4IBAQC2HOTI/GwkY3i6Cmxo96D41Bowc9IZ
WGzdXyEerxp0ll87iOzrz/5diWGBWPc0Trr0gcm+UymtceAPBY1u9mErllvLY9iL
M6MMJFZOYO/thRgDeZeMvMtuO947fNQMzuCqP7+0X7dQTCQpKMrtjtiYfPYwznK4
CAV5I6j1L3RcBDHy5ddXg755wjnijj2pFBgX8LONpS5PwKc3aNe9KUwgpiKEniJ+
2MgzF9/GAe+IKWxsCzf8vxUi6Z4qTilEi+p1JCtsdLw1d6EAPbOuvxKz6pgbr4An
6C/M6ndPiavDO7QyUPcGeEjCqVSfTu+xNFXOaf182v19QizIGGDvRt4z
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
        try _cleanUpKeychain()
    }
    
    func _cleanUpKeychain() throws {
        var query: [NSString: Any] = [
            kSecClass: kSecClassCertificate,
            kSecAttrLabel: hostName ]
        
        SecItemDelete(query as CFDictionary)
        
        query = [
            kSecClass: kSecClassIdentity,
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
    
    func testUpdatingIdentityReplacesCertInKeychain() throws {
        let parsedCert = try Certificate(pemEncoded: certString)
        let parsedUpdatedCert = try Certificate(pemEncoded: updatedCertStringSignedCert)

        var serializer = DER.Serializer()
        try serializer.serialize(parsedCert)
        let derData = Data(serializer.serializedBytes)
        
        try serializer.serialize(parsedUpdatedCert)
        let derUpdatedData = Data(serializer.serializedBytes)
        
        try CertificateManager.addIdentity(clientCertificate: derData, label: hostName)
        let storedIdentity = SettingsStore.global.retrieveIdentity(label: hostName)
        
        try CertificateManager.addIdentity(clientCertificate: derUpdatedData, label: hostName)
        let updatedStoredIdentity = SettingsStore.global.retrieveIdentity(label: hostName)
        
        XCTAssertNotEqual(storedIdentity, updatedStoredIdentity)

    }
}
