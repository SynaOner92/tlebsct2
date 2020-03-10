//
//  DetailedAdViewModel.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 10/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation
import UIKit

class DetailedAdViewModel: AdCellViewModel {
    
    var reference: String {
        return "Référence : \(ad.id)"
    }
    
    var displayDescription: String {
        return "Description : \(ad.description)"
    }
    
    var displayCreationDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateObj = dateFormatter.date(from: ad.creationDate)
        dateFormatter.dateFormat = "dd/MM/yyyy à hh'h'mm"
        return "Annonce postée le : \(dateFormatter.string(from: dateObj!))"
    }
    
    var isSiretAvailable: Bool {
        return ad.siret != nil
    }
    
    var displaySiret: String {
        return "Siret : \(ad.siret!)"
    }
    
    override func getImage(completion: @escaping (UIImage?) -> Void) {
        ad.imagesUrl.loadImage(for: .Thumb) { [weak self] in
            guard let strongSelf = self else { return }
            
            if let dataImg = strongSelf.ad.imagesUrl.thumbData {
                DataManager.shared.saveAd(ad: strongSelf.ad)
                completion(UIImage(data: dataImg))
            } else {
                completion(nil)
            }
        }
    }
}
