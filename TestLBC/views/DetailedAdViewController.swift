//
//  DetailedAdViewController.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 10/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation
import UIKit

@objcMembers
class DetailedAdViewController: UIViewController {
    
    // MARK: Init
    init(detailedAdViewModel: DetailedAdViewModel) {
        self.detailedAdViewModel = detailedAdViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: var view model
    var detailedAdViewModel: DetailedAdViewModel
    
    // MARK: private var (views)
    private enum LabelViewTags: Int, CaseIterable {
        case title
        case category
        case price
        case description
        case creationDate
        case siret
    }
    private var labels = [UILabel]()
    
    private var _scrollViewAd: UIScrollView?
    private var scrollViewAd: UIScrollView {
        if _scrollViewAd == nil {
            let scrollview = UIScrollView()
            scrollview.translatesAutoresizingMaskIntoConstraints = false
            _scrollViewAd = scrollview
        }
        return _scrollViewAd!
    }
    
    private var _stackViewDetails: OrderedUIStackView?
    private var stackViewDetails: OrderedUIStackView {
        if _stackViewDetails == nil {
            let stackView = OrderedUIStackView()
            stackView.frame = CGRect(origin: view.bounds.origin,
                                     size: view.bounds.size)
            stackView.axis = .vertical
            stackView.spacing = 10
            _stackViewDetails = stackView
        }
        return _stackViewDetails!
    }
    
    private var _activityIndicator: UIActivityIndicatorView?
    private var activityIndicator: UIActivityIndicatorView {
        if _activityIndicator == nil {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.hidesWhenStopped = true
            _activityIndicator = activityIndicator
        }
        return _activityIndicator!
    }
    
    // TODO passer les boutons sur la même var comme les labels
    private var _buttonNextAd: UIBarButtonItem?
    private var buttonNextAd: UIBarButtonItem {
        if _buttonNextAd == nil {
            let button = UIBarButtonItem(title: "↓",
                                         style: .plain,
                                         target: self,
                                         action: #selector(nextAdButton(sender:)))
            button.tintColor = .white
            _buttonNextAd = button
        }
        return _buttonNextAd!
    }
    
    private var _buttonPreviousAd: UIBarButtonItem?
    private var buttonPreviousAd: UIBarButtonItem {
        if _buttonPreviousAd == nil {
            let button = UIBarButtonItem(title: "↑",
                                         style: .plain,
                                         target: self,
                                         action: #selector(previousAdButton(sender:)))
            button.tintColor = .white
            _buttonPreviousAd = button
        }
        return _buttonPreviousAd!
    }
    
    // TODO passer les images sur la même var comme les labels
    private var _imageViewAdUrgent: UIImageView?
    private var imageViewAdUrgent: UIImageView {
        if _imageViewAdUrgent == nil {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.image = UIImage(named: "urgent")
            _imageViewAdUrgent = imageView
        }
        _imageViewAdUrgent?.isHidden = !detailedAdViewModel.isUrgent
        return _imageViewAdUrgent!
    }
    
    private var _imageViewDetails: UIImageView?
    private var imageViewDetails: UIImageView {
        if _imageViewDetails == nil {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            _imageViewDetails = imageView
        }
        return _imageViewDetails!
    }
    
    // MARK: VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = navigationController,
        navigationController.viewControllers.count > 2 {
            navigationController.viewControllers.remove(at: navigationController.viewControllers.count-2)
        }
        
        title = detailedAdViewModel.reference
        
        view.backgroundColor = .white
        
        addScrollView()
        addStackView()
        
        addLabels()
        
        addImageView()
        navigationItem.rightBarButtonItems = [buttonNextAd, buttonPreviousAd]
    }
    
    // MARK: objc members
    func nextAdButton(sender: UIBarButtonItem) {
        moveTo(nextAd: true)
    }
    
    func previousAdButton(sender: UIBarButtonItem) {
        moveTo(nextAd: false)
    }
    
    // MARK: private func
    private func addLabels() {
    
        createAndAddLabelIfNeeded(tag: LabelViewTags.title.rawValue,
                                  text: detailedAdViewModel.displayTitle,
                                  textAlign: .center,
                                  fontWeight: .heavy,
                                  fontSize: 20,
                                  addContentViewToAdd: .title)
        
        createAndAddLabelIfNeeded(tag: LabelViewTags.category.rawValue,
                                  text: detailedAdViewModel.displayCategory,
                                  textAlign: .left,
                                  fontWeight: .regular,
                                  fontSize: 18,
                                  addContentViewToAdd: .category)
        
        createAndAddLabelIfNeeded(tag: LabelViewTags.price.rawValue,
                                  text: detailedAdViewModel.displayPrice,
                                  textAlign: .left,
                                  fontWeight: .regular,
                                  fontSize: 18,
                                  addContentViewToAdd: .price)
        
        createAndAddLabelIfNeeded(tag: LabelViewTags.description.rawValue,
                                  text: detailedAdViewModel.displayDescription,
                                  textAlign: .justified,
                                  fontWeight: .regular,
                                  fontSize: 18,
                                  addContentViewToAdd: .description)
        
        createAndAddLabelIfNeeded(tag: LabelViewTags.creationDate.rawValue,
                                  text: detailedAdViewModel.displayCreationDate,
                                  textAlign: .left,
                                  fontWeight: .regular,
                                  fontSize: 18,
                                  addContentViewToAdd: .creationDate)
        
        if detailedAdViewModel.isSiretAvailable {
            createAndAddLabelIfNeeded(tag: LabelViewTags.siret.rawValue,
                                      text: detailedAdViewModel.displaySiret,
                                      textAlign: .left,
                                      fontWeight: .regular,
                                      fontSize: 18,
                                      addContentViewToAdd: .siret)
        }
    }
    
    private func createAndAddLabelIfNeeded(numberOfLines: Int = 0,
                                           tag: Int,
                                           text: String,
                                           textAlign: NSTextAlignment,
                                           fontWeight: UIFont.Weight = .regular,
                                           fontSize: CGFloat = 20,
                                           addContentViewToAdd: AdContentView) {
        
        let label = UICreator.createLabelIfNeeded(numberOfLines: 0,
                                                  tag: tag,
                                                  text: text,
                                                  textAlign: textAlign,
                                                  existingLabels: labels,
                                                  fontWeight: fontWeight,
                                                  fontSize: fontSize)
        labels.append(label)
        stackViewDetails.addArrangedSubview(label,
                                            adContentViewToAdd: addContentViewToAdd)
    }
    
    private func moveTo(nextAd: Bool) {
        if let navigationController = navigationController,
            let homeViewController = navigationController.viewControllers.first(where: { $0 is HomeViewController }) as? HomeViewController,
            let selectedIndex = homeViewController.selectedIndex,
            let ads = homeViewController.homeViewModel.currentAds,
            ads.count > (nextAd ? selectedIndex+1 : selectedIndex-1),
            (nextAd ? selectedIndex+1 : selectedIndex-1) >= 0 {
            
            homeViewController.selectedIndex! += (nextAd ? 1 : -1)
            let nextAdViewModel = DetailedAdViewModel(ad: ads[(nextAd ? selectedIndex+1 : selectedIndex-1)])
            let detailsNextAdViewController = DetailedAdViewController(detailedAdViewModel: nextAdViewModel)
            
            navigationController.pushViewController(detailsNextAdViewController, animated: true)
        }
    }
    
    private func addScrollView() {
        view.addSubview(scrollViewAd)
        
        scrollViewAd.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                          constant: 20).isActive = true
        scrollViewAd.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                             constant: -20).isActive = true
        scrollViewAd.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                           constant: 0).isActive = true
        scrollViewAd.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                            constant: 0).isActive = true
    }
    
    private func addStackView() {

        scrollViewAd.addSubview(stackViewDetails)
        
        stackViewDetails.translatesAutoresizingMaskIntoConstraints = false
        
        stackViewDetails.topAnchor.constraint(equalTo: scrollViewAd.topAnchor).isActive = true
        stackViewDetails.bottomAnchor.constraint(equalTo: scrollViewAd.bottomAnchor).isActive = true
        stackViewDetails.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                           constant: 20).isActive = true
        stackViewDetails.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                            constant: -20).isActive = true
    }
    
    private func addImageView() {
        
        detailedAdViewModel.getImage { [weak self] image in
            
            guard let strongSelf = self else { return }

            DispatchQueue.main.async {
                strongSelf.imageViewDetails.image = image ?? UIImage(named: "no_image")
                strongSelf.stackViewDetails.addArrangedSubview(strongSelf.imageViewDetails,
                                                               adContentViewToAdd: .image)
            }
        }
        
        imageViewDetails.addSubview(imageViewAdUrgent)
        imageViewAdUrgent.translatesAutoresizingMaskIntoConstraints = false
        imageViewAdUrgent.leadingAnchor.constraint(equalTo: imageViewDetails.leadingAnchor, constant: 1).isActive = true
        imageViewAdUrgent.topAnchor.constraint(equalTo: imageViewDetails.topAnchor, constant: 1).isActive = true
        imageViewAdUrgent.heightAnchor.constraint(equalToConstant: 75).isActive = true
        imageViewAdUrgent.widthAnchor.constraint(equalTo: imageViewAdUrgent.heightAnchor).isActive = true
    }
}
