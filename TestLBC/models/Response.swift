//
//  Response.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 09/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation

class Ad {
    
    let id: Int
    let category: CategoryResponse?
    let title: String
    let description: String
    let price: Double
    let creationDate: String
    let isUrgent: Bool
    let siret: String?
    let imagesUrl: ImagesUrlResponse
    
    init(_ adResponse: AdResponse, _ categoriesResponse: [CategoryResponse]) {
        
        self.id = adResponse.id
        self.title = adResponse.title
        self.description = adResponse.description
        self.price = adResponse.price
        self.creationDate = adResponse.creationDate
        self.isUrgent = adResponse.isUrgent
        self.siret = adResponse.siret
        self.imagesUrl = adResponse.imagesUrl
        
        self.category = categoriesResponse.first(where: { $0.id == adResponse.categoryId })
    }
}
