//
//  AdCell.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 09/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation
import UIKit

class AdCell: UICollectionViewCell {
    
    // MARK: Override
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let imageView = imageViews.first(where: { $0.tag == ImageViewTags.image.rawValue }) {
            imageView.image = nil
        }
        activityIndicator.startAnimating()
    }
    
    // MARK: private view model
    private var adCellViewModel: AdCellViewModel!
    
    // MARK: private var (views)
    
    private enum ActivityIndicatorTags: Int {
        case activityIndicator
    }
    private var activityIndicators = [UIActivityIndicatorView]()
    private var activityIndicator: UIActivityIndicatorView {
        if let activityIndicator = activityIndicators.first(where: { $0.tag == ActivityIndicatorTags.activityIndicator.rawValue }) {
            return activityIndicator
        } else {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.hidesWhenStopped = true
            activityIndicators.append(activityIndicator)
            return activityIndicator
        }
    }
    
    private enum StackViewTags: Int {
        case ad
    }
    private var stackViews = [UIStackView]()
    private var stackViewAd: UIStackView {
        if let stackViewAd = stackViews.first(where: { $0.tag == StackViewTags.ad.rawValue }) {
            return stackViewAd
        } else {
            let stackView = UIStackView()
            stackView.frame = CGRect(origin: bounds.origin,
                                     size: bounds.size)
            stackView.axis = .vertical
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackViews.append(stackView)
            return stackView
        }
    }
    
    private enum ImageViewTags: Int {
        case image
        case urgent
    }
    private var imageViews = [UIImageView]()
    
    private enum LabelViewTags: Int {
        case title
        case price
        case category
    }
    private var labels = [UILabel]()
    
    // MARK: Setup
    func setup(adCellViewModel: AdCellViewModel) {
        self.adCellViewModel = adCellViewModel
        
        setShadow()
        setLabels()
        setImages()
    }
    
    // MARK: private func
    private func setLabels() {
        createLabelIfNeeded(numberOfLines: 2,
                            tag: LabelViewTags.title.rawValue,
                            text: adCellViewModel.displayTitle,
                            fontSize: 15)
        createLabelIfNeeded(numberOfLines: 1,
                            tag: LabelViewTags.price.rawValue,
                            text: adCellViewModel.displayPrice,
                            fontSize: 15)
        createLabelIfNeeded(numberOfLines: 1,
                            tag: LabelViewTags.category.rawValue,
                            text: adCellViewModel.displayCategory,
                            fontSize: 14)
    }
    
    private func createLabelIfNeeded(numberOfLines: Int,
                                     tag: Int,
                                     text: String,
                                     textAlign: NSTextAlignment = .left,
                                     fontSize: CGFloat = 20) {
        
        let label = UICreator.createLabelIfNeeded(numberOfLines: numberOfLines,
                                                  tag: tag,
                                                  text: text,
                                                  textAlign: textAlign,
                                                  existingLabels: labels,
                                                  fontSize: fontSize)

        labels.append(label)
        stackViewAd.insertArrangedSubview(label, at: stackViewAd.arrangedSubviews.count)
    }
    
    private func setShadow() {
        layer.borderWidth = 2
        layer.cornerRadius = 10
        layer.borderColor = UIColor(red: 28/255, green: 47/255, blue: 112/255, alpha: 1.0).cgColor
        backgroundColor = UIColor(red: 54/255, green: 95/255, blue: 178/255, alpha: 0.5)

        addSubview(stackViewAd)
        stackViewAd.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        stackViewAd.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        stackViewAd.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stackViewAd.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    
    }

    private func setImages() {
        createImageViewIfNeeded(tag: .image)
        createImageViewIfNeeded(tag: .urgent)

        activityIndicator.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        activityIndicator.startAnimating()
    }
    
    private func createImageViewIfNeeded(tag: ImageViewTags) {
        if let imageView = imageViews.first(where: { $0.tag == tag.rawValue }) {
            switch tag {
            case .image:
                loadImage(imageView: imageView)
            case .urgent:
                imageView.isHidden = !adCellViewModel.isUrgent
            }
        } else {
            let imageView = UIImageView()
            imageViews.append(imageView)
            
            switch tag {
            case .image:
                stackViewAd.insertArrangedSubview(imageView, at: 0)
                imageView.addSubview(activityIndicator)
                loadImage(imageView: imageView)
            case .urgent:
                addSubview(imageView)
                imageView.image = UIImage(named: "urgent")
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1).isActive = true
                imageView.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
                imageView.isHidden = !adCellViewModel.isUrgent
            }
        }
    }
    
    private func loadImage(imageView: UIImageView) {
        adCellViewModel.getImage { [weak self] image in
            
            guard let strongSelf = self else { return }

            DispatchQueue.main.async {
                imageView.image = image ?? UIImage(named: "no_image")
                strongSelf.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
}

