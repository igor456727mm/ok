//
//  DetailPresenter.swift
//  pattern
//
//  Created by Igor Selivestrov on 23.06.2020.
//  Copyright © 2020 Igor Selivestrov. All rights reserved.
//

import Foundation
import UIKit

protocol SubCategoryViewProtocol: class {
    func setSubCategory(category: GroupCategory?)
    
}

protocol SubCategoryPresenterProtocol: class {
    init(view: SubCategoryViewProtocol, networkService: NetworkServiceProtocol, category: GroupCategory?, navigation: StartCatalog, catalogBuilder: CatalogBuilder)
    func setSubCategory()
    func tab()
    var category: GroupCategory? { get set }
    var navigation: StartCatalog? { get set }
    func tabOnTheCategory(category: GroupCategory?, index: Int!)
    
}

class SubCategoryPresenter: SubCategoryPresenterProtocol {
    
    var navigation: StartCatalog?
    var catalogBuilder: CatalogBuilder?
    func tabOnTheCategory(category: GroupCategory?, index: Int!) {
        
        if let navigationController = navigation {
            
            guard let detailViewController = catalogBuilder?.createChildDetailModule(category: category?.category[index], navigation: navigationController) else {
                return
            }
            
            navigationController.pushViewController(detailViewController, animated: true)
            
            
        }
    }
    
    func tab() {
        print("//router?.popToRoot()")
    }
    
    var category: GroupCategory?
    weak var view: SubCategoryViewProtocol?
    let networkService: NetworkServiceProtocol!
    
    required init(view: SubCategoryViewProtocol, networkService: NetworkServiceProtocol, category: GroupCategory?, navigation: StartCatalog, catalogBuilder: CatalogBuilder) {
        self.view = view
        self.networkService = networkService
        self.category = category
        self.catalogBuilder = catalogBuilder
        self.navigation = navigation
        navigation.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: category?.productcat_maingroup_name, style: .plain, target: nil, action: nil)
    }
    
    func setSubCategory() {
        self.view?.setSubCategory(category: category)
    }
    
    
}
