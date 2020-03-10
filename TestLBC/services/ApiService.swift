//
//  ApiService.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 09/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation

class ApiService {
    
    static let shared = ApiService()
    
    private let decoder = NSCoder()
    
    private init() { }
    
    private let baseApiUrl = "https://raw.githubusercontent.com/leboncoin/paperclip/master/"
    
    func getAds(_ completion: @escaping ((Result<[Ad]>) -> Void)) {
        let urlToCall = baseApiUrl + "listing.json"
        let resource = Resource(url: URL(string: urlToCall)!)
        
        ApiClient.shared.load(resource) { (result) in
            switch result {
            case .success(let data):
                do {
                    let items = try JSONDecoder().decode([Ad].self, from: data)
                    completion(.success(items))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCategories(_ completion: @escaping ((Result<[AdCategory]>) -> Void)) {
        let urlToCall = baseApiUrl + "categories.json"
        let resource = Resource(url: URL(string: urlToCall)!)
        
        ApiClient.shared.load(resource) { (result) in
            switch result {
            case .success(let data):
                do {
                    let items = try JSONDecoder().decode([AdCategory].self, from: data)
                    completion(.success(items))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

}
