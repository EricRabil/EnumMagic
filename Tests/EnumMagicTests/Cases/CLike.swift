////  CLike.swift
//  MemoryLayoutExploration
//
//  Created by Eric Rabil on 8/29/21.
//  
//

import Foundation

enum EnumLike2 { // => LLVM i1
  case A         // => i1 0
  case B         // => i1 1
}

enum EnumLike8 { // => LLVM i3
  case A         // => i3 0
  case B         // => i3 1
  case C         // => i3 2
  case D         // etc.
  case E
  case F
  case G
  case H
}
