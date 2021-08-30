////  File.swift
//  
//
//  Created by Eric Rabil on 8/29/21.
//  
//

import Foundation
import Runtime

struct CaseAssemblyInfo {
    var isEmpty: Bool
    var tag: Int
    var emptyPayloadTag: Int?
}

extension TypeInfo {
    var payloadCases: [Case] {
        cases.filter(\.isNotEmpty)
    }
    
    var emptyCases: [Case] {
        cases.filter(\.isEmpty)
    }
    
    func tag(forName name: String) -> Int {
        payloadCases.firstIndex(where: {
            $0.name == name
        }) ?? payloadCases.count
    }
    
    func emptyPayloadDiscriminator(forName name: String) -> Int? {
        emptyCases.firstIndex(where: {
            $0.name == name
        })
    }
    
    func `case`(named name: String) -> Case? {
        cases.first(where: { $0.name == name })
    }
    
    func assemblyInfo(forCase case: String) -> CaseAssemblyInfo? {
        let tag = tag(forName: `case`)
        let emptyTag = emptyPayloadDiscriminator(forName: `case`)
        
        return CaseAssemblyInfo(
            isEmpty: emptyTag != nil, tag: tag, emptyPayloadTag: emptyTag
        )
    }
}

