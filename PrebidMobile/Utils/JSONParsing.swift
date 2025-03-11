//
//  JSONParsing.swift
//  PrebidMobile
//
//  Created by James on 3/5/25.
//  Copyright © 2025 AppNexus. All rights reserved.
//

import Foundation

extension [String : Any] {
    
    subscript<T>(key key: Key) -> T? {
        self[key] as? T
    }
    
    subscript<T>(key key: Key, as type: T.Type) -> T? {
        self[key] as? T
    }
    
    func entity<T: PBMORTBAbstract>(key: Key) -> T? {
        (self[key] as? [String : Any]).flatMap { T(jsonDictionary: $0) }
    }
    
    func array<T>(key: Key, of type: T.Type) -> [T]? {
        (self[key] as? [Any])?.compactMap { $0 as? T }
    }
    
    func array<T: PBMORTBAbstract>(key: Key, ofEntity: T.Type) -> [T]? {
        (self[key] as? [Any])?.compactMap {
            if let dict = $0 as? [String : Any],
               let entity = T(jsonDictionary: dict) {
                return entity
            }
            return nil
        }
    }
    
    func passthroughObjects(key: Key) -> [PBMORTBExtPrebidPassthrough]? {
        // The prebid spec defines in various parts of the schema the "passthrough" key
        // which is supposed to map to a JSON object. However it was mistakenly implemented
        // as an array of objects in this SDK. To maintain backwards compatibility we still
        // check for the array of objects.
        let dictionaries: [[String : Any]]?
        switch self[key] {
            case let value as [String : Any]:
                dictionaries = [value]
            case let value as [Any]:
                dictionaries = value.compactMap { $0 as? [String : Any] }
            default:
                dictionaries = nil
        }
        
        return dictionaries?.map { PBMORTBExtPrebidPassthrough(jsonDictionary: $0) }.nilIfEmpty
    }
    
    // Use this to maintain the current value of the destination variable if a
    // new value is not present.
    func setIfPresent<T>(_ dst: inout T, key: Key) {
        if let value = self[key] as? T {
            dst = value
        }
    }
    
    func setIfPresent<T>(_ dst: inout T?, key: Key) {
        let value = self[key]
        if let value = value as? T {
            dst = value
        } else if value is NSNull {
            dst = nil
        }
    }
}

extension Array {
    var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}

extension Dictionary {
    var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}
