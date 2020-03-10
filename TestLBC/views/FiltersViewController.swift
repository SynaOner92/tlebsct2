//
//  FiltersViewController.swift
//  TestLBC
//
//  Created by Nicolas Moranny on 09/03/2020.
//  Copyright © 2020 Nicolas Moranny. All rights reserved.
//

import Foundation
import UIKit

@objcMembers
class FiltersViewController: UIViewController {

    // MARK: var
    var oldFilters: [AdCategory]?
    
    // MARK: private var (views)
    private var _stackViewFilters: UIStackView?
    private var stackViewFilters: UIStackView {
        if _stackViewFilters == nil {
            let stackView = UIStackView()
            stackView.frame = CGRect(origin: view.bounds.origin,
                                     size: view.bounds.size)
            stackView.axis = .vertical
            stackView.spacing = 10
            _stackViewFilters = stackView
        }
        return _stackViewFilters!
    }
    
    private var _labelFilter: UILabel?
    private var labelFilter: UILabel {
        if _labelFilter == nil {
            let label = UILabel()
            label.frame = CGRect(origin: view.bounds.origin,
                                 size: view.bounds.size)
            label.text = "- Filtres -"
            label.textAlignment = .center
            _labelFilter = label
        }
        return _labelFilter!
    }
    
    private var _stackViewButtonActiveFilter: UIStackView?
    private var stackViewButtonActiveFilter: UIStackView {
        if _stackViewButtonActiveFilter == nil {
            let uiButton = UIButton(type: .system)
            uiButton.setTitle("Filtrer", for: .normal)
            uiButton.setTitleColor(.blue, for: .normal)
            uiButton.showsTouchWhenHighlighted = true
            uiButton.layer.cornerRadius = 15
            uiButton.layer.borderColor = UIColor.blue.cgColor
            uiButton.layer.borderWidth = 2

            uiButton.addTarget(self, action: #selector(activeFilterTouched(sender:)), for: .touchUpInside)

            let stackViewHorizontal = UIStackView()
            stackViewHorizontal.frame = CGRect(origin: view.bounds.origin,
                                     size: view.bounds.size)
            stackViewHorizontal.axis = .horizontal

            let leftUIView = UIView()
            let rightUIView = UIView()

            stackViewHorizontal.addArrangedSubview(leftUIView)
            
            let stackViewCentral = UIStackView()
            stackViewCentral.frame = CGRect(origin: view.bounds.origin,
                                            size: view.bounds.size)
            stackViewCentral.axis = .vertical
            let topUIView = UIView()
            let bottomUIView = UIView()
            
            stackViewCentral.addArrangedSubview(topUIView)
            stackViewCentral.addArrangedSubview(uiButton)
            stackViewCentral.addArrangedSubview(bottomUIView)
            
            topUIView.heightAnchor.constraint(equalTo: bottomUIView.heightAnchor).isActive = true
            
            stackViewHorizontal.addArrangedSubview(stackViewCentral)
            
            stackViewHorizontal.addArrangedSubview(rightUIView)

            uiButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            leftUIView.widthAnchor.constraint(equalTo: rightUIView.widthAnchor).isActive = true
            leftUIView.heightAnchor.constraint(greaterThanOrEqualTo: uiButton.heightAnchor).isActive = true

            _stackViewButtonActiveFilter = stackViewHorizontal
        }
        return _stackViewButtonActiveFilter!
    }
    
    private var stackViewButtonsFilters = [UIStackView]()
    private var buttonsFilters = [UIButtonFilter]()
    
    // MARK: VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addFilterLabel()
        addStackView()
        
        addButtonsFilters()
        addButtonActivateFilter()

    }
    
    private func addButtonActivateFilter() {
        
        stackViewFilters.addArrangedSubview(stackViewButtonActiveFilter)
    }
    
    private func addFilterLabel() {
        
        view.addSubview(labelFilter)
        
        labelFilter.translatesAutoresizingMaskIntoConstraints = false
        labelFilter.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        labelFilter.heightAnchor.constraint(equalToConstant: 20).isActive = true
        labelFilter.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        labelFilter.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func addButtonsFilters() {
        
        let categories = DataManager.shared.getSavedCategories()
        
        categories?.forEach { categorie in

            let uiButton = UIButtonFilter(type: .system)
            uiButton.setTitle(categorie.name, for: .normal)
            uiButton.setTitleColor(.blue, for: .normal)
            uiButton.showsTouchWhenHighlighted = true
            uiButton.layer.cornerRadius = 15
            uiButton.tag = categorie.id

            uiButton.layer.borderColor = UIColor.blue.cgColor
            uiButton.isFilterSelected = oldFilters?.contains(categorie) ?? false
            uiButton.layer.borderWidth = uiButton.isFilterSelected ? 2 : 0

            uiButton.addTarget(self, action: #selector(filterTouched(sender:)), for: .touchUpInside)
            
            buttonsFilters.append(uiButton)
            stackViewButtonsFilters.append(stackViewFilters)
            
            let stackView = UIStackView()
            stackView.frame = CGRect(origin: view.bounds.origin,
                                     size: view.bounds.size)
            stackView.axis = .horizontal
            
            let leftUIView = UIView()
            let rightUIView = UIView()
            
            stackView.addArrangedSubview(leftUIView)
            stackView.addArrangedSubview(uiButton)
            stackView.addArrangedSubview(rightUIView)

            stackView.setContentHuggingPriority(UILayoutPriority(252),
                                                for: .vertical)
            
            uiButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            leftUIView.widthAnchor.constraint(equalTo: rightUIView.widthAnchor).isActive = true
            
            stackViewFilters.addArrangedSubview(stackView)
        }
    }
    
    private func addStackView() {
        
        view.addSubview(stackViewFilters)
        
        stackViewFilters.translatesAutoresizingMaskIntoConstraints = false
        stackViewFilters.topAnchor.constraint(equalTo: labelFilter.bottomAnchor, constant: 15).isActive = true
        stackViewFilters.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackViewFilters.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stackViewFilters.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        stackViewFilters.backgroundColor = .green
        
    }
    
    // MARK: objc members
    func activeFilterTouched(sender: UIButton) {
        
        if let navigationController = presentingViewController as? UINavigationController,
            let parent = navigationController.viewControllers.first(where: { $0 is HomeViewController }) as? HomeViewController{

            let selectedButtonCategories = buttonsFilters.filter { $0.isFilterSelected }.map { $0.tag }
            
            var selectedCategories = DataManager.shared.getSavedCategories()?.filter { selectedButtonCategories.contains($0.id) }
            
            if selectedCategories?.count == 0 {
                selectedCategories = DataManager.shared.getSavedCategories()
            }
            
            parent.homeViewModel.currentFilters = selectedCategories
            
            dismiss(animated: true)
        }
    }
    
    func filterTouched(sender: UIButtonFilter) {
        
        sender.isFilterSelected = !sender.isFilterSelected
        
        sender.layer.borderWidth = sender.isFilterSelected ? 2 : 0

    }
}
