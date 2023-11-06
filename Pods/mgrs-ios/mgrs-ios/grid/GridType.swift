//
//  GridType.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 8/23/22.
//

import Foundation

/**
 * Grid type enumeration
 */
public enum GridType: Int, CaseIterable {
    
    /**
     * Grid Zone Designator
     */
    case GZD
    
    /**
     * Hundred Kilometer
     */
    case HUNDRED_KILOMETER
    
    /**
     * Ten Kilometer
     */
    case TEN_KILOMETER
    
    /**
     * Kilometer
     */
    case KILOMETER
    
    /**
     * Hundred Meter
     */
    case HUNDRED_METER
    
    /**
     * Ten Meter
     */
    case TEN_METER
    
    /**
     * Meter
     */
    case METER
    
    /**
     * Grid precision in meters
     *
     * @return precision meters
     */
    public func precision() -> Int {
        let precision: Int
        switch self {
        case .GZD:
            precision = 0
        case .HUNDRED_KILOMETER:
            precision = 100000
        case .TEN_KILOMETER:
            precision = 10000
        case .KILOMETER:
            precision = 1000
        case .HUNDRED_METER:
            precision = 100
        case .TEN_METER:
            precision = 10
        case .METER:
            precision = 1
        }
        return precision
    }
    
    /**
     * Get the Grid Type accuracy number of digits in the easting and northing
     * values
     *
     * @return accuracy digits
     */
    public func accuracy() -> Int {
        return max(rawValue - 1, 0)
    }
    
    /**
     * Get the Grid Type with the accuracy number of digits in the easting and
     * northing values. Accuracy must be inclusively between 0
     * (GridType.HUNDRED_KILOMETER) and 5 (GridType.METER).
     *
     * @param accuracy
     *            accuracy digits between 0 (inclusive) and 5 (inclusive)
     * @return grid type
     */
    public static func withAccuracy(_ accuracy: Int) -> GridType {
        if accuracy < 0 || accuracy > 5 {
            preconditionFailure("Grid Type accuracy digits must be >= 0 and <= 5. accuracy digits: \(accuracy)")
        }
        return self.allCases[accuracy + 1]
    }
    
    /**
     * Get the precision of the value in meters based upon trailing 0's
     *
     * @param value
     *            value in meters
     * @return precision grid type
     */
    public static func precision(_ value: Double) -> GridType {
        let precision: GridType
        if value.truncatingRemainder(dividingBy: Double(HUNDRED_KILOMETER.precision())) == 0 {
            precision = HUNDRED_KILOMETER
        } else if value.truncatingRemainder(dividingBy: Double(TEN_KILOMETER.precision())) == 0 {
            precision = TEN_KILOMETER
        } else if value.truncatingRemainder(dividingBy: Double(KILOMETER.precision())) == 0 {
            precision = KILOMETER
        } else if value.truncatingRemainder(dividingBy: Double(HUNDRED_METER.precision())) == 0 {
            precision = HUNDRED_METER
        } else if value.truncatingRemainder(dividingBy: Double(TEN_METER.precision())) == 0 {
            precision = TEN_METER
        } else {
            precision = METER
        }
        return precision
    }
    
    /**
     * Get the less precise (larger precision value) grid types
     *
     * @param type
     *            grid type
     * @return grid types less precise
     */
    public static func lessPrecise(_ type: GridType) -> [GridType] {
        let cases = self.allCases
        let index = cases.firstIndex(of: type)
        return Array(cases.prefix(upTo: index!))
    }
    
    /**
     * Get the more precise (smaller precision value) grid types
     *
     * @param type
     *            grid type
     * @return grid types more precise
     */
    public static func morePrecise(_ type: GridType) -> [GridType] {
        let cases = self.allCases
        let index = cases.firstIndex(of: type)
        return Array(cases.suffix(from: index! + 1))
    }
    
    var name: String {
        get { return String(describing: self) }
    }
    
}
