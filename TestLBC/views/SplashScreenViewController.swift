//
//  SplashScreenViewController.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 09/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import UIKit
import CoreLocation

@objcMembers
class SplashScreenViewController: UIViewController {
    
    // MARK: var
    var activityIndicator: UIActivityIndicatorView?
    var _labelAppName: UILabel?
    var labelAppName: UILabel {
        if _labelAppName == nil {
            _labelAppName = createDisplayAppName()
        }
        return _labelAppName!
    }
    var _labelFailure: UILabel?
    var labelFailure: UILabel {
        if _labelFailure == nil {
            let label = UILabel()
            label.text = "Impossible de récupérer les annonces, merci de réessayer plus tard."
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            _labelFailure = label
        }
        return _labelFailure!
    }
    var _buttonRetry: UIButton?
    var buttonRetry: UIButton {
        if _buttonRetry == nil {
            let button = UIButton(type: .system)
            button.setTitle("Réessayer", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.showsTouchWhenHighlighted = true
            button.layer.cornerRadius = 15
            button.layer.borderColor = UIColor.blue.cgColor
            button.layer.borderWidth = 2
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.addTarget(self, action: #selector(retryTouched(sender:)), for: .touchUpInside)
            
            _buttonRetry = button
        }
        return _buttonRetry!
    }
    
    // MARK: VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationItem.setHidesBackButton(true, animated: false)
        
        view.addSubview(labelAppName)
        createLoading()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        loadDatas()
    }
    
    // MARK: objc members
    func retryTouched(sender: UIButtonFilter) {
        labelFailure.removeFromSuperview()
        buttonRetry.removeFromSuperview()
        activityIndicator?.startAnimating()
        
        loadDatas()
    }
    
    // MARK: private func
    private func loadDatas() {
        ApiService.shared.getCategories { [weak self] responseCategories in
            switch responseCategories {
            case .success(let categories):
                DataManager.shared.saveCategories(categories: categories, takeCareOfOldCategories: false)
                ApiService.shared.getAds { [weak self] responseAds in
                    switch responseAds {
                    case .success(let ads):
                        DataManager.shared.saveAds(ads: ads, takeCareOfOldAds: false)
                        DispatchQueue.main.async {
                            self?.activityIndicator?.stopAnimating()
                            self?.displayHomeViewController()
                        }
                        
                    case .failure:
                        DispatchQueue.main.async {
                            self?.activityIndicator?.stopAnimating()
                            self?.addFailureView()
                        }
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.activityIndicator?.stopAnimating()
                    self?.addFailureView()
                }
            }
        }
    }
    
    private func addFailureView() {
        
        view.addSubview(labelFailure)
        labelFailure.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelFailure.topAnchor.constraint(equalTo: labelAppName.bottomAnchor, constant: 15).isActive = true
        labelFailure.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        labelFailure.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
        view.addSubview(buttonRetry)
        
        buttonRetry.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonRetry.topAnchor.constraint(equalTo: labelFailure.bottomAnchor, constant: 15).isActive = true
        buttonRetry.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        buttonRetry.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
    
    private func displayHomeViewController() {
        
        let homeViewModel = HomeViewModel(ads: DataManager.shared.getSavedAds())
        let homeViewController = HomeViewController(homeViewModel: homeViewModel)
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    private func createDisplayAppName() -> UILabel {
        let labelAppName = UILabel()
        labelAppName.numberOfLines = 0

        labelAppName.text = """
        Test
            LBC
        """
        labelAppName.font = UIFont.boldSystemFont(ofSize: 25)
        labelAppName.shadowColor = UIColor.lightGray
        labelAppName.shadowOffset = CGSize(width: 2, height: 2)
        
        let maximumLabelSize = CGSize(width: view.frame.width, height: view.frame.height)
        let expectedLabelSize: CGSize = labelAppName.sizeThatFits(maximumLabelSize)
        var newFrame = labelAppName.frame
        newFrame.size.height = expectedLabelSize.height
        newFrame.size.width = expectedLabelSize.width
        labelAppName.frame = newFrame
        
        labelAppName.center.x = view.center.x
        labelAppName.center.y = view.center.y - 50
        
        return labelAppName
    }
    
    private func createLoading() {
        
        let createdActivityIndicator = UIActivityIndicatorView()
        createdActivityIndicator.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        
        createdActivityIndicator.center.x = view.center.x
        createdActivityIndicator.center.y = view.center.y + 50
        createdActivityIndicator.style = .large
        createdActivityIndicator.startAnimating()
        
        view.addSubview(createdActivityIndicator)
        
        self.activityIndicator = createdActivityIndicator
        
    }
    
}
