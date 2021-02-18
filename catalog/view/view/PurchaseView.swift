//
//  Purchese.swift
//  ok24
//
//  Created by Igor Selivestrov on 31.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit
import Nuke

final class PurchaseView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var viewSub: UIView!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleTV: UILabel!
    @IBOutlet weak var rankTV: UILabel!
    @IBOutlet weak var statusTV: UILabel!
    @IBOutlet weak var orgTV: UILabel!
    var purchase: Purchase?
    var presenter: PurchaseViewPresenterProtocol!
    @IBOutlet weak var catalogs: UIButton!
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    
    @IBOutlet weak var lot: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configurateView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configurateView()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        catalogs.Active()
        catalogs.setProperty()
        
        catalogs.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        
        let yello = RaitingColor.colorFive
        starImage.image = starImage.image?.maskWithColor(color: yello)
        viewSub.layer.cornerRadius = 20;
        viewSub.layer.masksToBounds = true;
        
    }
    /*private func configurateView()
    {
        let view = super.loadViewFromNib(nibName: "PurchaseView")
        view!.frame  = bounds
        self.addSubview(view!)
    }*/
    
    private func configurateView()
    {
        Bundle.main.loadNibNamed("PurchaseView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    func configurateView(purchase: Purchase?)
    {
        
        //self.purchase
        
        if purchase != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            let color = [UIColor.blue, UIColor.orange, UIColor.magenta, UIColor.purple, UIColor.red]
            let randomIndex = arc4random() % UInt32(color.count)
            let color_el = color[Int(randomIndex)]
            
            let attrString = NSMutableAttributedString(string: purchase!.purchase_name)
            attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: color_el, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            titleTV.attributedText = attrString
            titleTV.textAlignment = NSTextAlignment.left
            
            self.titleTV.layoutIfNeeded()
            self.statusTV.text = purchase?.state_text != nil ? ((purchase?.state_text!)! as NSString).description : ""
            self.orgTV.text = "\(purchase!.user.username)"
            
            if purchase?.brand != nil && purchase?.brand!.asset != nil {
                self.rankTV.text = purchase?.brand!.asset
                self.rankTV.raitingColor(floatValue: ((purchase?.brand!.asset ?? "0.0") as NSString).floatValue)
                starImage.isHidden = false
            } else {
                self.rankTV.text = ""
                
                starImage.isHidden = true
            }
            
            if let url = URL(string: AppHelper.correctURLProtocol(path: (purchase?.purchase_img!)!)) {
                self.imageV.layer.cornerRadius = 20
                self.imageV.layer.masksToBounds = true
                self.imageV.clipsToBounds = true
                Nuke.loadImage(with: url, into: self.imageV)
            }
            
            let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : ButtonPrimary.backgroundColor.cgColor()] as [NSAttributedString.Key : Any]

            let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : ButtonPrimary.backgroundColornotActive.dark.cgColor] as [NSAttributedString.Key : Any]

            let attributedString1 = NSMutableAttributedString(string:"Читать отзывы ", attributes:attrs1)

            let attributedString2 = NSMutableAttributedString(string:"\(purchase?.brand?.asset_count ?? "0")", attributes:attrs2)

            attributedString1.append(attributedString2)
            self.review.attributedText = attributedString1
            
            
            let attrs3 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : ButtonPrimary.backgroundColor.cgColor()] as [NSAttributedString.Key : Any]

            let attrs4 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : ButtonPrimary.backgroundColornotActive.dark.cgColor] as [NSAttributedString.Key : Any]

            let attributedString3 = NSMutableAttributedString(string:"Комментарии к лотам ", attributes:attrs3)

            let attributedString4 = NSMutableAttributedString(string: "\(purchase?.brand?.comment_count ?? 0)", attributes:attrs4)  

            attributedString3.append(attributedString4)
            self.lot.attributedText = attributedString3
            
            //UIViewController.setReview(info: review, text: "sdffsdf")
             self.review.isUserInteractionEnabled = true
             let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnReview))
             tapgesture.numberOfTapsRequired = 1
            self.review.addGestureRecognizer(tapgesture)
            
            
             self.lot.isUserInteractionEnabled = true
             let tapgesture2 = UITapGestureRecognizer(target: self, action: #selector(tappedOnComments))
            tapgesture2.numberOfTapsRequired = 1
            self.lot.addGestureRecognizer(tapgesture2)
            
        }
       
    }
    @objc func tappedOnComments(gesture: UITapGestureRecognizer)
    {
        presenter.goTocomments()
    }
    @objc func tappedOnReview(gesture: UITapGestureRecognizer)
    {
        presenter.goToreadReviews()
    }
    @IBAction func shared(_ sender: Any) {
        presenter.shared()
        
    }
    @IBAction func goToCatalogs(_ sender: Any) {
        presenter.goTocatalogs()
    }
}
