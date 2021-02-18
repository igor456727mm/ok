//
//  MainPresenter.swift
//  ok24
//
//  Created by Igor Selivestrov on 19.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import Foundation
import UIKit

protocol PurchaseReviewViewProtocol: class {
    func success()
    func failure(error: Error)
    func setCountReviews(count: Dictionary<String,Any>)
    
}
protocol PurchaseReviewViewPresenterProtocol {
    init(view: PurchaseReviewViewProtocol, networkService: NetworkService, purchase: Purchase?, navigation: StartCatalog, catalogBuilder: CatalogBuilder)
    func getReviews(asset: Int?)
    var countReviews : [Dictionary<String, Int>]? { get set }
    var purchase: Purchase? { get set }
    var reviews: [PurchaseReviews]? { get set }
    var navigation: StartCatalog? { get set }
   
    
}

class PurchaseReviewPresenter : PurchaseReviewViewPresenterProtocol {
    
    var reviews: [PurchaseReviews]?
    var countReviews: [Dictionary<String, Int>]?
    
    var purchase: Purchase?
    var catalogBuilder: CatalogBuilder?
    var navigation: StartCatalog?
    func getReviewsCount() {
        networkService.params = ["purchase_id": Int(purchase!.purchase_id)] as [String : Any]
        networkService.getAssetsCount { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let count  ):
                        self.view?.setCountReviews(count: count)  
                    case .failure(let error):
                        self.view?.failure(error: error)
                    
                }
            }
        }
    }
    func getReviews(asset: Int?) {
        networkService.params = ["purchase_id": Int(purchase!.purchase_id)] as [String : Any]
        if asset != nil {
            networkService.params = ["purchase_id": Int(purchase!.purchase_id), "asset" : asset as Any] as [String : Any]
        }
        networkService.getReviews { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let reviews  ):
                        
                        self.reviews = reviews 
                       
                        self.view?.success()
                        
                      
                        
                    case .failure(let error):
                        self.view?.failure(error: error)
                    
                }
            }
        }
    }
    
    
    weak var view: PurchaseReviewViewProtocol?
    var networkService: NetworkServiceProtocol!
    
    required init(view: PurchaseReviewViewProtocol, networkService: NetworkService, purchase: Purchase?, navigation: StartCatalog, catalogBuilder: CatalogBuilder) {
        self.view = view
        self.purchase = purchase
        
        self.networkService = networkService
        self.networkService.controller = self.view as? UIViewController
        self.navigation = navigation
        self.catalogBuilder = catalogBuilder
        getReviews(asset: nil)
        getReviewsCount()
        navigation.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "Отзывы участников о закупке", style: .plain, target: nil, action: nil)
    }
}
