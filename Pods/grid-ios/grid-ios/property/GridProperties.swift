//
//  GridProperties.swift
//  grid-ios
//
//  Created by Brian Osborn on 8/5/22.
//

import Foundation

/**
 * Grid property loader
 */
open class GridProperties {

    /**
     * Properties
     */
    public var properties: [String: Any]
    
    /**
     *  Initialize
     *
     *  @param resourceClass resource class
     *  @param bundle  bundle name
     *  @param name    properties name
     */
    public init(_ resourceClass: AnyClass, _ bundle: String, _ name: String) {
        let dict: [String: Any]?
        let propertiesPath = GridProperties.propertyListURL(resourceClass, bundle, name)
        do {
            let propertiesData = try Data(contentsOf: propertiesPath)
            dict = try PropertyListSerialization.propertyList(from: propertiesData, options: [], format: nil) as? [String: Any]
        } catch {
            fatalError("Failed to load properties in bundle '\(bundle)' with name '\(name)'")
        }
        properties = dict!
    }
    
    /**
     *  Combine the base property with the property to create a single combined property
     *
     *  @param base     base property
     *  @param property property
     *
     *  @return string value
     */
    public func combine(_ base: String, _ property: String) -> String {
        return "\(base)\(PropertyConstants.PROPERTY_DIVIDER)\(property)"
    }
    
    /**
     *  Get the string value of the property
     *
     *  @param property property
     *
     *  @return string value
     */
    public func value(_ property: String) -> String {
        return value(property, true)!
    }
    
    /**
     *  Get the string value of the property with required option
     *
     *  @param property property
     *  @param required true if required to exist
     *
     *  @return string value
     */
    public func value(_ property: String, _ required: Bool) -> String? {
        let value: String? = properties[property] as? String
        
        if value == nil && required {
            preconditionFailure("Required property not found: \(property)")
        }
        
        return value
    }

    /**
     *  Get the string value of the property combined with the base
     *
     *  @param base     base property
     *  @param property property
     *
     *  @return string value
     */
    public func value(_ base: String, _ property: String) -> String {
        return value(base, property, true)!
    }
    
    /**
     *  Get the string value of the property combined with the base with required option
     *
     *  @param base     base property
     *  @param property property
     *  @param required true if required to exist
     *
     *  @return string value
     */
    public func value(_ base: String, _ property: String, _ required: Bool) -> String? {
        return value(combine(base, property), required)
    }
    
    /**
     *  Get the int value of the property
     *
     *  @param property property
     *
     *  @return int value
     */
    public func intValue(_ property: String) -> Int {
        return intValue(property, true)!
    }
    
    /**
     *  Get the int value of the property with required option
     *
     *  @param property property
     *  @param required true if required to exist
     *
     *  @return int value
     */
    public func intValue(_ property: String, _ required: Bool) -> Int? {
        var val: Int?
        let stringValue: String? = value(property, required)
        if stringValue != nil {
            val = Int(stringValue!)
        }
        return val
    }
    
    /**
     *  Get the int value of the property
     *
     *  @param base     base property
     *  @param property property
     *
     *  @return int value
     */
    public func intValue(_ base: String, _ property: String) -> Int {
        return intValue(base, property, true)!
    }
    
    /**
     *  Get the int value of the property with required option
     *
     *  @param base     base property
     *  @param property property
     *  @param required true if required to exist
     *
     *  @return int value
     */
    public func intValue(_ base: String, _ property: String, _ required: Bool) -> Int? {
        return intValue(combine(base, property), required)
    }
    
    /**
     *  Get the float value of the property
     *
     *  @param property property
     *
     *  @return float value
     */
    public func floatValue(_ property: String) -> Float {
        return floatValue(property, true)!
    }
    
    /**
     *  Get the float value of the property with required option
     *
     *  @param property property
     *  @param required true if required to exist
     *
     *  @return float value
     */
    public func floatValue(_ property: String, _ required: Bool) -> Float? {
        var val: Float?
        let stringValue: String? = value(property, required)
        if stringValue != nil {
            val = Float(stringValue!)
        }
        return val
    }
    
