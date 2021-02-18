//
//  ReviewTableViewCell.swift
//  ok24
//
//  Created by Igor Selivestrov on 11.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var raitingdate: UILabel!
    @IBOutlet weak var raitingLabel: UILabel!
    @IBOutlet weak var raitingImage: UIImageView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var textView: UIView!
    var review : PurchaseReviews? {
        didSet {
            textView.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
            textView.layer.cornerRadius = 10
            textView.layer.masksToBounds = true
            labelText.numberOfLines = 0
            labelText.text = review?.message
            raitingdate.textColor = ButtonPrimary.backgroundColornotActive.dark
            self.raitingdate?.text = review?.asset_datetime
            
            raitingImage.image = raitingImage.image?.maskWithColor(color: RaitingColor.colorFive)
            self.raitingLabel.text = NSString(format: "%.1f", review?.asset_brand! as! CVarArg) as String
            self.raitingLabel.raitingColor(floatValue: (review?.asset_brand)!)
            /*let padding = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
            self.labelText?.contentEdgeInsets = padding
            self.labelText?.sizeToFit()
            self.labelText?.setTitle(review?.message, for: .normal)
            self.labelText?.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
            self.labelText?.tintColor = ButtonPrimary.backgroundColornotActive.dark
            labelText?.titleLabel?.numberOfLines = 0
            labelText?.titleLabel?.lineBreakMode = .byWordWrapping
            self.labelText?.layer.cornerRadius = 10
            self.labelText?.layer.masksToBounds = true
            */
            self.labelText.layoutIfNeeded()
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
