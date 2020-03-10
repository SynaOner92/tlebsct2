//
//  AdResponse.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 09/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation

class ImagesUrl: Codable {
    let small: String?
    let thumb: String?
    
    var smallData: Data?
    var thumbData: Data?
    
    func loadImage(for imageType: ImageType, completion: @escaping (() -> Void)) {
         if imageIsLoaded(imageType: imageType) {
            completion()
         } else {
            guard let image = imageType == .Small ? small : thumb,
                let url = URL(string: image) else { completion(); return }

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil
                    else {
                        completion(); return
                }
               
                DispatchQueue.main.async() {
                    switch imageType {
                    case .Small:
                        self.smallData = data
                    case .Thumb:
                        self.thumbData = data
                    }
                    completion()
                }
            }.resume()
        }
    }
    
    private func imageIsLoaded(imageType: ImageType) -> Bool {
        switch imageType {
        case .Small:
            return smallData != nil
        case .Thumb:
            return thumbData != nil
        }
    }
    
    enum ImageType {
        case Small
        case Thumb
    }
}