    /**
     *  Get the float value of the property
     *
     *  @param base     base property
     *  @param property property
     *
     *  @return float value
     */
    public func floatValue(_ base: String, _ property: String) -> Float {
        return floatValue(base, property, true)!
    }
    
    /**
     *  Get the float value of the property with required option
     *
     *  @param base     base property
     *  @param property property
     *  @param required true if required to exist
     *
     *  @return float value
     */
    public func floatValue(_ base: String, _ property: String, _ required: Bool) -> Float? {
        return floatValue(combine(base, property), required)
    }
    
    /**
     *  Get the double value of the property
     *
     *  @param property property
     *
     *  @return double value
     */
    public func doubleValue(_ property: String) -> Double {
        return doubleValue(property, true)!
    }
    
    /**
     *  Get the double value of the property with required option
     *
     *  @param property property
     *  @param required true if required to exist
     *
     *  @return double value
     */
    public func doubleValue(_ property: String, _ required: Bool) -> Double? {
        var val: Double?
        let stringValue: String? = value(property, required)
        if stringValue != nil {
            val = Double(stringValue!)
        }
        return val
    }
    
    /**
     *  Get the double value of the property
     *
     *  @param base     base property
     *  @param property property
     *
     *  @return double value
     */
    public func doubleValue(_ base: String, _ property: String) -> Double {
        return doubleValue(base, property, true)!
    }
    
    /**
     *  Get the double value of the property with required option
     *
     *  @param base     base property
     *  @param property property
     *  @param required true if required to exist
     *
     *  @return double value
     */
    public func doubleValue(_ base: String, _ property: String, _ required: Bool) -> Double? {
        return doubleValue(combine(base, property), required)
    }
    
    /**
     *  Get the bool value of the property
     *
     *  @param property property
     *
     *  @return bool value
     */
    public func boolValue(_ property: String) -> Bool {
        return boolValue(property, true)!
    }
    
    /**
     *  Get the bool value of the property with required option
     *
     *  @param property property
     *  @param required true if required to exist
     *
     *  @return bool value
     */
    public func boolValue(_ property: String, _ required: Bool) -> Bool? {
        var val: Bool?
        let stringValue: String? = value(property, required)
        if stringValue != nil {
            val = Bool(stringValue!)
        }
        return val
    }
    
    /**
     *  Get the bool value of the property
     *
     *  @param base     base property
     *  @param property property
     *
     *  @return bool value
     */
    public func boolValue(_ base: String, _ property: String) -> Bool {
        return boolValue(base, property, true)!
    }
    
    /**
     *  Get the bool value of the property with required option
     *
     *  @param base     base property
     *  @param property property
     *  @param required true if required to exist
     *
     *  @return bool value
     */
    public func boolValue(_ base: String, _ property: String, _ required: Bool) -> Bool? {
        return boolValue(combine(base, property), required)
    }
    
    public static func propertyListURL(_ resourceClass: AnyClass, _ bundle: String, _ name: String) -> URL {
        return resourceURL(resourceClass, bundle, name, PropertyConstants.PROPERTY_LIST_TYPE)
    }

    public static func resourceURL(_ resourceClass: AnyClass, _ bundle: String, _ name: String, _ ext: String) -> URL {
        
        let resource = "\(bundle)/\(name)"
        var resourceURL = Bundle.main.url(forResource: resource, withExtension: ext)
        if resourceURL == nil {
            resourceURL = Bundle(for: resourceClass).url(forResource: resource, withExtension: ext)
            if resourceURL == nil {
                resourceURL = Bundle(for: resourceClass).url(forResource: name, withExtension: ext)
                if resourceURL == nil {
                    resourceURL = Bundle.main.url(forResource: name, withExtension: ext)
                }
            }
        }
        if resourceURL == nil {
            fatalError("Failed to find resource '\(name)' with extension '\(ext)'")
        }
        
        return resourceURL!
    }
    
}
