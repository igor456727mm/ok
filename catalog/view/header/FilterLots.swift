//
//  FilterLots.swift
//  ok24
//
//  Created by Igor Selivestrov on 16.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit

class FilterLots: UICollectionReusableView {

    @IBOutlet weak var searchField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchField.backgroundColor = UIColor.white
        searchField.addPadding(padding: .equalSpacing(20))
        if let myImage = UIImage(named: "search"){
            
            searchField.withImage(direction: .Right, image: myImage)
        }
        searchField.placeholder = "Искать лоты в закупке"
        searchField.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
        searchField.borderStyle = .none
        searchField.layer.borderColor = ButtonPrimary.backgroundColornotActive.ok24.cgColor
        searchField.textColor = ButtonPrimary.backgroundColornotActive.dark
        searchField.layer.cornerRadius = 10
        searchField.delegate = self
    }
    
}

extension FilterLots : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       textField.resignFirstResponder()
       // go to search
        print(textField.text)
       return true
    }
}
