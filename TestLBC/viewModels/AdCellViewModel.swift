//
//  AdViewModel.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 09/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation
import UIKit

class AdCellViewModel {
    
    internal let ad: Ad

    init(ad: Ad) {
        self.ad = ad
    }
    
    var displayTitle: String {
        return ad.title
    }
    
    var displayCategory: String {
        return "Catégorie : \(ad.category.name)"
    }
    
    var isUrgent: Bool {
        return ad.isUrgent
    }
    
    var displayPrice: String {
        return "Prix : \(ad.price.isInt ? ad.price.removeZerosFromEnd() : String(ad.price)) €"
    }
    
    func getImage(completion: @escaping (UIImage?) -> Void) {
        ad.imagesUrl.loadImage(for: .Small) { [weak self] in
            guard let strongSelf = self else { return }
            
            if let dataImg = strongSelf.ad.imagesUrl.smallData {
                DataManager.shared.saveAd(ad: strongSelf.ad)
                completion(UIImage(data: dataImg))
            } else {
                completion(nil)
            }
        }
    }
    
}
