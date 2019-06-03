//
//  HeadyEComAppTests.swift
//  HeadyEComAppTests
//
//  Created by Patnaik, Nabnit [GCB-OT NE] on 5/30/19.
//  Copyright © 2019 Patnaik, Nabnit [GCB-OT NE]. All rights reserved.
//

import XCTest
@testable import HeadyEComApp

class HeadyEComAppTests: XCTestCase {
    let testBundle = Bundle(for: HeadyEComAppTests.self)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test01_deleteCache() {
        let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let jsonUrl = url!.appendingPathComponent(EComConstants.cachedFileName)
        
        EComUtil.deleteCache()        
        XCTAssertFalse(FileManager().fileExists(atPath: jsonUrl.path))
    }
    
    func test02_writeToCache() {
        let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let jsonUrl = url!.appendingPathComponent(EComConstants.cachedFileName)
        
        let data = Data()
        _ = EComUtil.writeDataToCache(data: data)
        XCTAssertTrue(FileManager().fileExists(atPath: jsonUrl.path))
    }
    
    func test03_getCache() {
        
        if let path = testBundle.path(forResource: "SampleTest", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                _ = EComUtil.writeDataToCache(data: data)
                let response = EComUtil.getCacheData()
                XCTAssertNotNil(response.0)

            } catch {
                // handle error
            }
        }
    }
    
    func test04_getProductFromId() {
        let id = 1
        if let path = testBundle.path(forResource: "SampleTest", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                _ = EComUtil.writeDataToCache(data: data)
                sleep(2)
                EComUtil.updateDatacontroller(data: EComUtil.getCacheData().0!)
            }
            catch {
                
            }
        }
        let obj = EComUtil.getProductWithId(id)
        XCTAssertEqual(obj?.name, "Nike Sneakers")
    }
}
