//
//  CatalogCCell.swift
//  ok24
//
//  Created by Igor Selivestrov on 08.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit
import Alamofire

class CatalogCCell: UITableViewCell {
    var imageCache:UIImage!
    var button:UIButton!
    
    var catalog:Catalog? {
        didSet {
            
            let imageCache = NSCache<AnyObject, AnyObject>()
        
            if let imageFromCache = imageCache.object(forKey: (catalog?.catalog_image as AnyObject)) {
                
                self.imageCache = imageFromCache as? UIImage
                self.setButtom(width: 72, height: 72, left: 20)
            }else {
                guard let urlString = catalog?.catalog_image as String? else { return  }
                guard let url = URL(string: urlString) else { return }
                
                Alamofire.request(url).responseData { [weak self] response in
                    if response.response?.statusCode != 404 {
                        if let image = response.result.value {
                            imageCache.setObject(UIImage(data: image)!, forKey: (self!.catalog?.catalog_image as AnyObject))
                            DispatchQueue.main.async {
                                self!.imageCache = UIImage(data: image)
                                self!.setButtom(width: 72, height: 72, left: 20)
                            }
                        }
                    }
                }
            }
            let width = CGFloat(self.frame.width  - 140)
            setTitile(title: catalog?.catalog_name, top: 0, left: 120, width: width, height: 72)
            
            
        }
        
    }
    
    
    
    func setTitile(title: String?, top: CGFloat!, left: CGFloat!, width: CGFloat!, height: CGFloat!) {
        let label = UILabel()
        label.text = title ?? "Категория не определена"
        label.sizeToFit()
        
        label.font = label.font.withSize(16)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        let constraints = [
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: left),
            label.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 140),
            label.topAnchor.constraint(equalTo: topAnchor, constant: top),
            label.heightAnchor.constraint(equalToConstant: height),
            label.widthAnchor.constraint(equalToConstant: width),
        ]
        NSLayoutConstraint.activate(constraints)
        
        self.layoutIfNeeded()
        
    }
    func setButtom(width: CGFloat, height: CGFloat, left: CGFloat) {
        //80 12 24
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setImage(self.imageCache, for: .normal)
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        self.button = button
        addSubview(button)
        button.leftAnchor.constraint(equalTo: leftAnchor, constant: left).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
      
    }

}
