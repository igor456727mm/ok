//
//  MainPresenter.swift
//  ok24
//
//  Created by Igor Selivestrov on 19.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import Foundation
import UIKit

protocol MainViewProtocol: class {
    func success()
    func failure(error: Error)
}
protocol MainViewPresenterProtocol {
    init(view: MainViewProtocol, networkService: NetworkService, navigation: StartCatalog, catalogBuilder: CatalogBuilder)
    func getCategory()
    var category: [GroupCategory]? { get set }
    var navigation: StartCatalog? { get set }
    func tabOnTheCategory(category: GroupCategory?)
    //var catalogBuilder: CatalogBuilder? { get set }
}

class MainPresenter : MainViewPresenterProtocol {
    
    var catalogBuilder: CatalogBuilder?
     
    func tabOnTheCategory(category: GroupCategory?) {
        
        if let navigationController = navigation {
            
            guard let detailViewController = catalogBuilder?.createDetailModule(category: category, navigation: navigationController) else {
                return
            }
            navigationController.pushViewController(detailViewController, animated: true)
            
            
        }
        
    }
    var navigation: StartCatalog?
    
    func getCategory() {
        
        networkService.getCategory { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let category ):
                        self.category = category
                        self.view?.success()
                        
                    case .failure(let error):
                        self.view?.failure(error: error)
                    
                }
            }
            
            
        }
    }
    
    var category: [GroupCategory]?
    
    weak var view: MainViewProtocol?
    var networkService: NetworkServiceProtocol!
    
    required init(view: MainViewProtocol, networkService: NetworkService, navigation: StartCatalog, catalogBuilder: CatalogBuilder) {
        self.view = view
        self.networkService = networkService
        self.networkService.controller = self.view as? UIViewController
        self.navigation = navigation
        self.catalogBuilder = catalogBuilder
        getCategory()
        
    }
}
