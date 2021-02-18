//
//  GoodCollectionViewCell.swift
//  ok24
//
//  Created by Igor Selivestrov on 15.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit
import Alamofire

class GoodCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIView!
    
    @IBOutlet weak var imageGood: UIImageView!
    @IBOutlet weak var countComment: UIButton!
    @IBOutlet weak var countOrder: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var stop: UILabel!
    @IBOutlet weak var addToCard: UIButton!
    @IBOutlet weak var addLike: UIButton!
    var Good: Goods? {
        didSet {
            name.text = Good?.lot_name
            name.font = UIFont.boldSystemFont(ofSize: 14)
            name.textColor = .black
            countComment.setTitle("\(Good?.comments_count ?? 0)", for: .normal)
            countComment.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            countComment.setTitleColor(ButtonPrimary.backgroundColornotActive.dark, for: .normal)
            countOrder.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            countOrder.setTitleColor(ButtonPrimary.backgroundColornotActive.dark, for: .normal)
            countOrder.setTitle("\(Good?.orders_count ?? 0)", for: .normal)
            price.text = Good?.lot_cost_format
            price.textColor = GoodColor.price
            //255 0 148
            price.font = UIFont.boldSystemFont(ofSize: 14)
            discount.attributedText = String((Good?.lot_cost_format)!).strikeThrough()
            discount.font = UIFont.systemFont(ofSize: 12)
            discount.textColor = ButtonPrimary.backgroundColornotActive.dark
            imageView.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
            imageView.layer.cornerRadius = 10;
            imageView.layer.masksToBounds = true;
            stop.text = Good?.lot_shipping_wait_format
            stop.font = UIFont.systemFont(ofSize: 14)
            stop.textColor = ButtonPrimary.backgroundColornotActive.dark
            let imageCache = NSCache<AnyObject, AnyObject>()
            self.imageGood.image = nil
            if let imageFromCache = imageCache.object(forKey: (Good?.main_thumb_img as AnyObject)) {
              
                self.imageGood.image = imageFromCache as? UIImage
            }else {
                guard let urlString = Good?.main_thumb_img as String? else { return  }
                guard let url = URL(string: urlString) else { return }
                
                Alamofire.request(url).responseData { [ Good, self] response in
                    if response.response?.statusCode != 404 {
                        if let image = response.result.value {
                            imageCache.setObject(UIImage(data: image)!, forKey: (Good?.main_thumb_img as AnyObject))
                            DispatchQueue.main.async {
                                self.imageGood.image = UIImage(data: image)
                                
                            }
                        }
                    }
                }
            }
            
            self.imageGood.layer.cornerRadius = 10
            self.imageGood.layer.masksToBounds = true
            self.imageGood.clipsToBounds = true
            
            addLike.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
            addLike.imageView?.image = UIImage(named: "Like")
            //addLike.setTitle(Good?.likes_count, for: .normal)
            addLike.titleLabel?.text = "\(Good?.likes_count)"
            self.layoutIfNeeded()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}
