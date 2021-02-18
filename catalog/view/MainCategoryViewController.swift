//
//  MainViewController.swift
//  ok24
//
//  Created by Igor Selivestrov on 19.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit


class MainCategoryViewController: UICollectionViewController {
    
    
    var Category: [GroupCategory]? = []
    var presenter : MainViewPresenterProtocol!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MainCatalogCategory")
        
    }
     
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCatalogCategory", for: indexPath) as! MainCollectionViewCell
        let category = presenter.category?[indexPath.row]
        cell.category = category
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.category?.count ?? 0
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCategory", for: indexPath) as! MainCollectionViewCell
        let category = presenter.category?[indexPath.row]
        
        presenter.tabOnTheCategory(category: category)
    }
}
extension MainCategoryViewController: MainViewProtocol {
    func success() {
        
        self.collectionView.reloadData()
    }
    
    func failure(error: Error) {
        print(error)
    }
    
    
}
