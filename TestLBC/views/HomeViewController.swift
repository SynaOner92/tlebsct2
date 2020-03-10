//
//  ViewController.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 09/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import UIKit

@objcMembers
class HomeViewController: UIViewController {
    
    // MARK: Init
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: var
    var homeViewModel: HomeViewModel
    var selectedIndex: Int?
    
    // MARK: private var (views)
    private var _collectionView: UICollectionView?
    private var collectionView: UICollectionView {
        if _collectionView == nil {
            _collectionView = initCollectionView()
        }
        return _collectionView!
    }
    
    private var _buttonFilter: UIBarButtonItem?
    private var buttonFilter: UIBarButtonItem {
        if _buttonFilter == nil {
            let button = UIBarButtonItem(title: "Filtres",
                                         style: .plain,
                                         target: self,
                                         action: #selector(filterButton(sender:)))
            button.tintColor = .white
            _buttonFilter = button
        }
        return _buttonFilter!
    }
    
    // MARK: objc members
    func filterButton(sender: UIBarButtonItem) {
        
        let filtersVC = FiltersViewController()
        
        filtersVC.oldFilters = homeViewModel.currentFilters
        
        present(filtersVC, animated: true)
    }

    // MARK: VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        removeOtherViewControllers()
        navigationItem.rightBarButtonItem = buttonFilter

        view.backgroundColor = UIColor.white
        title = "Browse ads"
        
        addCollectionView()

    }
    
    // MARK: private func
    private func addCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        homeViewModel.updateHandler = collectionView.reloadData
    }
    private func removeOtherViewControllers() {
        guard let navigationController = navigationController else { return }
        
        if let lastViewController = navigationController.viewControllers.last {
            navigationController.viewControllers = [lastViewController]
        }
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController.navigationBar.isHidden = false
    }
    
    private func initCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.bounds.width/2-15, height: view.bounds.width/2-15)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        
        let collectionViewInit = UICollectionView(frame: CGRect(),
                                                  collectionViewLayout: flowLayout)
        collectionViewInit.translatesAutoresizingMaskIntoConstraints = false
        collectionViewInit.backgroundColor = UIColor.clear
        collectionViewInit.register(AdCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionViewInit.delegate = self
        collectionViewInit.dataSource = self
        
        return collectionViewInit
    }
}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.numberOfAds
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)

        guard let adCell = cell as? AdCell,
            let ads = homeViewModel.currentAds,
            indexPath.row < ads.count
                else { return UICollectionViewCell() }
        
        adCell.setup(adCellViewModel: AdCellViewModel(ad: ads[indexPath.row]))
            
        return adCell
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let ads = homeViewModel.currentAds,
            indexPath.row < ads.count {
            
            let detailedAdViewModel = DetailedAdViewModel(ad: ads[indexPath.row])
            let detailedAdViewController = DetailedAdViewController(detailedAdViewModel: detailedAdViewModel)
            selectedIndex = indexPath.row
            
            navigationController?.pushViewController(detailedAdViewController, animated: true)
        }
    }
    
}
