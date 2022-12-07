//
//  ExtensionsTests.swift
//  DaffyTypeaheadProjectTests
//
//  Created by Jon Evans on 12/5/22.
//

@testable import DaffyTypeaheadProject
import XCTest

final class ExtensionsTests: XCTestCase {

    func testIsolateYearFromReleaseDateValid() throws {
        let validReleaseDate = "1997-08-24"
        XCTAssert(validReleaseDate.isolateYearFromReleaseDate() == "-1997")
    }
    
    func testIsolateYearFromReleaseDateEmpty() throws {
        let emptyReleaseDate = ""
        XCTAssert(emptyReleaseDate.isolateYearFromReleaseDate() == "")
    }
    
    func testIsolateYearFromReleaseDateInvalidInput() throws {
        let invalidReleaseDate = "Invalid Input -08-24 !@#$"
        XCTAssert(invalidReleaseDate.isolateYearFromReleaseDate() == "")
    }
}
