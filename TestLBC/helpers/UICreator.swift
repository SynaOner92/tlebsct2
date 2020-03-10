//
//  UICreator.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 10/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation
import UIKit

class UICreator {
    
    static func createLabelIfNeeded(numberOfLines: Int,
                                    tag: Int,
                                    text: String,
                                    textAlign: NSTextAlignment,
                                    existingLabels: [UILabel]?,
                                    fontWeight: UIFont.Weight = .regular,
                                    fontSize: CGFloat = 20) -> UILabel {
        
        if let label = existingLabels?.first(where: { $0.tag == tag }) {
            label.text = text
            return label
        } else {
             let labelShow = UILabel(frame: CGRect())
             labelShow.numberOfLines = numberOfLines
             labelShow.setContentHuggingPriority(UILayoutPriority(252),
                                                 for: .vertical)
             labelShow.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
             labelShow.tag = tag

//             let maximumLabelSize = CGSize(width: view.frame.width, height: view.frame.height)
//             let expectedLabelSize: CGSize = labelShow.sizeThatFits(maximumLabelSize)
//             var newFrame = labelShow.frame
//             newFrame.size.height = expectedLabelSize.height
//             newFrame.size.width = expectedLabelSize.width
//             labelShow.frame = newFrame
            
             labelShow.textAlignment = textAlign

             labelShow.text = text
            
            return labelShow

//             labels.append(labelShow)
//             stackViewDetails.addArrangedSubview(labelShow,
//                                                 adContentViewToAdd: adContentView)
            
        }
    }
}
