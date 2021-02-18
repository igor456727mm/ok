//
//  MainPresenter.swift
//  ok24
//
//  Created by Igor Selivestrov on 19.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import Foundation
import UIKit

protocol GoodDetailViewProtocol: class {
    func success()
    func failure(error: Error)
    
    
}
protocol GoodDetailViewPresenterProtocol {
    init(view: GoodDetailViewProtocol, networkService: NetworkService, good: Goods?, purchase: Purchase?, navigation: StartCatalog, catalogBuilder: CatalogBuilder)
    func getGood()
    var good: Goods? { get set }
    var purchase: Purchase? { get set}
    var navigation: StartCatalog? { get set }
}

class GoodDetailPresenter : GoodDetailViewPresenterProtocol {
    var purchase: Purchase?
    
   
    var good: Goods?
    var catalogBuilder: CatalogBuilder?
    var navigation: StartCatalog?
    
    func getGood() {
        
        networkService.getGood { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                    case .success(let good ):
                        self.good = good
                        self.view?.success()
                    case .failure(let error):
                        self.view?.failure(error: error)
                    
                }
            }
            
            
        }
    }
    
    
    weak var view: GoodDetailViewProtocol?
    var networkService: NetworkServiceProtocol!
    
    required init(view: GoodDetailViewProtocol, networkService: NetworkService, good: Goods?,purchase: Purchase?, navigation: StartCatalog, catalogBuilder: CatalogBuilder) {
        self.view = view
        self.good = good
        self.purchase = purchase
        self.networkService = networkService
        self.networkService.controller = self.view as? UIViewController
        self.navigation = navigation
        self.catalogBuilder = catalogBuilder
        //getGood()
        navigation.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: good?.lot_name, style: .plain, target: nil, action: nil)
    }
}
