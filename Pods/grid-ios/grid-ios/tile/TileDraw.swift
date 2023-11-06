//
//  TileDraw.swift
//  grid-ios
//
//  Created by Brian Osborn on 8/17/22.
//

import UIKit

/**
 * Tile draw utilities for lines and labels
 */
public class TileDraw {

    /**
     * Draw the lines on the tile
     *
     * @param lines  lines to draw
     * @param tile   tile
     * @param grid   grid
     * @param context graphics context
     */
    public static func drawLine(_ line: Line, _ tile: GridTile, _ width: Double, _ color: UIColor?, _ context: CGContext) {
        
        let path = CGMutablePath()
        addLine(tile, path, line)
        
        let strokeColor = color ?? UIColor.black
        
        context.setLineWidth(width)
        context.setStrokeColor(strokeColor.cgColor)
        
        context.addPath(path)
        context.drawPath(using: CGPathDrawingMode.stroke)

    }
    
    /**
     * Add the line to the path
     *
     * @param tile tile
     * @param path line path
     * @param line line to draw
     */
    public static func addLine(_ tile: GridTile, _ path: CGMutablePath, _ line: Line) {

        let metersLine = line.toMeters()
        let point1 = metersLine.point1
        let point2 = metersLine.point2

        let pixel = point1.pixel(tile)
        path.move(to: CGPoint(x: CGFloat(pixel.x), y: CGFloat(pixel.y)))
        
        let pixel2 = point2.pixel(tile)
        path.addLine(to: CGPoint(x: CGFloat(pixel2.x), y: CGFloat(pixel2.y)))

    }
    
    /**
     * Draw the labels on the tile
     *
     * @param labels labels to draw
     * @param buffer grid zone edge buffer
     * @param tile   tile
     * @param grid   grid
     */
    public static func drawLabels(_ labels: [Label], _ buffer: Double, _ tile: GridTile, _ grid: BaseGrid) {
        
        let labeler = grid.labeler!
        
        let textSize = labeler.textSize
        let font = UIFont.systemFont(ofSize: CGFloat(textSize))
        
        var color = labeler.color
        if color == nil {
            color = UIColor.black
        }
        
        for label in labels {
            drawLabel(label, buffer, tile, font, color!)
        }
    }
    
    /**
     * Draw the label
     *
     * @param label  label to draw
     * @param buffer grid zone edge buffer
     * @param tile   tile
     * @param font   font
     * @param color   color
     */
    public static func drawLabel(_ label: Label, _ buffer: Double, _ tile: GridTile, _ font: UIFont, _ color: UIColor) {
        
        let name = label.name
        let nameString = name as NSString

        // Determine the text bounds
        var textSize = nameString.size(withAttributes: [NSAttributedString.Key.font: font])
        textSize = CGSize(width: ceil(textSize.width), height: ceil(textSize.height))

        // Determine the pixel width and height of the label grid zone to the tile
        let pixelRange = label.bounds.pixelRange(tile)

        // Determine the maximum width and height a label in the grid should be
        let gridPercentage = 1.0 - (2 * buffer)
        let maxWidth = gridPercentage * Double(pixelRange.width)
        let maxHeight = gridPercentage * Double(pixelRange.height)

        // If it fits, draw the label in the center of the grid zone
        if textSize.width <= maxWidth && textSize.height <= maxHeight {
            let centerPixel = label.center.pixel(tile)
            let bounds = CGRect(x: CGFloat(centerPixel.x) - (textSize.width / 2.0), y: CGFloat(centerPixel.y) - (textSize.height / 2.0), width: textSize.width, height: textSize.height)
            
            let attributes = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color
            ]
            nameString.draw(in: bounds, withAttributes: attributes)
        }

    }
    
}
