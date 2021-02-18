//
//  PurchaseCommentsViewController.swift
//  ok24
//
//  Created by Igor Selivestrov on 14.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit



class GoodViewController: UIViewController {
    
    var leftSpacing = 20
    var presenter: GoodViewPresenterProtocol!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var filterUIView: UIView!
    @IBOutlet weak var sortUIView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var headerHeight = 146
    var sizeHeightCell = 417
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GoodCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "GoodCollectionViewCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "FilterLots", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FilterLots")
       
        
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        if distanceFromBottom < height && !(presenter.loadData ?? false) && !(presenter.listEnd ?? false) && presenter.goods?.count ?? 0 > 0 {
            
            presenter.getGoods(search: presenter.search)
            
        }
    }
    
}
extension GoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.goods?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoodCollectionViewCell", for: indexPath) as! GoodCollectionViewCell
       
       let good = presenter.goods?[indexPath.row]
        cell.Good = good
       return cell
   }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let good = presenter.goods?[indexPath.row]
        presenter.goTogood(good: good)
    }
    func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        return CGSize(width: collectionView.bounds.size.width/2 - 5, height: CGFloat(sizeHeightCell))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"FilterLots", for: indexPath) as! FilterLots
            reusableview.frame = CGRect(x: 0 , y: leftSpacing, width: Int(self.view.frame.width), height: headerHeight)
             //do other header related calls or settups
                return reusableview


        default:  break;
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 146)
    }
}

extension GoodViewController: GoodViewProtocol {
    func success() {
        if (presenter.goods?.count == 0) {
            collectionView.setEmptyMessage("Лоты не найдены")
        } else {
            collectionView.restore()
        }
         collectionView.reloadData()
        
        self.loadViewIfNeeded()
    }
    
    func failure(error: Error) {
        self.showAlert(message: error.localizedDescription)
    }
    
    
}

extension GoodViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        presenter.getGoods(search: textField.text)
       
        
       return true
    }
}
