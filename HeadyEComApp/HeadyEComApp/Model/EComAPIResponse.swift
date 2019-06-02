//
//  RankModel.swift
//  HeadyEComApp
//
//  Created by Patnaik, Nabnit [GCB-OT NE] on 5/31/19.
//  Copyright © 2019 Patnaik, Nabnit [GCB-OT NE]. All rights reserved.
//
public class VariantModel: Decodable {
    var id: Int?
    var color = ""
    var size: Int?
    var price: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case color
        case size
        case price
    }
    required public init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        id = try data.decodeIfPresent(Int.self, forKey: .id)
        color = try data.decodeIfPresent(String.self, forKey: .color) ?? ""
        size = try data.decodeIfPresent(Int.self, forKey: .size)
        price = try data.decodeIfPresent(Int.self, forKey: .price)
    }
}

public class TaxModel: Codable {
    var name = ""
    var value: Double?
    
    enum CodingKeys: String, CodingKey {
        case name
        case value
    }
    required public init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        name = try data.decodeIfPresent(String.self, forKey: .name) ?? ""
        value = try data.decodeIfPresent(Double.self, forKey: .value)
    }
    init(){ }
}

public class ProductModel: Decodable {
    var id: Int?
    var name = ""
    var dateAdded = ""
    var variants = [VariantModel]()
    var tax: TaxModel
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case dateAdded = "date_added"
        case variants
        case tax
    }
    required public init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        id = try data.decodeIfPresent(Int.self, forKey: .id)
        name = try data.decodeIfPresent(String.self, forKey: .name) ?? ""
        dateAdded = try data.decodeIfPresent(String.self, forKey: .dateAdded) ?? ""
        variants = try data.decodeIfPresent([VariantModel].self, forKey: .variants) ?? [VariantModel]()
        tax = try data.decodeIfPresent(TaxModel.self, forKey: .tax) ?? TaxModel()
    }
}

public class RankingProductModel: Decodable {
    var id: Int?
    var categoryValue: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case shares
        case orderCount = "order_count"
        case viewCount = "view_count"
        
    }
    required public init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        id = try data.decodeIfPresent(Int.self, forKey: .id)
        if let catValue = try data.decodeIfPresent(Int.self, forKey: .viewCount) {
            categoryValue = catValue
        }
        else if let catValue = try data.decodeIfPresent(Int.self, forKey: .orderCount) {
            categoryValue = catValue
        }
        else {
            categoryValue = try data.decodeIfPresent(Int.self, forKey: .shares)
        }
        
    }
}

class RankModel: Decodable {
    var ranking = ""
    var products: [RankingProductModel]?
    
    enum CodingKeys: String, CodingKey {
        case ranking
        case products
    }
    required init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        ranking = try data.decodeIfPresent(String.self, forKey: .ranking) ?? ""
        products = try data.decodeIfPresent([RankingProductModel].self, forKey: .products) ?? [RankingProductModel]()
    }
}

class CategoryModel: Decodable {
    var id: Int?
    var name = ""
    var products: [ProductModel]?
    var childCategory: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case products
        case childCategory = "child_categories"
    }
    required init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        id = try data.decodeIfPresent(Int.self, forKey: .id)
        name = try data.decodeIfPresent(String.self, forKey: .name) ?? ""
        products = try data.decodeIfPresent([ProductModel].self, forKey: .products) ?? [ProductModel]()
        childCategory = try data.decodeIfPresent([Int].self, forKey: .childCategory) ?? [Int]()
    }
}

class EComResponseModel: Decodable {
    var categories: [CategoryModel]
    var rankings: [RankModel]
    enum CodingKeys: String, CodingKey {
        case categories
        case rankings
    }
    required init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        categories = try data.decodeIfPresent([CategoryModel].self, forKey: .categories) ?? [CategoryModel]()
        rankings = try data.decodeIfPresent([RankModel].self, forKey: .rankings) ?? [RankModel]()
    }
}
