import Foundation
import Runtime

public func CreateEnum<P>(_ enum: P.Type, caseName: String, payload: [Any] = []) -> P {
    let info = try! typeInfo(of: P.self)
    
    let assemblyInfo = info.assemblyInfo(forCase: caseName)!
    
    // allocate empty memory that has the same size and alignment of this enum
    let buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: info.size, alignment: info.alignment)
    
    var peek: P {
        buffer.baseAddress!.assumingMemoryBound(to: P.self).pointee
    }
    
    if info.cases.allSatisfy(\.isEmpty) {
        // c-style
        buffer[0] = UInt8(assemblyInfo.emptyPayloadTag ?? assemblyInfo.tag)
        return peek
    }
    
    guard buffer.count > 0 else {
        // empty / degenerate
        return peek
    }
    
    let caseData = info.case(named: caseName)!
    
    if caseData.isEmpty {
        // no payload - put the empty payload tag in the payload start
        buffer[0] = UInt8(assemblyInfo.emptyPayloadTag!)
    } else {
        // pull the payloads in according to the caseData definition
        for (index, (typeInfo, typeOffset)) in caseData.types.enumerated() {
            // fast-forward to the offset for this payload entry
            withUnsafeBytes(of: payload[index]) { bytes in
                // fast-forward the buffer to the offset and on
                UnsafeMutableRawBufferPointer(rebasing: buffer[typeOffset...])
                                    // only take the slice of buffer the size of this payload type
                                    // Any is wrapped in a 32-bit buffer, the segment of size n is the underlying value
                    .copyMemory(from: UnsafeRawBufferPointer(rebasing: bytes[0..<typeInfo.size]))
            }
        }
    }
    
    // for single-case enums, there is no tag since it is the only case
    if info.cases.count > 1 {
        buffer[info.size - 1] = UInt8(assemblyInfo.tag)
    }
    
    return peek
}
