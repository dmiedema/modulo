//
//  TestCheckout.swift
//  modulo
//
//  Created by Sneed, Brandon on 1/15/17.
//  Copyright © 2017 TheHolyGrail. All rights reserved.
//

import XCTest
@testable import ModuloKit

class TestCheckout: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        moduloReset()
        print("working path = \(FileManager.workingPath())")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTagCheckout() {
        runCommand("mkdir checkout-test")
        
        FileManager.setWorkingPath("checkout-test")
        
        runCommand("git init")
        
        var result = Modulo.run(["init", "--app"])
        XCTAssertTrue(result == .success)
        
        result = Modulo.run(["add", "git@github.com:modulo-dm/test-checkout.git", "--version", "v2.0.0", "-u", "-v"])
        XCTAssertTrue(result == .success)
        
        XCTAssertTrue(FileManager.fileExists("modules/test-checkout"))
        
        let tags = Git().headTagsAtPath("modules/test-checkout")
        XCTAssertTrue(tags.contains("v2.0.0"))
    }
    
    func testTagRangeCheckout() {
        runCommand("mkdir checkout-test")
        
        FileManager.setWorkingPath("checkout-test")
        
        runCommand("git init")
        
        var result = Modulo.run(["init", "--app"])
        XCTAssertTrue(result == .success)
        
        result = Modulo.run(["add", "git@github.com:modulo-dm/test-checkout.git", "--version", ">0.0.2 <=2.0.1", "-u", "-v"])
        XCTAssertTrue(result == .success)
        
        XCTAssertTrue(FileManager.fileExists("modules/test-checkout"))
        
        let tags = Git().headTagsAtPath("modules/test-checkout")
        XCTAssertTrue(tags.contains("v2.0.1"))
    }

    func testTagNonSemverFails() {
        runCommand("mkdir checkout-test")
        
        FileManager.setWorkingPath("checkout-test")
        
        runCommand("git init")
        
        var result = Modulo.run(["init", "--app"])
        XCTAssertTrue(result == .success)
        
        result = Modulo.run(["add", "git@github.com:modulo-dm/test-checkout.git", "--version", "nosemver", "-u", "-v"])
        XCTAssertTrue(result == .commandError)
        
        XCTAssertTrue(!FileManager.fileExists("modules/test-checkout"))
    }
    
}
