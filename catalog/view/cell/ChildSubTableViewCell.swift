//
//  ChildSubTableViewCell.swift
//  ok24
//
//  Created by Igor Selivestrov on 28.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit
import Nuke

class ChildSubTableViewCell: UITableViewCell {

    @IBOutlet weak var viewSub: UIView!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleTV: UILabel!
    @IBOutlet weak var rankTV: UILabel!
    @IBOutlet weak var statusTV: UILabel!
    @IBOutlet weak var orgTV: UILabel!
    @IBOutlet weak var statusTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var starImage: UIImageView!
    var purchase: Purchase?
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        starImage.image = starImage.image?.maskWithColor(color: RaitingColor.colorFive)
        viewSub.layer.cornerRadius = 10;
        viewSub.layer.masksToBounds = true;
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func cellSetData (purchase: Purchase, indexPath: Int?) {
        //print(indexPath)
        self.purchase = purchase
        let color = [UIColor.blue, UIColor.orange, UIColor.magenta, UIColor.purple, UIColor.red]
        let randomIndex = arc4random() % UInt32(color.count)
        let color_el = color[Int(randomIndex)]
        let paragraphStyle = NSMutableParagraphStyle()
        //line height size
        paragraphStyle.lineSpacing = 3
        let attrString = NSMutableAttributedString(string: purchase.purchase_name)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: color_el, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        titleTV.attributedText = attrString
        titleTV.textAlignment = NSTextAlignment.left
        
        self.titleTV.layoutIfNeeded()
        self.statusTV.text = purchase.state_text != nil ? "\(purchase.state_text!)" : ""
        self.orgTV.text = "\(purchase.user.username)"
        
        if purchase.brand != nil && purchase.brand!.asset != nil {
            self.rankTV.text = purchase.brand!.asset
            
            starImage.isHidden = false
        } else {
            self.rankTV.text = ""
            
            starImage.isHidden = true
        }
        
        if let url = URL(string: AppHelper.correctURLProtocol(path: purchase.purchase_img!)) {
            self.imageV.layer.cornerRadius = 20
            self.imageV.layer.masksToBounds = true
            self.imageV.clipsToBounds = true
            Nuke.loadImage(with: url, into: self.imageV)
        }
    }

}
