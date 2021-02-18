//
//  MainPresenter.swift
//  ok24
//
//  Created by Igor Selivestrov on 19.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import Foundation
import UIKit

protocol PurchaseCommentViewProtocol: class {
    func success(search: String?)
    func failure(error: Error)
    
    
}
protocol PurchaseCommentViewPresenterProtocol {
    init(view: PurchaseCommentViewProtocol, networkService: NetworkService, purchase: Purchase?, navigation: StartCatalog, catalogBuilder: CatalogBuilder)
    func getGoodsComments(search: String?)
    var purchase: Purchase? { get set }
    var goods: [PurchaseGoodsforComments]? { get set }
    var navigation: StartCatalog? { get set }
    var listpage:Int? { get set }
    var listEnd: Bool? { get set }
    var loadData: Bool? { get set }
    var search : String? { get set }
    //var catalogBuilder: CatalogBuilder? { get set }
}

class PurchaseCommentPresenter : PurchaseCommentViewPresenterProtocol {
    var search: String?
    var goods: [PurchaseGoodsforComments]?
    var listEnd: Bool?
    var listpage: Int? = 0
    var purchase: Purchase?
    var catalogBuilder: CatalogBuilder?
    var loadData: Bool?
    var navigation: StartCatalog?
    
    func getGoodsComments(search: String?) {
        
        if search != nil && search?.description != self.search {
            listpage = 1
            self.search = search
            
        }else{
            listpage = (listpage ?? 0) + 1
        }
        
        loadData = true
        if search != nil {
            networkService.params = ["purchase_id": Int(purchase!.purchase_id), "page":  listpage! as Int, "search" : search! as String] as [String : Any]
        }else{
            networkService.params = ["purchase_id": Int(purchase!.purchase_id), "page":  listpage! as Int] as [String : Any]
        }
        
        
        
        networkService.getGoodsComments { [weak self] result in
            
            guard let self = self else { return }
            print("start presenter")
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
                        self.view?.success(search: self.search)
                    case .failure(let error):
                        self.view?.failure(error: error)
                    
                }
            }
            
            
        }
    }
    
    
    weak var view: PurchaseCommentViewProtocol?
    var networkService: NetworkServiceProtocol!
    
    required init(view: PurchaseCommentViewProtocol, networkService: NetworkService, purchase: Purchase?, navigation: StartCatalog, catalogBuilder: CatalogBuilder) {
        self.view = view
        self.purchase = purchase
        
        self.networkService = networkService
        self.networkService.controller = self.view as? UIViewController
        self.navigation = navigation
        self.catalogBuilder = catalogBuilder
        getGoodsComments(search: nil)
        navigation.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "Комментарии к лотам", style: .plain, target: nil, action: nil)
    }
}
