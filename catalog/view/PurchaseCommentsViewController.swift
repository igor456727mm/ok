//
//  PurchaseCommentsViewController.swift
//  ok24
//
//  Created by Igor Selivestrov on 14.02.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit



class PurchaseCommentsViewController: UIViewController {
    
    //@IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var scrollView: UIView!
    var presenter: PurchaseCommentViewPresenterProtocol!
    var idsArray : [Int] = []
    @IBOutlet weak var tableViewComment: UITableView!
    var searchField : UITextField!
    var headerView: UIView!
    var headerViewFlag : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewComment.delegate = self
        tableViewComment.dataSource = self
        tableViewComment.register(UINib(nibName: "GoodsCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsCommentTableViewCell")
        tableViewComment.rowHeight = UITableView.automaticDimension
        tableViewComment.estimatedRowHeight = UITableView.automaticDimension
        tableViewComment.separatorStyle = .none
       
        
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        if distanceFromBottom < height && !(presenter.loadData ?? false) && !(presenter.listEnd ?? false) && presenter.goods?.count ?? 0 > 0 {
            
            presenter.getGoodsComments(search: presenter.search)
            
        }
    }
    
}
extension PurchaseCommentsViewController: PurchaseCommentViewProtocol {
    func success(search: String?) {
        if (presenter.goods?.count == 0) {
            tableViewComment.setEmptyMessage("Лоты не найдены", rotateAngle: 0)
        } else {
            tableViewComment.restore()
        }
        tableViewComment.separatorStyle = .none
        tableViewComment.reloadData()
        tableViewComment.rowHeight = UITableView.automaticDimension
        tableViewComment.estimatedRowHeight = UITableView.automaticDimension
        
       
        searchField.text = search
    }
    
    func failure(error: Error) {
        print("failure")
        self.showAlert(message: error.localizedDescription)
    }
    
    
}
extension PurchaseCommentsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.goods?.count ?? 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if headerViewFlag == false {
            
            headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 90))

            searchField = UITextField(frame: CGRect(x: 20, y: 20, width: tableView.frame.width - 40, height: 50)) 
            searchField.searchField(with: "Искать среди комментариев")
            searchField.delegate = self
            headerView.addSubview(searchField)
            headerViewFlag = true
            return headerView
        }else{
            
            return headerView
        }
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 90
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let good = presenter.goods?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCommentTableViewCell", for: indexPath) as! GoodsCommentTableViewCell
        if (idsArray.firstIndex(of: (indexPath.row)) != nil) {
            //return UITableViewCell()
        }else{
            
            idsArray.append(indexPath.row)
        }
       
        cell.updateCellWith(with: (good?.comments)!)
        
        cell.Lot = good
        cell.selectionStyle = .none
        //cell.layoutIfNeeded()
        return cell
    }
    
    
}

extension PurchaseCommentsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        presenter.getGoodsComments(search: textField.text)
       
        
       return true
    }
}
