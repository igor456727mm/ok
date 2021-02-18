//
//  PurchaseCommentsViewController.swift
//  ok24
//
//  Created by Igor Selivestrov on 14.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit
import ImageSlideshow
import AlamofireImage


class GoodDetailViewController: UIViewController {
    
    var leftSpacing = 20
    var presenter: GoodDetailViewPresenterProtocol!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewButtonLeft: UIView!
    @IBOutlet weak var viewButtonRight: UIView!
    
    @IBOutlet weak var countOrder: UIButton!
    @IBOutlet weak var imageSlideshowAspectConstraint: NSLayoutConstraint!
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var countComment: UIButton!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var organization_price: UILabel!
    @IBOutlet weak var organizationProcent: UILabel!
    
    @IBOutlet weak var delivery_price: UILabel!
    @IBOutlet weak var delivery_title: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setSlideshow()
        setViewButtons()
        setPrices()
        setComment()
    }
    func setComment()
    {
        collectionView.frame = CGRect(x: leftSpacing, y: 0, width:Int(self.view.frame.width) - leftSpacing, height: Int(collectionView.contentSize.height))
        collectionViewHeight.constant = CGFloat(Int(collectionView.contentSize.height))
        //scrollView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: scrollView.frame.height + collectionViewHeight.constant)
        scrollViewHeight.constant = 1500
        scrollView.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    func setPrices()
    {
        titleText.text = presenter.good?.lot_name
        price.text = presenter.good?.lot_cost_format
        price.tintColor = GoodColor.price
        price.font = UIFont.boldSystemFont(ofSize: 14)
        
        discount.attributedText = String((presenter.good?.lot_full_cost_format)!).strikeThrough()
        discount.font = UIFont.systemFont(ofSize: 14)
        discount.textColor = ButtonPrimary.backgroundColornotActive.dark
        
        organization_price.font = UIFont.boldSystemFont(ofSize: 12)
        organization_price.textColor = ButtonPrimary.backgroundColornotActive.dark
        organization_price.text = presenter.good?.lot_orgrate_format
        
        organizationProcent.font = UIFont.systemFont(ofSize: 12)
        organizationProcent.textColor = ButtonPrimary.backgroundColornotActive.dark
        organizationProcent.text = "Организационный взнос \(presenter.good?.lot_orgrate_cost_format)"
        
        delivery_title.font = UIFont.systemFont(ofSize: 12)
        delivery_title.textColor = ButtonPrimary.backgroundColornotActive.dark
        delivery_title.text = "Доставка "
        
        delivery_price.font = UIFont.boldSystemFont(ofSize: 12)
        delivery_price.textColor = ButtonPrimary.backgroundColornotActive.dark
        delivery_price.text = String(describing: presenter.good?.lot_delivery) 
        
        
    }
    func setViewButtons()
    {
        viewButtonLeft.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
        viewButtonRight.backgroundColor = ButtonPrimary.backgroundColornotActive.ok24
        viewButtonLeft.layer.cornerRadius = 10
        viewButtonLeft.layer.masksToBounds = true
        viewButtonRight.layer.cornerRadius = 10
        viewButtonRight.layer.masksToBounds = true
        countOrder.setTitle(presenter.good?.orders_count?.description, for: .normal)
        countOrder.setTitleColor(ButtonPrimary.backgroundColornotActive.ok24, for: .normal)
        countComment.setTitle(presenter.good?.comments_count?.description, for: .normal)
        countComment.setTitleColor(ButtonPrimary.backgroundColornotActive.ok24, for: .normal)
    }
    func setSlideshow()
    {
        var images: [InputSource] = []
        
        if presenter.good?.lots_img != nil && (presenter.good?.lots_img?.count)! > 0 {
            
            for (_, image) in presenter.good!.lots_img!.enumerated() {
                images.append(AlamofireSource(urlString: image.hires != nil ? image.hires! : image.normal)!)
            }
        } else {
            print("No photos")
            images.append(AlamofireSource(urlString: presenter.good!.main_thumb_img ?? "")!)
        }
        
        slideShow.setImageInputs(images)
        let pageIndicator = slideShow.pageIndicator
        if pageIndicator!.numberOfPages > 0 {
            for i in 0 ..< pageIndicator!.numberOfPages {
                
                let border = UIView()
                border.frame = CGRect(x: -1.5 + Double(i*16), y: Double((pageIndicator?.view.frame.size.height)!/2-5) + 150, width: 10.0, height: 10.0)
                border.layer.cornerRadius = 5
                border.clipsToBounds = true
                border.backgroundColor = UIColor(white: 0.5, alpha: 0.4)
                pageIndicator?.view.addSubview(border)
            }
        }
        let newConstraint = imageSlideshowAspectConstraint.constraintWithMultiplier(1)
        self.view!.removeConstraint(imageSlideshowAspectConstraint)
        newConstraint.isActive = true
    }
    
    @IBAction func shared(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: [ URL(string: "https://24-ok.ru/purchase/\(presenter.purchase?.purchase_id as! Int)/log/\(presenter.good?.lot_id as! Int)")! as URL], applicationActivities: [])
        self.present(vc, animated: true)
    }
}


extension GoodDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return presenter.good?.comments?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCollectionViewCell", for: indexPath) as! CommentCollectionViewCell
        
        let comment = presenter.good?.comments?[indexPath.row]
        
        cell.configureDetailGood(with: comment!)
        
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 20, height: 150)
    }
}

extension GoodDetailViewController: GoodDetailViewProtocol {
    func success() {
        
        self.loadViewIfNeeded()
    }
    
    func failure(error: Error) {
        self.showAlert(message: error.localizedDescription)
    }
    
    
}
