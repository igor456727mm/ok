//
//  SubCategoryTableViewCell.swift
//  ok24
//
//  Created by Igor Selivestrov on 27.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit
import Alamofire
class SubCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var imageCategory: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
      
    }

}
