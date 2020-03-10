//
//  Ad.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 09/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation

class Ad: Codable {
    
    let id: Int
    let categoryId: Int
    let title: String
    let description: String
    let price: Double
    let creationDate: String
    let isUrgent: Bool
    let siret: String?
    let imagesUrl: ImagesUrl
    
    var category: AdCategory {
        return DataManager.shared.getSavedCategories()?.first(where: { $0.id == categoryId }) ?? AdCategory(id: 0, name: "unknown")
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, price, siret
        case categoryId = "category_id"
        case isUrgent = "is_urgent"
        case creationDate = "creation_date"
        case imagesUrl = "images_url"
    }
}
