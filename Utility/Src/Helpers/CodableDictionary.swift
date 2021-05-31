//
//  CodableDictionary.swift
//  Utility
//
//  Created by Sumeet Bajaj on 24/03/2020.
//

import Foundation

public struct CodableDictionary<Key : Hashable, Value : Codable> : Codable where Key : CodingKey {

    private(set) var decoded: [Key: Value]

    public init() {
        self.decoded = [Key:Value]()
    }
    
    public init(_ decoded: [Key: Value]) {
        self.decoded = decoded
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: Key.self)

        decoded = Dictionary(uniqueKeysWithValues:
            try container.allKeys.lazy.map {
                (key: $0, value: try container.decode(Value.self, forKey: $0))
            }
        )
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: Key.self)

        for (key, value) in decoded {
            try container.encode(value, forKey: key)
        }
    }
    
    public subscript(key: Key) -> Value? {
        
        get { return decoded[key] }
        
        set { self.decoded[key] = newValue }
    }
}
