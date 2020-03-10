//
//  GenericResult.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 09/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
