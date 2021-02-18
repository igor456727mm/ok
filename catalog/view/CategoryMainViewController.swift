//
//  CategoryMainViewController.swift
//  ok24
//
//  Created by Igor Selivestrov on 24.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit

class CategoryMainViewController: UITableViewController {

    var Category: [GroupCategory]? = []
    var presenter : MainViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "parentCategory")

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(presenter.category?.count ?? 0)
        return presenter.category?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parentCategory", for: indexPath)
        let category = presenter.category?[indexPath.row].productcat_maingroup_name
        cell.textLabel?.text = category
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parentCategory", for: indexPath)
        let category = presenter.category?[indexPath.row]
        
        presenter.tabOnTheCategory(category: category)
    }

}

extension CategoryMainViewController: MainViewProtocol {
    func success() {
        
        self.tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error)
    }
    
    
}
