////  SingleCase.swift
//  MemoryLayoutExploration
//
//  Created by Eric Rabil on 8/29/21.
//  
//

import Foundation

// In the degenerate case of an enum with a single case, there is no discriminator needed, and the enum type has the exact same layout as its case's data type, or is empty if the case has no data type.

enum EmptyCase { case X }             // => empty type
enum DataCase { case Y(Int, Double) } // => LLVM <{ i64, double }>
