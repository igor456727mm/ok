//
//  ReviewView.swift
//  ok24
//
//  Created by Igor Selivestrov on 08.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit

class ReviewView: UIView {
    
    @IBOutlet weak var countAll: UILabel!
    @IBOutlet weak var appraisal: UILabel!
    
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    
    @IBOutlet weak var buttom5: UIButton!
    @IBOutlet weak var buttom4: UIButton!
    @IBOutlet weak var buttom3: UIButton!
    @IBOutlet weak var buttom2: UIButton!
    @IBOutlet weak var buttom1: UIButton!
    
    @IBOutlet weak var count5: UILabel!
    @IBOutlet weak var count4: UILabel!
    @IBOutlet weak var count3: UILabel!
    @IBOutlet weak var count2: UILabel!
    @IBOutlet weak var count1: UILabel!
    var  green = RaitingColor.colorFo
    var buttons: [UIButton] = []
    @IBOutlet var contentView: UIView!
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configurateView()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configurateView()
    }
    var presenter : PurchaseReviewViewPresenterProtocol!
    func setCount(count: Dictionary<String,Any>)
    {
       
        count.forEach{
            
            switch ($0.key) {
                case "1" : count1.text = "\($0.value)";  break;
                case "2" : count2.text = "\($0.value)";  break
                case "3" : count3.text = "\($0.value)";  break
                case "4" : count4.text = "\($0.value)";  break
                case "5" : count5.text = "\($0.value)";  break
                default: break;
            }
        }
    }
    private func configurateView()
    {
        Bundle.main.loadNibNamed("ReviewView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    func configurateView(purchase: Purchase?)
    {
        buttonStyle(buttom: buttom5, label: count5)
        buttonStyle(buttom: buttom4, label: count4)
        buttonStyle(buttom: buttom3, label: count3)
        buttonStyle(buttom: buttom2, label: count2)
        buttonStyle(buttom: buttom1, label: count1)
        countAll.text = purchase?.brand?.asset_count
        countAll.textColor = ButtonPrimary.backgroundColornotActive.dark
        // 143 191 0
        self.appraisal.raitingColor(floatValue: ((purchase?.brand?.asset ?? "0.0")! as NSString).floatValue)
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : self.appraisal.textColor] as [NSAttributedString.Key : Any]

        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : ButtonPrimary.backgroundColornotActive.dark.cgColor] as [NSAttributedString.Key : Any]

        let attributedString1 = NSMutableAttributedString(string:(purchase?.brand?.asset ?? "0")!, attributes:attrs1)

        let attributedString2 = NSMutableAttributedString(string:" / 5", attributes:attrs2)

        attributedString1.append(attributedString2)
        self.appraisal.attributedText = attributedString1
        
        
        print()
        let raiting = ("\((purchase?.brand?.asset ?? "0")!)" as NSString).integerValue
        setImageRaiting(raiting: raiting)
    }
    func setImageRaiting(raiting: Int)
    {
        let yello = RaitingColor.colorFive
        
        star5.image = star5.image?.maskWithColor(color: ButtonPrimary.backgroundColornotActive.ok24);
        star4.image = star4.image?.maskWithColor(color: ButtonPrimary.backgroundColornotActive.ok24);
        star3.image = star3.image?.maskWithColor(color: ButtonPrimary.backgroundColornotActive.ok24);
        star2.image = star2.image?.maskWithColor(color: ButtonPrimary.backgroundColornotActive.ok24);
        star1.image = star1.image?.maskWithColor(color: ButtonPrimary.backgroundColornotActive.ok24);
        
        if raiting >= 1 {
            star5.image = star5.image?.maskWithColor(color: yello);
        }
        if raiting >= 2 {
            star4.image = star4.image?.maskWithColor(color: yello);
        }
        if raiting >= 3 {
            star3.image = star3.image?.maskWithColor(color: yello);
        }
        if raiting >= 4 {
            star2.image = star2.image?.maskWithColor(color: yello);
        }
        if raiting >= 5 {
            star1.image = star1.image?.maskWithColor(color: yello);
        }
    }
    func buttonStyle(buttom: UIButton, label: UILabel)
    {
        buttom.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
        buttom.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 16)
        buttom.tintColor = ButtonPrimary.backgroundColornotActive.dark
        buttom.setProperty()
        label.textColor = ButtonPrimary.backgroundColornotActive.dark
        label.font = UIFont.systemFont(ofSize: 16)
    }
    func setCurrentReview(button: UIButton)
    {
        clearReview()
        button.backgroundColor = green
        button.tintColor = .white
    }
    func clearReview()
    {
        buttom1.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
        buttom1.tintColor = ButtonPrimary.backgroundColornotActive.dark
        
        buttom2.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
        buttom2.tintColor = ButtonPrimary.backgroundColornotActive.dark
        
        buttom3.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
        buttom3.tintColor = ButtonPrimary.backgroundColornotActive.dark
        
        buttom4.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
        buttom4.tintColor = ButtonPrimary.backgroundColornotActive.dark
        
        buttom5.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
        buttom5.tintColor = ButtonPrimary.backgroundColornotActive.dark
        
    }
    @IBAction func setOwne(_ sender: UIButton) {
        presenter.getReviews(asset: 1)
        setCurrentReview(button: sender)
    }
    @IBAction func setTwo(_ sender: UIButton) {
        presenter.getReviews(asset: 2)
        setCurrentReview(button: sender)
    }
    @IBAction func setFree(_ sender: UIButton) {
        presenter.getReviews(asset: 3)
        setCurrentReview(button: sender)
    }
    @IBAction func setFo(_ sender: UIButton) {
        presenter.getReviews(asset: 4)
        setCurrentReview(button: sender)
    }
    
    @IBAction func setFive(_ sender: UIButton) {
        presenter.getReviews(asset: 5)
        setCurrentReview(button: sender)
    }
}
