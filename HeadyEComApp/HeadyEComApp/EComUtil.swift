//
//  EComUtils.swift
//  HeadyEComApp
//
//  Created by Patnaik, Nabnit [GCB-OT NE] on 6/2/19.
//  Copyright © 2019 Patnaik, Nabnit [GCB-OT NE]. All rights reserved.
//

import Foundation
class EComUtil {
    typealias CacheResponse = (EComResponseModel?, EComAPI.EComErrors)
    static private let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    static private let jsonUrl = url!.appendingPathComponent(EComConstants.cachedFileName)
    
    static func getProductWithId (_ id: Int) -> ProductModel? {
        let result = EComDataController.sharedController.productsList.filter { $0.id == id }
        return result.first
    }
    
    static func updateDatacontroller(data: EComResponseModel) {
        EComDataController.sharedController.categoryList = (data.categories)
        EComDataController.sharedController.rankingList = (data.rankings)
        
        for cat in EComDataController.sharedController.categoryList {
            EComDataController.sharedController.productsList.append(contentsOf: cat.products!)
        }
    }
    
    // Check the filemanager and get the cached data (if exists)
    static func getCacheData() -> CacheResponse {
        print("PATH: \(jsonUrl.path)")
        if FileManager().fileExists(atPath: jsonUrl.path) {
            print("File exists")
            if let dataFromUrl = try? Data(contentsOf: jsonUrl) {
                return (EComAPI.parseResponse(data: dataFromUrl), EComAPI.EComErrors.parsingFailed)
            }
            
        }
        return (nil, EComAPI.EComErrors.fileNotFound)
    }
    
    // Write the data to the local cache
    static func writeDataToCache(data: Data) -> Bool {
        
        if let _ = try? data.write(to: jsonUrl) {
            return true
        }
        return false
    }
    
    // Deletes the local cache and resets the Datacontroller properties
    static func deleteCache() {
        do
        {
            try FileManager().removeItem(at: jsonUrl)
            resetDataController()
            print("Cache deleted")
        }
        catch {
            print("Error in deleting ")
        }
    }
    
    // Resets the Datacontroller peoperties
    static func resetDataController() {
        EComDataController.sharedController.categoryList = [CategoryModel]()
        EComDataController.sharedController.rankingList = [RankModel]()
        EComDataController.sharedController.productsList = [ProductModel]()
    }
    
}
