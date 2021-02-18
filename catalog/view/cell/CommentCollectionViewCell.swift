//
//  CommentCollectionViewCell.swift
//  ok24
//
//  Created by Igor Selivestrov on 14.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit
import Alamofire
class CommentCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var uiview: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var userDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        uiview.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
        uiview.layer.cornerRadius = 10
        uiview.layer.masksToBounds = true
        userDate.textColor = ButtonPrimary.backgroundColornotActive.dark
        userDate.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    public func setDate(date: Int!) {
        userDate.text = NSDate(timeIntervalSince1970: TimeInterval(date)).description
        
    }
    public func setText(text: String!) {
        let data = text.data(using: .unicode)!
        let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .defaultAttributes : [NSAttributedString.Key.font: 20]],
            documentAttributes: nil)
        self.text.attributedText = attributedString
    }
    public func configureDetailGood(with comment: GoodsComment)
    {
        setText(text: comment.comment_text)
        setDate(date: comment.datestamp)
        userName.text = comment.user.username
        setImage(avatarPath: comment.user.avatarPath)
    }
    public func setImage(avatarPath: String)
    {
        let imageCache = NSCache<AnyObject, AnyObject>()
        self.userProfile.image = nil
        self.userProfile.layer.cornerRadius = 10
        self.userProfile.layer.masksToBounds = true
        self.userProfile.clipsToBounds = true
        if let imageFromCache = imageCache.object(forKey: (avatarPath as AnyObject)) {
          
            self.userProfile.image = imageFromCache as? UIImage
        }else {
            guard let urlString = avatarPath as String? else { return  }
            guard let url = URL(string: urlString) else { return }
            
            Alamofire.request(url).responseData { [weak self] response in
                if response.response?.statusCode != 404 {
                    if let image = response.result.value {
                        imageCache.setObject(UIImage(data: image)!, forKey: (avatarPath as AnyObject))
                        DispatchQueue.main.async {
                            self!.userProfile.image = UIImage(data: image)
                            
                        }
                    }
                }
            }
        }
    }
    public func configure(with comment: PurchaseGoodsComments)
    {
        setText(text: comment.text)
        setDate(date: comment.datestamp)
        userName.text = comment.user?.username
        setImage(avatarPath: (comment.user?.avatarPath)!)
        
    }
}
