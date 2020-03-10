//
//  URLRequestExtension.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 09/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation

extension URLRequest {

    init(_ resource: Resource) {
        self.init(url: resource.url)
        self.httpMethod = resource.method
    }
}
