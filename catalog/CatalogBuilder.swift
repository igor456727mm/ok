//
//  ModuleBuilder.swift
//  code
//
//  Created by Igor Selivestrov on 05.12.2020.
//  Copyright © 2020 Igor Selivestrov. All rights reserved.
//

import Foundation
//
//  File.swift
//  pattern
//
//  Created by Igor Selivestrov on 23.06.2020.
//  Copyright © 2020 Igor Selivestrov. All rights reserved.
//

import Foundation
import UIKit

class CatalogBuilder  {
    
    func createMainModule(navigation: StartCatalog) -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let presenter = MainPresenter(view: view, networkService: networkService, navigation: navigation, catalogBuilder: self)
        view.presenter = presenter
        return view
    }
    
    func createDetailModule(category: GroupCategory?, navigation: StartCatalog) -> UIViewController {
        let view = SubCategoryViewController()
        let networkService = NetworkService()
        let presenter = SubCategoryPresenter(view: view, networkService: networkService, category: category, navigation: navigation, catalogBuilder: self)
        view.presenter = presenter
        return view
    }
    func createChildDetailModule(category: SubCategory?, navigation: StartCatalog) -> UIViewController {
        let view = ChildSubCategoryViewController()
        let networkService = NetworkService()
        let presenter = ChildSubPresenter(view: view, networkService: networkService, category: category, navigation: navigation, catalogBuilder: self)
        view.presenter = presenter
        return view
    }
    
    func createPurcheseModule(purchase: Purchase?, navigation: StartCatalog) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view =  storyboard.instantiateViewController(withIdentifier: "PurchaseViewController") as! PurchaseViewController
        let networkService = NetworkService()
        let presenter = PurchasePresenter(view: view , networkService: networkService, purchase: purchase, navigation: navigation, catalogBuilder: self)
        view.presenter = presenter
        return view
    }
    
    func createPurcheseCatalogModule(purchase: Purchase?, navigation: StartCatalog) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view =  storyboard.instantiateViewController(withIdentifier: "PurchaseCatalogsViewController") as! PurchaseCatalogsViewController
        
        let networkService = NetworkService()
        let presenter = PurchaseCatalogPresenter(view: view, networkService: networkService, purchase: purchase, navigation: navigation, catalogBuilder: self)
        view.presenter = presenter
        return view
    }
    func createPurcheseReviewsModule(purchase: Purchase?, navigation: StartCatalog) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view =  storyboard.instantiateViewController(withIdentifier: "PurchaseReviewViewController") as! PurchaseReviewViewController
        
        let networkService = NetworkService()
        let presenter = PurchaseReviewPresenter(view: view, networkService: networkService, purchase: purchase, navigation: navigation, catalogBuilder: self)
        view.presenter = presenter
        return view
    }
    
    func createGoodModule(catalog: Catalog?, purchase: Purchase?, search: String?, navigation: StartCatalog) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view =  storyboard.instantiateViewController(withIdentifier: "GoodViewController") as! GoodViewController
        
        let networkService = NetworkService()
        let presenter = GoodPresenter(view: view, networkService: networkService, catalog: catalog, purchase: purchase, search: search,  navigation: navigation, catalogBuilder: self)
        view.presenter = presenter
        return view
    }
    func createPurcheseCommentsModule(purchase: Purchase?, navigation: StartCatalog) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view =  storyboard.instantiateViewController(withIdentifier: "PurchaseCommentsViewController") as! PurchaseCommentsViewController
        
        let networkService = NetworkService()
        let presenter = PurchaseCommentPresenter(view: view, networkService: networkService, purchase: purchase, navigation: navigation, catalogBuilder: self)
        view.presenter = presenter
        return view
    }
    
    func createGoodDetailModule(good: Goods?, purchase: Purchase?, navigation: StartCatalog) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view =  storyboard.instantiateViewController(withIdentifier: "GoodDetailViewControllers") as! GoodDetailViewController
        
        let networkService = NetworkService()
        let presenter = GoodDetailPresenter(view: view, networkService: networkService, good: good, purchase: purchase, navigation: navigation, catalogBuilder: self)
        view.presenter = presenter
        return view
    }
}
