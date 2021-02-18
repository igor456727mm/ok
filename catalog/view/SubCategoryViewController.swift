//
//  SubCategoryViewController.swift
//  ok24
//
//  Created by Igor Selivestrov on 19.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import Foundation
import UIKit

class SubCategoryViewController: UITableViewController {
    
    var category: GroupCategory?
    var presenter : SubCategoryPresenterProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SubCatTableViewCell", bundle: nil), forCellReuseIdentifier: "SubCatTableViewCell")
        presenter.setSubCategory()
        tableView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.category?.category.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCatTableViewCell", for: indexPath) as! SubCatTableViewCell
        let category = presenter.category?.category[indexPath.row]
        cell.category = category
        
        cell.selectionStyle = .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCatTableViewCell", for: indexPath) as! SubCatTableViewCell
        let category = presenter.category
        cell.selectionStyle = .none
        presenter.tabOnTheCategory(category: category, index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80.0)
    }
    
}
extension SubCategoryViewController: SubCategoryViewProtocol {
    func setSubCategory(category: GroupCategory?) {
      //
        print("action")
    }
    
    
    
}


