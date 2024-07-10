//
//  StreamParser.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/6/24.
//

import CoreData
import Foundation
import SwiftTAK
import SWXMLHash

class StreamParser: NSObject {
    
    static let STREAM_DELIMTER = "</event>"
    var dataContext = DataController.shared.cotDataContainer.newBackgroundContext()
    var cotParser: COTXMLParser = COTXMLParser()
    
    func parse(dataStream: Data?) -> Array<String> {
        guard let data = dataStream else { return [] }
        let str = String(decoding: data, as: UTF8.self)
        return str.components(separatedBy: StreamParser.STREAM_DELIMTER)
            .filter { !$0.isEmpty }
            .map { "\($0)\(StreamParser.STREAM_DELIMTER)" }
    }
    
    func parseCoTStream(dataStream: Data?) {
        guard let dataStream = dataStream else { return }

        let events = parse(dataStream: dataStream)
        for xmlEvent in events {
            guard var cotEvent = cotParser.parse(xmlEvent) else {
                continue
            }
            
            //Add in the color + usericon
            let xml = XMLHash.parse(dataStream)
            let usericonNode = xml["event"]["detail"]["usericon"].element
            let iconPath = usericonNode?.attribute(by: "iconsetpath")?.text ?? ""
            let colorNode = xml["event"]["detail"]["color"].element
            let iconColor = colorNode?.attribute(by: "argb")?.text ?? ""
            
            if var cotDetail = cotEvent.childNodes.first(where: {$0 is COTDetail}) as? COTDetail {
                if !iconPath.isEmpty {
                    let cotIcon = COTUserIcon(iconsetPath: iconPath)
                    cotDetail.childNodes.append(cotIcon)
                }
                
                if let argb = Int(iconColor) {
                    let cotColor = COTColor(argb: argb)
                    cotDetail.childNodes.append(cotColor)
                }
                
                cotEvent.childNodes.removeAll(where: { $0 is COTDetail })
                cotEvent.childNodes.append(cotDetail)
            }
            
            let fetchUser: NSFetchRequest<COTData> = COTData.fetchRequest()
            fetchUser.predicate = NSPredicate(format: "cotUid = %@", cotEvent.uid as String)
            
            let results = try? dataContext.fetch(fetchUser)
            
            let mapPointData: COTData!
            
            if results?.count == 0 {
                mapPointData = COTData(context: dataContext)
                mapPointData.id = UUID()
                mapPointData.cotUid = cotEvent.uid
             } else {
                 mapPointData = results?.first
             }

            mapPointData.callsign = cotEvent.cotDetail?.cotContact?.callsign ?? "UNKNOWN"
            mapPointData.latitude = Double(cotEvent.cotPoint?.lat ?? "0.0") ?? 0.0
            mapPointData.longitude = Double(cotEvent.cotPoint?.lon ?? "0.0") ?? 0.0
            mapPointData.remarks = cotEvent.cotDetail?.cotRemarks?.message ?? ""
            mapPointData.cotType = cotEvent.type
            mapPointData.icon = iconPath
            mapPointData.iconColor = iconColor
            mapPointData.startDate = cotEvent.start
            mapPointData.updateDate = cotEvent.time
            mapPointData.staleDate = cotEvent.stale

            do {
                try dataContext.save()
            } catch {
                TAKLogger.error("[StreamParser] Invalid Data Context Save \(error)")
            }
            
        }
    }
}
