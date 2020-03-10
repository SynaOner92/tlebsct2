//
//  HomeViewModel.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 10/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation
import UIKit

class HomeViewModel {
    
    private var _ads: [Ad]?
    private var ads: [Ad]? {
        get {
            return _ads
        }
        set {
            _ads = filteredAdsByDate(ads: newValue)
        }
    }

    init(ads: [Ad]?) {
        self.ads = ads
    }
    
    var updateHandler: () -> Void = {}
    
    var currentAds: [Ad]? {
        return currentFilters == nil ? ads : ads?.filter { currentFilters!.contains($0.category) }
    }
    
    var numberOfAds: Int {
        return currentAds?.count ?? 0
    }
    
    var currentFilters: [AdCategory]? {
        didSet {
            updateHandler()
        }
    }
    
    private func filteredAdsByDate(ads: [Ad]?) -> [Ad]? {
        let urgentAds = ads?.filter { $0.isUrgent }.sorted(by: { $0.creationDate > $1.creationDate })
        let otherAds = ads?.filter { !$0.isUrgent }.sorted(by: { $0.creationDate > $1.creationDate })
        
        if urgentAds == nil && otherAds == nil {
            return nil
        }

        return (urgentAds ?? []) + (otherAds ?? [])
    }
}

