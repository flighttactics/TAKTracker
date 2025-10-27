//
//  DataPackageManager.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/9/25.
//

import Foundation

final class DataPackageManager {
    static func process(_ urls: [URL]) -> String {
        for url in urls {
            guard url.startAccessingSecurityScopedResource() else {
                TAKLogger.error("Unable to access \(url)")
                continue
            }

            TAKLogger.debug("Processing Package at \(url)")
            let parser = TAKDataPackageParser(fileLocation: url)
            parser.parse()
            url.stopAccessingSecurityScopedResource()

            if parser.parsingErrors.isEmpty {
                return "✅ Data package processed successfully!"
            } else {
                return "⚠️ Errors:\n\(parser.parsingErrors.joined(separator: "\n"))"
            }
        }
        return "No files processed."
    }
}
