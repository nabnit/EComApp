//
//  EComAPIHandler.swift
//  HeadyEComApp
//
//  Created by Patnaik, Nabnit [GCB-OT NE] on 6/1/19.
//  Copyright © 2019 Patnaik, Nabnit [GCB-OT NE]. All rights reserved.
//

import Foundation
struct EComAPI {
    typealias CompletionHandler = (_ data: EComResponseModel?, _ error: EComErrors?) -> Void
    // Incase we have more than one APIs to be invoked
    enum EndPoints {
        case apiUrl
        
        var url: String {
            switch self {
                case .apiUrl: return EComConstants.urlString
            }
        }
    }
    
    enum EComErrors {
        case noNetwork
        case parsingFailed
        case fileNotFound
        
        var message: String {
            switch self {
            case.noNetwork: return "Please check your internet connection"
            case .parsingFailed: return "Invalid data"
            case .fileNotFound: return "File not found"
            }
        }
    }
    
    enum EComRanking {
        case mostOrdered
        case mostShared
        case mostViewed
        
        var rawValue: String {
            switch self {
            case .mostOrdered: return "Most OrdeRed Products"
            case .mostShared: return "Most ShaRed Products"
            case .mostViewed: return "Most Viewed Products"
            }
        }
    }
    
    // Parse the cached data
    static func parseResponse(data: Data) -> EComResponseModel? {
        if let obj = try? JSONDecoder().decode(EComResponseModel.self, from: data) {
            return obj
        }
        return nil
    }
    
    // Get the data from cache (if exists) or invoke the API, write to the cache and get the data
    static func getEComResponse(completion: @escaping CompletionHandler) {
        
        if let obj = EComUtil.getCacheData().0 {
            completion(obj, nil)
        }
        else if EComUtil.getCacheData().1 == .parsingFailed {
            completion(nil, EComErrors.parsingFailed)
        }
        else {
            let url = URL(string: EComAPI.EndPoints.apiUrl.url)
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                
                if let _ = error {
                    completion(nil, EComErrors.noNetwork)

                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    _ = EComUtil.writeDataToCache(data: data)
                    DispatchQueue.main.async {
                        if let obj = EComUtil.getCacheData().0 {
                            completion(obj, nil)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}
