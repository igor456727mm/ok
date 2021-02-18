//
//  CollectionLayout.swift
//  ok24
//
//  Created by Igor Selivestrov on 16.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit

class CollectionLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    override class func awakeFromNib() {
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
}
