# EnumMagic

Dynamically construct an enum value based on its case name and an array of associated values

## Beware dragons!
This library brazenly works with unsafe bytes and bitcasts it back into the Swift type system. It is compatible with the current [Fragile Enum Layout](https://github.com/apple/swift/blob/2950c38a5d4f1f028d3786a278ae61eaf501f0d0/docs/ABI/TypeLayout.rst) specification.

## How to use it

```swift
import EnumMagic

enum IntDoubleOrBignum {  // => LLVM <{ i64, i2 }>
  case Int(Int)           // => <{ i64, i2 }> {           %Int,            0 }
  case Double(Double)     // => <{ i64, i2 }> { (bitcast  %Double to i64), 1 }
  case Bignum(Bignum)     // => <{ i64, i2 }> { (ptrtoint %Bignum to i64), 2 }
  case Alexis(Int, Double)
  case Blank1            // => <{ i64, i2 }> {           0,               3 }
  case Blank2            // => <{ i64, i2 }> {           1,               3 }
  case ASDFA(Int, Bignum)
}

let dynamicInt = CreateEnum(IntDoubleOrBignum.self, "Int", payload: [5])
let dynamicBlank1 = CreateEnum(IntDoubleOrBignum.self, "Blank1")
let dynamicBlank2 = CreateEnum(IntDoubleOrBignum.self, "Blank2")
let dynamicASDFA = CreateEnum(IntDoubleOrBignum.self, "ASDFA", payload: [6, Bignum(num: 5)])
```
