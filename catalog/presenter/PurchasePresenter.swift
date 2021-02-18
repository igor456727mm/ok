//
//  MainPresenter.swift
//  ok24
//
//  Created by Igor Selivestrov on 19.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import Foundation
import UIKit

protocol PurchaseViewProtocol: class {
    func success()
    func failure(error: Error)
    func updateParams()
    func subscribeOrg(result: String)
    func shared()
    func subscribeZak(result: String)
    
}
protocol PurchaseViewPresenterProtocol {
    init(view: PurchaseViewProtocol, networkService: NetworkService, purchase: Purchase?, navigation: StartCatalog, catalogBuilder: CatalogBuilder)
    func getCatalogs()
    var purchaseParams: [PurchaseParamEl]? { get set }
    var purchase: Purchase? { get set }
    var catalogs: [Catalog]? { get set }
    var navigation: StartCatalog? { get set }
    var listPage: Int! { get set }
    var listEnd: Bool? { get set }
    var loadData: Bool? { get set }
    func tabOnTheCategory(category: GroupCategory?)
    func subscribeOrg()
    func subscribeZak()
    func shared()
    func goToreadReviews()
    func goTocomments()
    func goTocatalogs()
    func goTogoods(search: String!, catalog: Catalog?)
    //var catalogBuilder: CatalogBuilder? { get set }
}

class PurchasePresenter : PurchaseViewPresenterProtocol {
    func goTogoods(search: String!, catalog: Catalog?) {
        print("got to goodss")
        if let navigationController = navigation {
            
            guard let detailViewController = catalogBuilder?.createGoodModule(catalog: catalog, purchase: purchase, search: search, navigation: navigationController) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
            
        }
    }
    
    func goTocatalogs() {
        if let navigationController = navigation {
            
            guard let detailViewController = catalogBuilder?.createPurcheseCatalogModule(purchase: purchase, navigation: navigationController) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
            
        }
    }
    
    func goTocomments() {
        if let navigationController = navigation {
            
            guard let detailViewController = catalogBuilder?.createPurcheseCommentsModule(purchase: purchase, navigation: navigationController) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
            
        }
    }
    
    func goToreadReviews() {
        if let navigationController = navigation {
            
            guard let detailViewController = catalogBuilder?.createPurcheseReviewsModule(purchase: purchase, navigation: navigationController) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
            
        }
    }
    
    func shared() {
        self.view?.shared()
    }
    
    
    func subscribeZak() {
        networkService.params = ["user_id":  (purchase?.user_id)! as Int] as [String : Int]
        
        networkService.subscribeZak { result in 
            self.view?.subscribeZak(result: result)
        }
    }
    
    func subscribeOrg() {
        networkService.params = ["brand_id": Int(purchase!.brand!.brand_id)] as [String : Int]
        
        networkService.subscribeOrg { result in
            self.view?.subscribeOrg(result: result)
        }
    }
    
    var purchaseParams: [PurchaseParamEl]?
    
    var catalogs: [Catalog]?
    var listEnd: Bool?
    var listPage: Int! = 0
    
    var purchase: Purchase?
    var catalogBuilder: CatalogBuilder?
    var loadData: Bool?
    func tabOnTheCategory(category: GroupCategory?) {
    }
    var navigation: StartCatalog?
    
    func getCatalogs() {
        listPage += 1
        loadData = true
        networkService.params = ["purchase_id": Int(purchase!.purchase_id), "page":  listPage] as [String : Any]
        networkService.getCatalogs { [weak self] result in
            guard let self = self else { return }
            self.loadData = false
            DispatchQueue.main.async {
                switch result {
                    case .success(let catalogs , let listPage, let listEnd ):
                        
                        self.listEnd = self.listPage == listEnd
                        
                        self.loadData = false
                        if listEnd == 0 {
                            self.listEnd = true
                        }
                        if self.listPage == 1 {
                            self.catalogs = catalogs
                        } else {
                            self.catalogs?.append(contentsOf: catalogs ?? [])
                        }
                        self.purchaseParams = []
                        let param = PurchaseParamEl(label: "Минимальная сумма", value: self.purchase?.purchases_rule1)
                        self.purchaseParams?.append(param)
                        let param2 = PurchaseParamEl(label: "Сбор рядами", value: self.purchase?.purchases_rule2)
                        self.purchaseParams?.append(param2)
                        let param3 = PurchaseParamEl(label: "Организационный взнос", value: self.purchase?.purchases_rule3)
                        self.purchaseParams?.append(param3)
                        let param4 = PurchaseParamEl(label: "Транспортные расходы", value: self.purchase?.purchases_rule4)
                        self.purchaseParams?.append(param4)
                        let param5 = PurchaseParamEl(label: "Риски, пересорт и брак ", value: self.purchase?.purchases_rule5)
                        self.purchaseParams?.append(param5)
                        let param6 = PurchaseParamEl(label: "Форма оплаты и штрафы", value: self.purchase?.purchases_rule6)
                        self.purchaseParams?.append(param6)
                        let param7 = PurchaseParamEl(label: "Центры раздачи", value: self.purchase?.purchases_rule7)
                        self.purchaseParams?.append(param7)
                        let param8 = PurchaseParamEl(label: "Другие условия", value: self.purchase?.purchases_rule8)
                        self.purchaseParams?.append(param8)
                        
                        let param9 = PurchaseParamEl(label: "Описание", value: self.purchase?.purchases_rule9)
                        self.purchaseParams?.append(param9)
                        self.view?.success()
                        
                      
                        
                    case .failure(let error):
                        self.view?.failure(error: error)
                    
                }
            }
            
            
        }
    }
    
    
    weak var view: PurchaseViewProtocol?
    var networkService: NetworkServiceProtocol!
    
    required init(view: PurchaseViewProtocol, networkService: NetworkService, purchase: Purchase?, navigation: StartCatalog, catalogBuilder: CatalogBuilder) {
        self.view = view
        self.purchase = purchase
        
        self.networkService = networkService
        self.networkService.controller = self.view as? UIViewController
        self.navigation = navigation
        self.catalogBuilder = catalogBuilder
        getCatalogs()
        navigation.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: purchase?.purchase_name, style: .plain, target: nil, action: nil)
    }
}
