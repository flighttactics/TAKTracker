import SwiftUI
import UniformTypeIdentifiers
import CodeScanner
import AVFoundation
import SwiftTAK

// MARK: - Pages

enum OnboardingPage: Hashable {
    case permissions, userInfo, server, connections, enrollment, qr, upload, finish
}


// MARK: - Simple form model for enrollment


// MARK: - OnboardingView

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var onboardingManager: OnboardingManager
    @EnvironmentObject var takManager: TAKManager

    @State private var selectedConnection: ConnectionOptions? = nil
    @State private var pendingConnections: [ConnectionOptions] = []
    private let connectionOrder: [ConnectionOptions] = [.enrollment, .scanQRCode, .uploadDataPackage]

    // Upload (file importer)
    @State private var isShowingFilePicker = false

    // Enrollment state (parent owns business logic)
    @StateObject private var csrRequest = CSRRequestor()
    @State private var certForm = CertForm.fromSettings(SettingsStore.global)

    // QR scanning
    @State private var isPresentingQRScanner = false
    @State private var qrCodeResult = ""
    @State private var showQRFailureAlert = false

    var body: some View {
        VStack {
            tabView
            navBar
        }
        // File importer for Upload option
        .fileImporter(isPresented: $isShowingFilePicker,
                      allowedContentTypes: [.zip],
                      allowsMultipleSelection: false) { _ in
            // Handle the file(s) as needed, then advance the queue
            advanceToNextConnection()
        }
        // QR sheet (used by enrollment)
        .sheet(isPresented: $isPresentingQRScanner, onDismiss: {
            if !qrCodeResult.isEmpty { processQRCode(qrCodeResult) }
        }) {
            NavigationView {
                CodeScannerView(
                    codeTypes: [.qr],
                    showViewfinder: true,
                    simulatedData: "MyTAK,tak.example.com,8089,SSL",
                    shouldVibrateOnSuccess: true,
                    videoCaptureDevice: AVCaptureDevice.zoomedCameraForQRCode()
                ) { response in
                    if case let .success(result) = response {
                        qrCodeResult = result.string
                        isPresentingQRScanner = false
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Cancel") { isPresentingQRScanner = false }
                    }
                }
            }
        }
        .alert("QR Code Failure", isPresented: $showQRFailureAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The QR Code you scanned did not contain connection information. Please try a different QR code.")
        }
        // Auto-advance when CSR succeeds
        .onChange(of: csrRequest.enrollmentStatus) { newValue in
            if newValue == .Succeeded { advanceToNextConnection() }
        }
    }

    // MARK: - Pages

    private var tabView: some View {
        TabView(selection: $onboardingManager.currentStep) {

            PermissionView()
                .tag(OnboardingPage.permissions)

            UserInfoView(type: .phoneNumber)
                .tag(OnboardingPage.userInfo)

            ServerPageView()
                .tag(OnboardingPage.server)

            ConnectionOptionsScreen(
                selected: $selectedConnection,
                onSkip: { go(.finish) }
            )
            .tag(OnboardingPage.connections)
            
            FileUploadingView(
                onImported: { url in
                    // Do whatever you need with the URL:
                    // - unzip
                    // - parse manifest
                    // - persist a bookmark, etc.
                    // If you want to auto-advance immediately after import, call onDone() here,
                    // but since this view calls onDone via the button, you can leave it.
                },
                onDone: { advanceToNextConnection() }
            )
            .tag(OnboardingPage.upload)

            // Enrollment page: parent provides data + intents
            CertEnrollmentScreen(
                form: $certForm,
                statusText: "Status: \(csrRequest.enrollmentStatus.description)",
                showContinue: csrRequest.enrollmentStatus == .Succeeded,
                onScanTapped: { isPresentingQRScanner = true },
                onSubmitTapped: { submitEnrollmentForm() },
                onContinue: { advanceToNextConnection() }
            )
            .tag(OnboardingPage.enrollment)

            // QR page: finish goes back to the queue (or auto into enrollment if needed)
            QRScanner(
                onResult: { code in processQRCode(code) },
                onDone: { advanceToNextConnection() },
                onAutoSubmitEnroll: { go(.enrollment) }
            )
            .tag(OnboardingPage.qr)

            FinishView()
                .tag(OnboardingPage.finish)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }

    private var navBar: some View {
        StepNavigationButtons(
            showPrevious: showPrevious,
            onPrevious: previousStep,
            onNext: { handleNextTap() },
            onNextTitle: nextButtonTitle
        )
    }

    // MARK: - Nav helpers

    private func go(_ page: OnboardingPage) {
        onboardingManager.currentStep = page
    }

    private var showPrevious: Bool {
        switch onboardingManager.currentStep {
        case .permissions: return false
        default: return true
        }
    }
    
    private func handleNextTap() {
        switch onboardingManager.currentStep {
        case .permissions, .userInfo, .server:
            onboardingManager.nextStep()
        case .connections:
            startConnections()
        case .enrollment, .qr, .upload:
            advanceToNextConnection()
        case .finish:
            SettingsStore.global.hasOnboarded = true
            dismiss()
        }
    }

    private func previousStep() {
        switch onboardingManager.currentStep {
        case .userInfo:      go(.permissions)
        case .server:        go(.userInfo)
        case .connections:   go(.server)
        case .enrollment,
             .qr,
             .upload:        go(.connections)   // ← include upload
        case .finish:        go(.connections)
        default: break
        }
    }

    private func nextStep() {
        switch onboardingManager.currentStep {
        case .permissions: go(.userInfo)
        case .userInfo:    go(.server)
        case .server:      go(.connections)
        case .connections: startConnections()
        case .finish:
            SettingsStore.global.hasOnboarded = true
            dismiss()
        default:
            break
        }
    }

    private var nextButtonTitle: String {
        switch onboardingManager.currentStep {
        case .permissions, .userInfo: return "Continue"
        case .server:                 return "Connect"
        case .connections:            return (selectedConnection == nil) ? "Skip" : "Continue"
        case .enrollment, .qr, .upload: return "Continue"
        case .finish:                 return "Finish"
        }
    }

    // MARK: - Queue
    private func startConnections() {
        guard let choice = selectedConnection else {
            go(.finish)
            return
        }
        pendingConnections = [choice]       // single-step queue
        route(to: choice)
    }

    private func advanceToNextConnection() {
        if !pendingConnections.isEmpty { pendingConnections.removeFirst() }
        guard let next = pendingConnections.first else {
            go(.finish)
            return
        }
        route(to: next)
    }

    private func route(to option: ConnectionOptions) {
        switch option {
        case .enrollment:        go(.enrollment)
        case .scanQRCode:        go(.qr)
        case .uploadDataPackage: go(.upload)
        }
    }

    private func processQRCode(_ text: String) {
        TAKLogger.debug("[Onboarding] Parsing QR \(text)")
        let res = QRCodeParser.parse(text)
        if res.wasInvalidString {
            showQRFailureAlert = true
            return
        }
        certForm.serverURL  = res.serverURL
        certForm.serverPort = res.serverPort
        certForm.username   = res.username
        certForm.password   = res.password

        if res.shouldAutoSubmit {
            submitEnrollmentForm()
        }
    }

    private func submitEnrollmentForm() {
        SettingsStore.global.takServerUrl            = certForm.serverURL
        SettingsStore.global.takServerPort           = certForm.serverPort
        SettingsStore.global.takServerUsername       = certForm.username
        SettingsStore.global.takServerPassword       = certForm.password
        SettingsStore.global.takServerCSRPort        = certForm.csrPort
        SettingsStore.global.takServerSecureAPIPort  = certForm.secureApiPort
        csrRequest.beginEnrollment()
    }
}

