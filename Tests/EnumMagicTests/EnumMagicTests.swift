import XCTest
@testable import EnumMagic

final class EnumMagicTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//            XCTAssertEqual(EnumMagic().text, "Hello, World!")
    }
    
    func testCLikeEnums() {
        ["A","B","C","D","E","F","G","H"].forEach { letter in
            XCTAssertEqual(letter, String(describing: CreateEnum(EnumLike8.self, caseName: letter, payload: [])))
        }
    }
    
    func testSingleCaseEnums() {
        switch CreateEnum(DataCase.self, caseName: "Y", payload: [1, 1.2]) {
        case .Y(let int, let double):
            XCTAssertEqual(int, 1)
            XCTAssertEqual(double, 1.2)
        default:
            XCTFail("Did not get expected case")
        }
    }
    
    func testMultiPayloadEnums1() {
        let asdfas = Bignum()
        asdfas.badussy = 15

        switch CreateEnum(IntDoubleOrBignum.self, caseName: "ASDFA", payload: [17, asdfas]) {
        case .ASDFA(let myInt, let myBignum):
            XCTAssertEqual(myInt, 17)
            XCTAssertEqual(myBignum.badussy, asdfas.badussy)
        default:
            XCTFail()
        }
    }
    
    func testMultiPayloadEnums2() {
        let bignum = Bignum()
        bignum.badussy = 10

        switch CreateEnum(IntDoubleOrBignum.self, caseName: "Bignum", payload: [bignum]) {
        case .Bignum(let badussy):
            XCTAssertEqual(badussy.badussy, bignum.badussy)
        default:
            XCTFail()
        }
        
        switch CreateEnum(IntDoubleOrBignum.self, caseName: "OtherInt", payload: [12]) {
        case .OtherInt(let otherInt):
            XCTAssertEqual(otherInt, 12)
        default: XCTFail()
        }
    }
    
    func testMultiPayloadEmptyPayloadSegment() {
        switch CreateEnum(IntDoubleOrBignum.self, caseName: "Badussy") {
        case .Badussy:
            return
        default:
            XCTFail()
        }
    }
    
    func testSinglePayloadEnums() {
        switch CreateEnum(IntOrInfinity.self, caseName: "NegInfinity") {
        case .NegInfinity:
            break
        default:
            XCTFail()
        }
        
        switch CreateEnum(IntOrInfinity.self, caseName: "Int", payload: [12]) {
        case .Int(let int):
            XCTAssertEqual(int, 12)
        default:
            XCTFail()
        }
        
        switch CreateEnum(IntOrInfinity.self, caseName: "PosInfinity") {
        case .PosInfinity:
            break
        default:
            XCTFail()
        }
    }
}
