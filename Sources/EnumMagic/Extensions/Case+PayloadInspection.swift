////  File.swift
//  
//
//  Created by Eric Rabil on 8/29/21.
//  
//

import Foundation
import Runtime

extension Case {
    var typeInfo: TypeInfo? {
        guard let type = payloadType else {
            return nil
        }
        
        return try! Runtime.typeInfo(of: type)
    }
    
    var types: [(TypeInfo, offset: Int)] {
        guard let typeInfo = typeInfo else {
            return []
        }
        
        switch typeInfo.kind {
        case .tuple:
            return typeInfo.properties.map {
                (try! Runtime.typeInfo(of: $0.type), offset: $0.offset)
            }
        default:
            return [(typeInfo, offset: 0)]
        }
    }
    
    var payloadCount: Int {
        types.count
    }
    
    var isEmpty: Bool {
        payloadCount == 0
    }
    
    var isNotEmpty: Bool {
        !isEmpty
    }
}
