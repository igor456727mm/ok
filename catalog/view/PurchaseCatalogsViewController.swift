//
//  PurchaseCatalogsViewController.swift
//  ok24
//
//  Created by Igor Selivestrov on 07.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit

class PurchaseCatalogsViewController: UIViewController {
    
    var presenter: PurchaseCatalogViewPresenterProtocol!
    @IBOutlet weak var tableViewCatalog: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewCatalog.delegate = self
        tableViewCatalog.dataSource = self
        tableViewCatalog.register(CatalogCCell.self, forCellReuseIdentifier: "CatalogCCell")
        tableViewCatalog.rowHeight = UITableView.automaticDimension
        tableViewCatalog.estimatedRowHeight = UITableView.automaticDimension
        tableViewCatalog.separatorStyle = .none
        
        
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        if distanceFromBottom < height && !(presenter.loadData ?? false) && !(presenter.listEnd ?? false) && presenter.catalogs?.count ?? 0 > 0 {
            
            presenter.getCatalogs()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 110))

            let searchField = UITextField(frame: CGRect(x: 20, y: 30, width: tableView.frame.width - 40, height: 50))
            searchField.searchField(with: "Искать лоты в закупке")
            searchField.delegate = self

            headerView.addSubview(searchField)

            return headerView
        } 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 110
        }
}
extension PurchaseCatalogsViewController: PurchaseCatalogViewProtocol {
    func success() {
        if (presenter.catalogs?.count == 0) {
            tableViewCatalog.setEmptyMessage("Каталоги не найдены", rotateAngle: 0)
        } else {
            tableViewCatalog.restore()
        }
        tableViewCatalog.separatorStyle = .none
        tableViewCatalog.reloadData()
        
    }
    
    func failure(error: Error) {
        self.showAlert(message: error.localizedDescription)
    }
    
    
}

extension PurchaseCatalogsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.catalogs?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogCCell", for: indexPath) as! CatalogCCell
        let catalog = presenter.catalogs?[indexPath.row]
        if cell.catalog == nil {
            cell.catalog = catalog
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let catalog = presenter.catalogs?[indexPath.row]
        presenter.goTogoods(catalog: catalog!, search: nil)
    }
}

extension PurchaseCatalogsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       textField.resignFirstResponder()
        presenter.goTogoods(catalog: nil, search: textField.text)
       
       return true
    }
}
