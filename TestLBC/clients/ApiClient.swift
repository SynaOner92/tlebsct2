//
//  ApiClient.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 09/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation

class ApiClient {
    
    static let shared = ApiClient()
    
    private let decoder = JSONDecoder()
    
    private init() { }
    
    func load(_ resource: Resource, result: @escaping ((Result<Data>) -> Void)) {
        
        let request = URLRequest(resource)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let `data` = data else {
                result(.failure(ApiClientError.noData))
                return
            }
            if let `error` = error {
                result(.failure(error))
                return
            }
            result(.success(data))
        }
        task.resume()
    }
}
