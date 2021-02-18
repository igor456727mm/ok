//
//  HeaderCollectionReusableView.swift
//  ok24
//
//  Created by Igor Selivestrov on 07.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    var label: UILabel = {
             let label: UILabel = UILabel()
             label.textColor = .black
             label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
             label.sizeToFit()
             return label
         }()

         override init(frame: CGRect) {
             super.init(frame: frame)

             addSubview(label)

             label.translatesAutoresizingMaskIntoConstraints = false
             label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
             label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
             label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
