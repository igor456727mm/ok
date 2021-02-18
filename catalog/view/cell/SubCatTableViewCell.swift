//
//  SubCatTableViewCell.swift
//  ok24
//
//  Created by Igor Selivestrov on 15.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit
import Alamofire

class SubCatTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCat: UIImageView!
    @IBOutlet weak var title: UILabel!
    var category:SubCategory? {
        didSet {
            self.imageCat.layer.cornerRadius = 10
            self.imageCat.layer.masksToBounds = true
            self.imageCat.clipsToBounds = true
            let imageCache = NSCache<AnyObject, AnyObject>()
            if let imageFromCache = imageCache.object(forKey: (category?.productcat_img as AnyObject)) {
              
                self.imageCat!.image = imageFromCache as? UIImage
            }else {
                guard let urlString = category?.productcat_img as String? else { return  }
                guard let url = URL(string: urlString) else { return }
                
                Alamofire.request(url).responseData { [weak self] response in 
                    if response.response?.statusCode != 404 {
                        if let image = response.result.value {
                            imageCache.setObject(UIImage(data: image)!, forKey: (self?.category?.productcat_img as AnyObject))
                            DispatchQueue.main.async {
                                self!.imageCat.image = UIImage(data: image)
                                
                            }
                        }
                    }
                }
            }
            title.text = category?.productcat_label_menu
            title.numberOfLines = 2
            title.font = UIFont.systemFont(ofSize: 16)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
