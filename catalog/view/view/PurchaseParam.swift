//
//  PurchaseParam.swift
//  ok24
//
//  Created by Igor Selivestrov on 06.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit

class PurchaseParam: UITableViewCell { 

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var value: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        label.textColor = ButtonPrimary.backgroundColornotActive.dark
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
