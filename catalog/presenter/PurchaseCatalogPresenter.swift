//
//  MainPresenter.swift
//  ok24
//
//  Created by Igor Selivestrov on 19.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import Foundation
import UIKit

protocol PurchaseCatalogViewProtocol: class {
    func success()
    func failure(error: Error)
    
    
}
protocol PurchaseCatalogViewPresenterProtocol {
    init(view: PurchaseCatalogViewProtocol, networkService: NetworkService, purchase: Purchase?, navigation: StartCatalog, catalogBuilder: CatalogBuilder)
    func getCatalogs()
    var purchase: Purchase? { get set }
    var catalogs: [Catalog]? { get set }
    var navigation: StartCatalog? { get set }
    var listpage:Int? { get set }
    var listEnd: Bool? { get set }
    var loadData: Bool? { get set }
    func goTogoods(catalog: Catalog?, search: String?)
    //var catalogBuilder: CatalogBuilder? { get set }
}

class PurchaseCatalogPresenter : PurchaseCatalogViewPresenterProtocol {
    
    var catalogs: [Catalog]?
    var listEnd: Bool?
    var listpage: Int? = 0
    
    var purchase: Purchase?
    var catalogBuilder: CatalogBuilder?
    var loadData: Bool?
    var navigation: StartCatalog?
    func goTogoods(catalog: Catalog?, search: String?) {
        if let navigationController = navigation {
            
            guard let detailViewController = catalogBuilder?.createGoodModule(catalog: catalog, purchase: purchase, search: search,  navigation: navigationController) else {
                return
            }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    func getCatalogs() {
        listpage = (listpage ?? 0) + 1
        loadData = true
        
     
        
        networkService.params = ["purchase_id": Int(purchase!.purchase_id), "page":  listpage] as [String : Any]
        networkService.getCatalogs { [weak self] result in
            guard let self = self else { return }
            self.loadData = false
            DispatchQueue.main.async {
                switch result {
                    case .success(let catalogs , let listPage, let listEnd ):
                        
                        self.listEnd = self.listpage == listEnd
                        
                        self.loadData = false
                        if listEnd == 0 {
                            self.listEnd = true
                        }
                        if self.listpage == 1 {
                            self.catalogs = catalogs
                        } else {
                            self.catalogs?.append(contentsOf: catalogs ?? [])
                        }
                        self.view?.success()
                        
                      
                        
                    case .failure(let error):
                        self.view?.failure(error: error)
                    
                }
            }
            
            
        }
    }
    
    
    weak var view: PurchaseCatalogViewProtocol?
    var networkService: NetworkServiceProtocol!
    
    required init(view: PurchaseCatalogViewProtocol, networkService: NetworkService, purchase: Purchase?, navigation: StartCatalog, catalogBuilder: CatalogBuilder) {
        self.view = view
        self.purchase = purchase
        
        self.networkService = networkService
        self.networkService.controller = self.view as? UIViewController
        self.navigation = navigation
        self.catalogBuilder = catalogBuilder
        getCatalogs()
        navigation.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "Каталоги", style: .plain, target: nil, action: nil)
    }
}
