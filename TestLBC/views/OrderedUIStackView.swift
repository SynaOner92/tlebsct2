//
//  OrderedUIStackView.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 10/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation
import UIKit

enum AdContentView {
    case title
    case image
    case category
    case price
    case description
    case siret
    case creationDate
    case spacingView
}

class OrderedUIStackView: UIStackView {
    
    // MARK: var
    var adContentViews = [AdContentView]()
    
    // MARK: Init
    init() {
        super.init(frame: CGRect())
        addArrangedSubview(spacingView, adContentViewToAdd: .spacingView)
        spacingView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: private var
    private var _spacingView: UIView?
    private var spacingView: UIView {
        if _spacingView == nil {
            _spacingView = UIView()
        }
        
        return _spacingView!
    }
    // MARK: public func
    func addArrangedSubview(_ view: UIView, adContentViewToAdd: AdContentView) {
        let index = getIndex(adContentViewToAdd: adContentViewToAdd)
        adContentViews.append(adContentViewToAdd)
        insertArrangedSubview(view, at: index)
    }
    
    // MARK: private func
    private func getIndex(adContentViewToAdd: AdContentView) -> Int {
        switch adContentViewToAdd {
        case .title:
            return 0
        case .image:
            return countContains(adContentView: [.title])
        case .category:
            return countContains(adContentView: [.title, .image])
        case .price:
            return countContains(adContentView: [.title, .image, .category])
        case .description:
            return countContains(adContentView: [.title, .image, .category, .price])
        case .siret:
            return countContains(adContentView: [.title, .image, .category, .price, .description])
        case .creationDate:
            return countContains(adContentView: [.title, .image, .category, .price, .description, .siret])
        case .spacingView:
            return countContains(adContentView: [.title, .image, .category, .price, .description, .siret, .creationDate])
        }
    }
    
    private func countContains(adContentView: [AdContentView]) -> Int {
        let viewContains = adContentViews.filter({ contentView in
            adContentView.contains(contentView)
        }).count
        
        if viewContains == subviews.count {
            return subviews.count
        } else {
            return viewContains
        }
    }

}
