//
//  ChildSubCategoryViewController.swift
//  ok24
//
//  Created by Igor Selivestrov on 27.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit

class ChildSubCategoryViewController:  UITableViewController {
    var presenter : ChildSubPresenterProtocol!
    
   
    
    //var category_id: Int = 0
    var category: SubCategory?
    var selectedRow = false
    lazy var actionLancher: ActionsLancher = {
        let launcher = ActionsLancher()
        return launcher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.register(UINib(nibName: "ChildSubTableViewCell", bundle: nil), forCellReuseIdentifier: "ChildSubCategory")
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.purchases?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildSubCategory", for: indexPath) as! ChildSubTableViewCell
        let purchases = presenter.purchases![indexPath.row]
        cell.cellSetData(purchase: purchases, indexPath: indexPath.row) 
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.separatorInset = UIEdgeInsets(top: 0, left: CGFloat.greatestFiniteMagnitude, bottom: 0, right: 0);

        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let purchase = presenter.purchases?[indexPath.row] {
            presenter.tabOnTheCategory(purchase: purchase)
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        if distanceFromBottom < height && !(presenter.loadData ?? false) && !(presenter.listEnd ?? false) && presenter.purchases?.count ?? 0 > 0 {
            
            presenter.getPurchases()
        }
    }
}

extension ChildSubCategoryViewController: ChildSubViewProtocol {
    func success() {
        if (presenter.purchases?.count == 0) {
            tableView.setEmptyMessage("Закупки не найдены", rotateAngle: 0)
        } else {
            tableView.restore()
        }
        tableView?.reloadData()
       
    }
    
    func failure(error: Error) {
        
        self.showAlert(message: error.localizedDescription)
    }
    func selected()
    {
        selectedRow = false
    }
    
}
