//
//  MainPresenter.swift
//  ok24
//
//  Created by Igor Selivestrov on 19.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import Foundation
import UIKit

protocol GoodViewProtocol: class {
    func success()
    func failure(error: Error)
    
    
}
protocol GoodViewPresenterProtocol {
    init(view: GoodViewProtocol, networkService: NetworkService, catalog: Catalog?, purchase: Purchase?, search: String?, navigation: StartCatalog, catalogBuilder: CatalogBuilder)
    func getGoods(search: String?)
    var catalog: Catalog? { get set }
    var purchase: Purchase? { get set }
    var goods: [Goods]? { get set }
    var navigation: StartCatalog? { get set }
    var listpage:Int? { get set }
    var listEnd: Bool? { get set }
    var loadData: Bool? { get set }
    var search : String? { get set }
    func goTogood(good: Goods?)
}

class GoodPresenter : GoodViewPresenterProtocol {
    
    var purchase: Purchase?
    var goods: [Goods]?
    var listEnd: Bool?
    var listpage: Int? = 0
    var search : String?
    var catalog: Catalog?
    var catalogBuilder: CatalogBuilder?
    var loadData: Bool?
    var navigation: StartCatalog?
    func goTogood(good: Goods?) {
        if let navigationController = navigation {
            
            guard let detailViewController = catalogBuilder?.createGoodDetailModule(good: good, purchase: self.purchase, navigation: navigationController) else {return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    func getGoods(search: String?) {
        
        loadData = true
        if search != nil && search?.description != self.search {
            listpage = 1
            self.search = search
            
        }else{
            listpage = (listpage ?? 0) + 1
        }
        
        loadData = true
        if search != nil {
            if let catalog_id = catalog?.catalog_id {
                networkService.params = ["catalog_id": Int(catalog_id), "page":  listpage! as Int, "search" : search! as String] as [String : Any]
            }else{
                networkService.params = ["purchase_id": Int(purchase!.purchase_id), "page":  listpage! as Int, "search" : search! as String] as [String : Any]
            }
        }else{
            if let catalog_id = catalog?.catalog_id {
                networkService.params = ["catalog_id": Int(catalog_id), "page":  listpage! as Int] as [String : Any]
            }else{
            
                networkService.params = ["purchase_id": Int(purchase!.purchase_id), "page":  listpage! as Int] as [String : Any]
            }
        }
     
        
        
        networkService.getGoods { [weak self] result in
            guard let self = self else { return }
            self.loadData = false
            DispatchQueue.main.async {
                switch result {
                    case .success(let goods , let listPage, let listEnd ):
                        
                        self.listEnd = self.listpage == listEnd
                        
                        self.loadData = false
                        if listEnd == 0 {
                            self.listEnd = true
                        }
                        if self.listpage == 1 {
                            self.goods = goods
                        } else {
                            self.goods?.append(contentsOf: goods ?? [])
                        }
                        self.view?.success()
                    case .failure(let error):
                        self.view?.failure(error: error)
                    
                }
            }
            
            
        }
    }
    
    
    weak var view: GoodViewProtocol?
    var networkService: NetworkServiceProtocol!
    
    required init(view: GoodViewProtocol, networkService: NetworkService, catalog: Catalog?, purchase: Purchase?,search: String?, navigation: StartCatalog, catalogBuilder: CatalogBuilder) {
        self.view = view
        self.catalog = catalog
        self.search = search
        self.purchase = purchase
        self.networkService = networkService
        self.networkService.controller = self.view as? UIViewController
        self.navigation = navigation
        self.catalogBuilder = catalogBuilder
        getGoods(search: nil)
        navigation.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "Комментарии к лотам", style: .plain, target: nil, action: nil)
    }
}
