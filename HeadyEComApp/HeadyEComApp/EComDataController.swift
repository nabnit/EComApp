//
//  DataController.swift
//  HeadyEComApp
//
//  Created by Patnaik, Nabnit [GCB-OT NE] on 5/31/19.
//  Copyright © 2019 Patnaik, Nabnit [GCB-OT NE]. All rights reserved.
//

import Foundation
class EComDataController {
     //Returns the singleton instance of the DataController
    static let sharedController = EComDataController()

    var isLoggedIn: Bool = false
    var categoryList = [CategoryModel]()
    var rankingList = [RankModel]()
    var productsList = [ProductModel]()
    private init() {
    }
}
