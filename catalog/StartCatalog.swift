//
//  StartCatalog.swift
//  ok24
//
//  Created by Igor Selivestrov on 19.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import Foundation
import UIKit

class StartCatalog: UINavigationController {
    override init(rootViewController : UIViewController) {
            
            super.init(rootViewController : rootViewController)
        }

        override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
            super.init(navigationBarClass : navigationBarClass, toolbarClass : toolbarClass)
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
            
            
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogInit = CatalogBuilder().createMainModule(navigation: self)
        
        self.viewControllers = [catalogInit]
    }
}
