//
//  DataManager.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 09/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation


class DataManager {
    
    static let shared = DataManager()
    
    private let defaults = UserDefaults.standard
    
    private init() { }
    
    func saveAd(ad: Ad) {
        var savedAds = getSavedAds()
        savedAds?.removeAll(where: { $0.id == ad.id })
        
        if savedAds == nil {
            savedAds = []
        }
        savedAds?.append(ad)
        defaults.set(try? PropertyListEncoder().encode(savedAds), forKey: DefaultsKeys.ads)
    }
    
    func saveAds(ads: [Ad],
                 takeCareOfOldAds: Bool = true) {
        if takeCareOfOldAds {
            ads.forEach { ad in
                saveAd(ad: ad)
            }
        } else {
            defaults.set(try? PropertyListEncoder().encode(ads), forKey: DefaultsKeys.ads)
        }
    }
    
    func getSavedAds() -> [Ad]? {
        if let cachedValue = defaults.value(forKey: DefaultsKeys.ads) as? Data,
            let ads = try? PropertyListDecoder().decode([Ad].self, from: cachedValue) {
                return ads
        }
        return nil
    }
    
    func saveCategory(category: AdCategory) {
        var savedCategories = getSavedCategories()
        savedCategories?.removeAll(where: { $0.id == category.id })
        
        if savedCategories == nil {
            savedCategories = []
        }
        savedCategories?.append(category)
        defaults.set(try? PropertyListEncoder().encode(savedCategories), forKey: DefaultsKeys.adCategories)
    }
    
    func saveCategories(categories: [AdCategory],
                        takeCareOfOldCategories: Bool = true) {
        if takeCareOfOldCategories {
            categories.forEach { category in
                saveCategory(category: category)
            }
        } else {
            defaults.set(try? PropertyListEncoder().encode(categories), forKey: DefaultsKeys.adCategories)
        }
    }
    
    func getSavedCategories() -> [AdCategory]? {
        if let cachedValue = defaults.value(forKey: DefaultsKeys.adCategories) as? Data,
            let savedCategories = try? PropertyListDecoder().decode([AdCategory].self, from: cachedValue) {
                return savedCategories
        }
        return nil
    }
    
}
