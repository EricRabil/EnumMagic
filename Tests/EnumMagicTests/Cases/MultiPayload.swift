////  MultiPayload.swift
//  MemoryLayoutExploration
//
//  Created by Eric Rabil on 8/29/21.
//  
//

import Foundation

/**
 If an enum has more than one case with data type, then a tag is necessary to discriminate the data types. The ABI will first try to find common spare bits, that is, bits in the data types' binary representations which are either fixed-zero or ignored by valid values of all of the data types. The tag will be scattered into these spare bits as much as possible. Currently only spare bits of primitive integer types, such as the high bits of an i21 type, are considered. The enum data is represented as an integer with the storage size in bits of the largest data type.
 */

enum TerminalChar {             // => LLVM i32
  case Plain(UnicodeScalar)     // => i32     (zext i21 %Plain     to i32)
  case Bold(UnicodeScalar)      // => i32 (or (zext i21 %Bold      to i32), 0x0020_0000)
  case Underline(UnicodeScalar) // => i32 (or (zext i21 %Underline to i32), 0x0040_0000)
  case Blink(UnicodeScalar)     // => i32 (or (zext i21 %Blink     to i32), 0x0060_0000)
  case Empty                    // => i32 0x0080_0000
  case Cursor                   // => i32 0x0080_0001
}

/**
 If there are not enough spare bits to contain the tag, then additional bits are added to the representation to contain the tag. Tag values are assigned to data cases in declaration order. If there are no-data cases, they are collected under a common tag, and assigned values in the data area of the enum in declaration order.
 */

class Bignum {
    var badussy = 4
}

enum IntDoubleOrBignum {  // => LLVM <{ i64, i2 }>
  case Int(Int)           // => <{ i64, i2 }> {           %Int,            0 }
  case Double(Double)     // => <{ i64, i2 }> { (bitcast  %Double to i64), 1 }
  case Bignum(Bignum)     // => <{ i64, i2 }> { (ptrtoint %Bignum to i64), 2 }
  case Alexis(Int, Double)
  case Badussy            // => <{ i64, i2 }> {           0,               3 }
  case Thrussy            // => <{ i64, i2 }> {           1,               3 }
  case ASDFA(Int, Bignum)
}

enum OtherEnum {
    case FatInt(Int)
    case ShittyInt(Int)
}
