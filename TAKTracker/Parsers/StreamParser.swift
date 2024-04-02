//
//  StreamParser.swift
//  TAKTracker
//
//  Created by Cory Foy on 3/15/24.
//

import Foundation
import SwiftTAK

class StreamParser: NSObject {

    static let STREAM_DELIMTER = "</event>"

    func parse(dataStream: Data?) -> Array<String> {
        guard let data = dataStream else { return [] }
        let str = String(decoding: data, as: UTF8.self)
        
        var cotEvents: Array<String> = []
        
        let scanner = Scanner(string: str)
        
        /*
         Quick overview of the logic: CoT messages can come in as
         streams of CoT XML messages all appended together. Because
         of the transmission of TCP Messages, it may cut off in the 
         middle of one. This can lead to this being passed in:
         <?xml version="1.0"><event uid="1"></event><?xml version="1.0"><even <-- Notice the cut off here
         The scanner logic looks for </event> and copies everything
         before that into our buffer. We then skip ahead to move past
         </event> and start scanning again. However, if there's no
         closing </event> node, we'll get information in our buffer
         from scanUpToString that isn't complete. Basically if there's
         a closing </event> node, we won't be at the end of the line.
         So after we get the line buffer from scanUpToString we then
         check if we're at the end of the line. If we are, then we didn't
         have a complete message. If we aren't, then we move the index
         (which may then put us at the end of the line)
         */
        
        // Have we reached the end of the string?
        while !scanner.isAtEnd {
            // This fills line with everything up to </event> *or* up to the end of the line whichever comes first
            guard let line = scanner.scanUpToString(StreamParser.STREAM_DELIMTER) else { return cotEvents }
            // If we're at the end of the line, then there was no closing </event>
            if(!scanner.isAtEnd) {
                // We're not at the end of the line (yet) so move the index past the </event>
                // Note that this might move us to the end of the line to be caught when we loop again
                scanner.currentIndex = scanner.string.index(scanner.currentIndex, offsetBy: StreamParser.STREAM_DELIMTER.count)
                // And that also means we had a complete message, so append it to our cotEvents
                cotEvents.append("\(line)\(StreamParser.STREAM_DELIMTER)")
            }
        }
        return cotEvents
    }
}
