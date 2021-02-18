//
//  DetailPresenter.swift
//  pattern
//
//  Created by Igor Selivestrov on 23.06.2020.
//  Copyright © 2020 Igor Selivestrov. All rights reserved.
//

import Foundation
import UIKit

protocol ChildSubViewProtocol: class {
    func success()
    func failure(error: Error)
    func selected()
}

protocol ChildSubPresenterProtocol: class {
    init(view: ChildSubViewProtocol, networkService: NetworkServiceProtocol, category: SubCategory?, navigation: StartCatalog, catalogBuilder: CatalogBuilder)
    func tab()
    var navigation: StartCatalog? { get set }
    var category: SubCategory? { get set }
    var loadData: Bool? { get set }
    var listEnd: Bool? { get set }
    var listpage:Int? { get set }
    func tabOnTheCategory(purchase: Purchase?)
    func getPurchases()
    var purchases: [Purchase]? { get set }
}

class ChildSubPresenter: ChildSubPresenterProtocol {
    var listEnd: Bool?
    
    var loadData: Bool?
    
    var listpage: Int? = 0
    
    var category: SubCategory?
    
    var purchases: [Purchase]?
    
    
    
    func getPurchases() {
        listpage = (listpage ?? 0) + 1
        loadData = true
        //networkService.controller = self.view as! UIViewController
        
        networkService.params = ["PurchasesSearch[finder_category]": Int(category!.productcat_id), "page": Int(listpage!)] as [String : Any]
        networkService.getPurchases { [weak self] result in
            
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let purchases , let listPage, let listEnd ):
                        
                        self.listEnd = self.listpage == listEnd
                        
                        self.loadData = false
                        if listEnd == 0 {
                            self.listEnd = true
                        }
                        if self.listpage == 1 {
                            self.purchases = purchases
                        } else {
                            self.purchases?.append(contentsOf: purchases ?? [])
                        }
                        self.view?.success()
                    case .failure(let error):
                        self.loadData = false
                        self.view?.failure(error: error)
                }
            }
            
            
        }
    }
    
    func tab() {
        print("//router?.popToRoot()")
    }
    var catalogBuilder: CatalogBuilder?
    func tabOnTheCategory(purchase: Purchase?) {
        
        if let navigationController = navigation {
            
            guard let detailViewController = catalogBuilder?.createPurcheseModule(purchase: purchase, navigation: navigationController) else {
                return
            }
            
            navigationController.pushViewController(detailViewController, animated: true)
            
            self.view?.selected()
        }
    }
    weak var view: ChildSubViewProtocol?
    var networkService: NetworkServiceProtocol!
    var navigation: StartCatalog?
    
    required init(view: ChildSubViewProtocol, networkService: NetworkServiceProtocol, category: SubCategory?, navigation: StartCatalog,  catalogBuilder: CatalogBuilder) {
        self.view = view
        self.networkService = networkService
        self.networkService.controller = self.view as? UIViewController
        self.catalogBuilder = catalogBuilder
        self.category = category
        self.getPurchases()
        self.navigation = navigation
        navigation.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: category?.productcat_label, style: .plain, target: nil, action: nil)
    }
    
    
}
