//
//  GoodsCommentTableViewCell.swift
//  ok24
//
//  Created by Igor Selivestrov on 14.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit
import Alamofire

class GoodsCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var imageThab: UIImageView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var imageBox: UIButton!
    @IBOutlet weak var imageRow: UIButton!
    @IBOutlet weak var imageBasket: UIButton!
    @IBOutlet weak var imageComment: UIButton!
    @IBOutlet weak var commentCount: UIButton!
    @IBOutlet weak var basketCount: UIButton!
    @IBOutlet weak var rowCount: UIButton!
    @IBOutlet weak var boxCount: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var tittle: UILabel!
    
    @IBOutlet weak var collectionViewHeightt: NSLayoutConstraint!
    
    var comments = [PurchaseGoodsComments]()
    var imageCache:UIImage!
    var Lot: PurchaseGoodsforComments? {
        didSet {
            tittle.text = Lot?.lot_name
            tittle.font = UIFont.boldSystemFont(ofSize: 14)
            tittle.textColor = .black
            commentCount.setTitle("\(Lot?.comments_count ?? 0)", for: .normal)
            commentCount.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            commentCount.setTitleColor(ButtonPrimary.backgroundColornotActive.dark, for: .normal)
            basketCount.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            basketCount.setTitleColor(ButtonPrimary.backgroundColornotActive.dark, for: .normal)
            basketCount.setTitle("\(Lot?.orders_count ?? 0)", for: .normal)
            price.text = Lot?.lot_cost_format
            price.textColor = GoodColor.price
            price.font = UIFont.boldSystemFont(ofSize: 14)
            discount.attributedText = String((Lot?.lot_full_cost_format)!).strikeThrough()
            discount.font = UIFont.systemFont(ofSize: 12)
            discount.textColor = ButtonPrimary.backgroundColornotActive.dark
            leftView.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
            leftView.layer.cornerRadius = 10;
            leftView.layer.masksToBounds = true;
            
            let imageCache = NSCache<AnyObject, AnyObject>()
            self.imageThab.image = nil
            if let imageFromCache = imageCache.object(forKey: (Lot?.main_thumb_img as AnyObject)) {
              
                self.imageThab.image = imageFromCache as? UIImage
            }else {
                guard let urlString = Lot?.main_thumb_img as String? else { return  }
                guard let url = URL(string: urlString) else { return }
                
                Alamofire.request(url).responseData { [weak self] response in
                    if response.response?.statusCode != 404 {
                        if let image = response.result.value {
                            imageCache.setObject(UIImage(data: image)!, forKey: (self!.Lot?.main_thumb_img as AnyObject))
                            DispatchQueue.main.async {
                                self!.imageThab.image = UIImage(data: image)
                                
                            }
                        }
                    }
                }
            }
            self.imageThab.layer.cornerRadius = 10
            self.imageThab.layer.masksToBounds = true
            
            
            self.layoutIfNeeded()
        }
    }
    var leftSpacing = 20
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*collectionView.isScrollEnabled = false
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 150, height: 180)
        flowLayout.minimumLineSpacing = 2.0
        flowLayout.minimumInteritemSpacing = 5.0
        collectionView.collectionViewLayout = flowLayout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
         collectionView.showsVerticalScrollIndicator = false
         */
        collectionView.register(UINib(nibName: "CommentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CommentCollectionViewCell")
        collectionView.clipsToBounds = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCellWith(with comments: [PurchaseGoodsComments]) {
            print(self.comments.count)
        
        if !self.comments.elementsEqual(comments, by: { $0.comment_id == $1.comment_id }) {
            
                self.comments = comments
            //DispatchQueue.main.async { [weak self] in
                self.collectionView.reloadData()
                //self.collectionViewHeightt.constant = self.collectionView.contentSize.height
                //self!.collectionView.collectionViewLayout.invalidateLayout()
            //}
            }
            
        }
}

extension GoodsCommentTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCollectionViewCell", for: indexPath) as! CommentCollectionViewCell
        
        let comment = comments[indexPath.row]
        
        cell.configure(with: comment)
        
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 20, height: 150)
    }
   
}
