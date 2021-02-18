//
//  PurchaseReviewViewController.swift
//  ok24
//
//  Created by Igor Selivestrov on 11.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit

class PurchaseReviewViewController: UIViewController {
    var presenter: PurchaseReviewViewPresenterProtocol!
    
    
    @IBOutlet weak var scrolUIView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailView: ReviewView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        detailView.presenter = presenter 
        detailView.configurateView(purchase: presenter.purchase)
    }
    /*
     
     func actionAnimate()
     {
        constrantChange
        UIView.animate(withDuraption: 1) {
            self.view.layoutIfneeded()
        }
     }
     */

}
extension PurchaseReviewViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.reviews?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        let review = presenter.reviews![indexPath.row]
        cell.review = review
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.layoutSubviews()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}
extension PurchaseReviewViewController : PurchaseReviewViewProtocol {
    func setCountReviews(count: Dictionary<String,Any>) {
        detailView.setCount(count: count)
    }
    
    func success() {
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        var frameTable = self.tableView.frame;
        frameTable.size.height = self.tableView.contentSize.height
        self.tableView.frame = frameTable;
        let tableViewHeight = Double(tableView.contentSize.height )
        //xtableView.bottomAnchor.constraint(equalTo: scrolUIView.bottomAnchor, constant: 50)
        tableView.layoutIfNeeded()
        scrollViewHeight.constant = CGFloat(tableView.contentSize.height - 400 )
        scrolUIView.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    func failure(error: Error) {
        self.showAlert(message: error.localizedDescription)
    }
    
    
}
