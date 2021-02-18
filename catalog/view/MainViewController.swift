//
//  MainViewController.swift
//  ok24
//
//  Created by Igor Selivestrov on 24.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var Category: [GroupCategory]? = []
    var presenter : MainViewPresenterProtocol!
    var colView: UICollectionView!
    let searchBar:UISearchBar = UISearchBar()
        lazy var collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            
            
            let cv = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
            cv.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
            cv.backgroundColor = .white
            cv.delegate = self
            cv.dataSource = self
            cv.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCatalogCategory")
            cv.showsVerticalScrollIndicator = false
            return cv
        }()

        override func viewDidLoad() {
            super.viewDidLoad()
            view.addSubview(collectionView)
            
            
            setBarColors()
            
            AppHelper.getSearchNavBar(actionsTarget: self, searchBar: searchBar, searchPlaceholder: "Поиск на 24-ok.ru", searchAction: #selector(searchBarSearchButtonClicked), bellAction: #selector(self.showNotifys), navBarItem: self.navigationItem, needBell: true)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
            tapGesture.cancelsTouchesInView = false
            self.view.addGestureRecognizer(tapGesture)
        }
    @objc func searchBarSearchButtonClicked(_ searchBar: Any) {
        self.searchBar.resignFirstResponder()
        if self.searchBar.text == nil || self.searchBar.text == "" {
            debugPrint("Empty search string")
        } else {
            debugPrint(self.searchBar.text!)
            hideKeyboard()
            
            performSegue(withIdentifier: "showSearch", sender: self)
        }
    }
    @IBAction func showNotifys () {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let notifyTVC = storyBoard.instantiateViewController(withIdentifier: "notifyTVC") as! NotifyTVC
        self.navigationController?.pushViewController(notifyTVC, animated: true)
    }
    @objc func hideKeyboard() {
        searchBar.endEditing(true)
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCatalogCategory", for: indexPath) as! MainCollectionViewCell
        
        let category = presenter.category?[indexPath.row]
        
        cell.category = category
        return cell
    }
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.category?.count ?? 0
    }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCategory", for: indexPath) as! MainCollectionViewCell
        let category = presenter.category?[indexPath.row]
        
        presenter.tabOnTheCategory(category: category)
    }
    func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
                let kWhateverHeightYouWant = 136
                return CGSize(width: collectionView.bounds.size.width/2 - 20, height: CGFloat(kWhateverHeightYouWant))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 25, left: 15, bottom: 0, right: 15)
        }
}

extension MainViewController: MainViewProtocol {
    func success() {
        
        self.collectionView.reloadData()
      
    }
    
    func failure(error: Error) {
        print(error)
    }
    
    
}
