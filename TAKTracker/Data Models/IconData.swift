//
//  IconData.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/6/24.
//

import CoreGraphics
import Foundation
import SQLite
import UIKit

struct IconSet {
    var id: Int
    var name: String
    var uid: String
    var selectedGroup: String
    var version: String?
    var defaultFriendly: String?
    var defaultHostile: String?
    var defaultNeutral: String?
    var defaultUnknown: String?
}

struct Icon {
    var id: Int
    var iconset_uid: String
    var filename: String
    var groupName: String
    var type2525b: String?
    var icon: UIImage
}

class IconData {
    var connection: Connection?
    let iconSetTable = Table("iconsets")
    let iconTable = Table("icons")
    
    static let shared = IconData()
    
    static func colorFromArgb(argbVal: Int) -> UIColor {
        let blue = CGFloat(argbVal & 0xff)
        let green = CGFloat(argbVal >> 8 & 0xff)
        let red = CGFloat(argbVal >> 16 & 0xff)
        let alpha = CGFloat(argbVal >> 24 & 0xff)
        return UIColor(red: red/255, green: green/255.0, blue: blue/255.0, alpha: alpha/255.0)
    }
    
    static func availableIconSets() -> [IconSet] {
        guard let conn = shared.connection else { return [] }
        do {
            return try conn.prepare(shared.iconSetTable).map { iconSet in
                IconSet(
                    id: iconSet[Expression<Int>("id")],
                    name: iconSet[Expression<String>("name")],
                    uid: iconSet[Expression<String>("uid")],
                    selectedGroup: iconSet[Expression<String>("selectedGroup")],
                    version: iconSet[Expression<String?>("version")],
                    defaultFriendly: iconSet[Expression<String?>("defaultFriendly")],
                    defaultHostile: iconSet[Expression<String?>("defaultHostile")],
                    defaultNeutral: iconSet[Expression<String?>("defaultNeutral")],
                    defaultUnknown: iconSet[Expression<String?>("defaultUnknown")]
                )
            }
        } catch {}
        return []
    }
    
    static func iconFor(type2525: String, iconsetPath: String) -> Icon {
        var dataBytes = Data()
        
        if iconsetPath.count > 0 {
            //de450cbf-2ffc-47fb-bd2b-ba2db89b035e/Resources/ESF4-FIRE-HAZMAT_Aerial-Apparatus-Ladder.png
            let pathParts = iconsetPath.split(separator: "/")
            if pathParts.count == 3 {
                let iconSetUid = String(pathParts[0]) //iconset_uid
                let groupName = String(pathParts[1]) //groupName
                let imageName = String(pathParts[2]) //filename
                
                if iconSetUid == "COT_MAPPING_SPOTMAP" {
                    // This is a unique spotmap
                    // So we'll return a circle
                    // where the imageName is the argb colors
                    let spotColor = IconData.colorFromArgb(argbVal: Int(imageName)!)
                    let spotMapImg = UIImage(systemName: "largecircle.fill.circle")!.mask(with: spotColor)
                    return Icon(id: 0, iconset_uid: UUID().uuidString, filename: "none", groupName: "none", icon: spotMapImg)
                } else {
                    let bitMapCol = Expression<Blob>("bitmap")
                    let iconSetCol = Expression<String>("iconset_uid")
                    let groupNameCol = Expression<String>("groupName")
                    let fileNameCol = Expression<String>("filename")
                    
                    let query: QueryType = shared.iconTable
                        .filter(iconSetCol == iconSetUid)
                        .filter(groupNameCol == groupName)
                        .filter(fileNameCol == imageName)
                    let conn = shared.connection
                    do {
                        if let row = try conn!.pluck(query) {
                            dataBytes = try Data.fromDatatypeValue(row.get(bitMapCol))
                        }
                    } catch {
                        TAKLogger.error("[IconData] Error retrieving iconsetpath \(error)")
                    }
                }
            }
        }

        // Default icon is the unknown icon
        var uiImg = UIImage(named: milStdIconWithName(name: "sugp"))!
        
        if !dataBytes.isEmpty {
            let cgDp = CGDataProvider(data: dataBytes as CFData)!
            let cgImg = CGImage(pngDataProviderSource: cgDp, decode: nil, shouldInterpolate: false, intent: .perceptual)!
            uiImg = UIImage(cgImage: cgImg)
        } else {
            let mil2525iconName = IconData.mil2525FromCotType(cotType: type2525)
            if !mil2525iconName.isEmpty {
                let img2525 = UIImage(named: mil2525iconName)
                if img2525 != nil {
                    uiImg = img2525!
                } else {
                    TAKLogger.error("[IconData] mil2525icon with name \(mil2525iconName) for \(type2525) could not be converted into an image!")
                }
                
            }
        }
        
        //let uiImg = UIImage(systemName: "circle.fill")!
        return Icon(id: 0, iconset_uid: UUID().uuidString, filename: "none", groupName: "none", icon: uiImg)
    }
    
    static func milStdIconWithName(name: String) -> String {
        // The milspec names are 15 characters long, dash padded
        // Ex: sugp-----------
        return name.padding(toLength: 15, withPad: "-", startingAt: 0)
    }
    
    static func iconsForSet(iconSetUid: String) -> [Icon] {
        return []
    }
    
    static func iconsFor2525b(type2525b: String) -> [Icon] {
        return []
    }
    
    static func iconForFileName(iconSetUid: String?, filename: String) -> Icon? {
        return nil
    }
    
    private init() {
        do {
            let bundle = Bundle(for: Self.self)
            guard let archiveURL = bundle.url(forResource: "iconsets", withExtension: "sqlite") else {
                TAKLogger.error("[IconData] Iconset Data Store not located in the Bundle. Defaulting all icons")
                return
            }
            connection = try Connection(archiveURL.absoluteString, readonly: true)
        } catch {
            TAKLogger.error("[IconData] Unable to load icon data store. Defaulting all icons")
            TAKLogger.error("[IconData] \(error)")
        }
    }
    
    // Rewritten from the Icon2525cTypeResolver.java
    // found in https://github.com/deptofdefense/AndroidTacticalAssaultKit-CIV
    static func mil2525FromCotType(cotType: String) -> String {
        guard cotType.count > 2 && cotType.first == "a" else {
            return ""
        }
        
        var s2525C = ""
        
        let checkIndex = cotType.index(cotType.startIndex, offsetBy: 2)

        switch(cotType[checkIndex].lowercased()) {
        case "f", "a":
            s2525C = "sf"
        case "n":
            s2525C = "sn"
        case "s", "j", "k", "h":
            s2525C = "sh"
        case "u":
            s2525C = "u"
        default:
            s2525C = "u"
        }
        
        var cotCharacters = Array(cotType)
        for pos in stride(from: 4, to: cotType.count, by: 2) {
            let cotChar = cotCharacters[pos]
            s2525C.append(cotChar.lowercased())
            if pos == 4 {
                s2525C.append("p")
            }
        }
        
        cotCharacters = Array(s2525C)

        for pos in (s2525C.count)..<15 {
            if (pos == 10 && cotCharacters.count >= 5 && cotCharacters[2] == "g" && cotCharacters[4] == "i") {
                s2525C.append("h")
            } else {
                s2525C.append("-")
            }
        }
        return s2525C
    }
}
