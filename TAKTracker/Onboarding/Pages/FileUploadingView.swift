//
//  FileUploadingView.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/25/25.
//


import SwiftUI
import UniformTypeIdentifiers

struct FileUploadingView: View {
    /// Called after a file is successfully imported (gives you the temp/App copy URL)
    var onImported: (URL) -> Void = { _ in }
    /// Called when the user is ready to advance the onboarding queue
    var onDone: () -> Void = {}

    // UI state
    @State private var isShowingImporter = false
    @State private var selectedFileName: String?
    @State private var importedURL: URL?
    @State private var errorMessage: String?
    @State private var isCopying: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Upload a Data Package")
                .font(.title3).bold()

            Text("Choose a .zip data package to import into TAK Tracker.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if let name = selectedFileName {
                VStack(spacing: 6) {
                    Text("Selected: \(name)")
                        .font(.subheadline)
                    if isCopying {
                        ProgressView("Importing…")
                    }
                }
            }

            if let error = errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            HStack(spacing: 12) {
                Button("Choose File") { isShowingImporter = true }
                Button("Next") { onDone() }
                    .buttonStyle(.borderedProminent)
                    .disabled(importedURL == nil && selectedFileName == nil)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)

            Spacer()
        }
        .padding()
        .fileImporter(
            isPresented: $isShowingImporter,
            allowedContentTypes: [.zip],
            allowsMultipleSelection: false
        ) { result in
            handleImport(result)
        }
    }

    // MARK: - Import handling

    private func handleImport(_ result: Result<[URL], Error>) {
        errorMessage = nil
        isCopying = false

        switch result {
        case .failure(let err):
            errorMessage = "Import failed: \(err.localizedDescription)"

        case .success(let urls):
            guard let url = urls.first else {
                errorMessage = "No file selected."
                return
            }

            guard url.pathExtension.lowercased() == "zip" else {
                errorMessage = "Please select a .zip file."
                return
            }

            // Security-scoped access + copy into app container (recommended)
            isCopying = true
            Task {
                let copiedURL = await copyIntoAppContainerIfNeeded(url)
                await MainActor.run {
                    isCopying = false
                    if let dst = copiedURL {
                        importedURL = dst
                        selectedFileName = dst.lastPathComponent
                        onImported(dst)         // let parent persist/parse/etc.
                    } else {
                        selectedFileName = url.lastPathComponent
                        importedURL = url
                        onImported(url)
                    }
                }
            }
        }
    }

    /// Copies the selected file into your app’s Documents directory (if needed).
    /// Returns the destination URL or nil if copy failed.
    private func copyIntoAppContainerIfNeeded(_ src: URL) async -> URL? {
        var stop = false
        let scoped = src.startAccessingSecurityScopedResource()

        defer {
            if scoped { src.stopAccessingSecurityScopedResource() }
        }

        do {
            let fm = FileManager.default
            let docs = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dst = docs.appendingPathComponent(src.lastPathComponent, isDirectory: false)

            if fm.fileExists(atPath: dst.path) {
                try fm.removeItem(at: dst)
            }
            try fm.copyItem(at: src, to: dst)
            return dst
        } catch {
            await MainActor.run { errorMessage = "Could not import file: \(error.localizedDescription)" }
            return nil
        }
    }
}