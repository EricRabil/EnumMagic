////  SinglePayload.swift
//  MemoryLayoutExploration
//
//  Created by Eric Rabil on 8/29/21.
//  
//

import Foundation

/**
 If an enum has a single case with a data type and one or more no-data cases (a "single-payload" enum), then the case with data type is represented using the data type's binary representation, with added zero bits for tag if necessary. If the data type's binary representation has extra inhabitants, that is, bit patterns with the size and alignment of the type but which do not form valid values of that type, they are used to represent the no-data cases, with extra inhabitants in order of ascending numeric value matching no-data cases in declaration order. If the type has spare bits (see Multi-Payload Enums), they are used to form extra inhabitants. The enum value is then represented as an integer with the storage size in bits of the data type. Extra inhabitants of the payload type not used by the enum type become extra inhabitants of the enum type itself.
 */

enum CharOrSectionMarker { // => LLVM i32
  case Paragraph           // => i32 0x0020_0000
  case Char(UnicodeScalar) // => i32 (zext i21 %Char to i32)
  case Chapter             // => i32 0x0020_0001
}

// CharOrSectionMarker.Char('\x00') // => i32 0x0000_0000
// CharOrSectionMarker.Char('\u10FFFF') // => i32 0x0010_FFFF

enum CharOrSectionMarkerOrFootnoteMarker {      // => LLVM i32
  case CharOrSectionMarker(CharOrSectionMarker) // => i32 %CharOrSectionMarker
  case Asterisk                                 // => i32 0x0020_0002
  case Dagger                                   // => i32 0x0020_0003
  case DoubleDagger                             // => i32 0x0020_0004
}

/**
 If the data type has no extra inhabitants, or there are not enough extra inhabitants to represent all of the no-data cases, then a tag bit is added to the enum's representation. The tag bit is set for the no-data cases, which are then assigned values in the data area of the enum in declaration order.
 */

enum IntOrInfinity {        // => LLVM <{ i64, i1 }>
  case NegInfinity          // => <{ i64, i1 }> {    0, 1 }
  case Int(Int)             // => <{ i64, i1 }> { %Int, 0 }
  case PosInfinity          // => <{ i64, i1 }> {    1, 1 }
}

// IntOrInfinity.Int(    0) // => <{ i64, i1 }> {     0, 0 }
// IntOrInfinity.Int(20721) // => <{ i64, i1 }> { 20721, 0 }
