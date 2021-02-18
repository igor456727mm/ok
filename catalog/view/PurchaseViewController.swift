//
//  PurchaseViewController.swift
//  ok24
//
//  Created by Igor Selivestrov on 31.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import UIKit

class PurchaseViewController: UIViewController {
    var heightDetail = 570.0
    var heightCatalog = 1500.0
    var heightCollectionView = 200.0
    var heighFooter = 340
    var tableViewHeight = 400.0
    var leftSpacing = 20
    
    var uiNewOrgTitle = UILabel()
    var uiNewOrgImg = UIImageView()
    
    var uiNewOrgTitle2 = UILabel()
    var uiNewOrgImg2 = UIImageView()
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var PurchaseDetail: PurchaseView!
    @IBOutlet weak var purchaseDetailHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    var presenter : PurchaseViewPresenterProtocol!
    lazy var tableView: UITableView = {
        let fraemTV = CGRect(x: 0, y: Int(heightDetail), width: Int(self.view.frame.width), height: Int(tableViewHeight))
        
        let tableView = UITableView(frame: fraemTV)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        
        tableView.register(UINib(nibName: "PurchaseParam", bundle: nil), forCellReuseIdentifier: "PurchaseParam")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return tableView
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let fraemCV = CGRect(x: leftSpacing, y: Int(heightDetail + tableViewHeight), width: Int(self.scrollView.frame.width) - leftSpacing, height: 100)
        
        let cv = UICollectionView(frame: fraemCV, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView")  // UICollectionReusableView

        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCatalogCategory")
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    lazy var footerView: UIStackView = {
        let width = Int(self.scrollView.frame.width) - leftSpacing*2
        let frameStack = CGRect(x: leftSpacing, y: Int(heightDetail + tableViewHeight + heightCollectionView), width: width, height: heighFooter)
        let stackView = UIStackView(frame: frameStack)
        stackView.backgroundColor = .white
        
        let searchField = UITextField(frame: CGRect(x: 0, y: 0, width: width, height: 50))
        searchField.searchField(with: "Искать лоты в закупке")
        searchField.delegate = self
        stackView.addSubview(searchField)
        
        let uiNewOrg = UIView(frame: CGRect(x: 0, y: 80, width: width, height: 72))
        uiNewOrg.isUserInteractionEnabled = true
        uiNewOrg.backgroundColor = .white
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(subscribeOrt))
        gesture.numberOfTapsRequired = 1
        uiNewOrg.addGestureRecognizer(gesture)
        
        uiNewOrgImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
        uiNewOrgTitle = UILabel(frame: CGRect(x: 100, y: 0, width: stackView.frame.width - 100, height: 72))
        print(presenter.purchase?.user.isSubscription)
        print(presenter.purchase?.brand?.isSubscription)
        if presenter.purchase?.user.isSubscription == false {
            uiNewOrgImg.image = UIImage(named: "subscribe")
            uiNewOrgTitle.text = "Подписаться на \rновости организатора"
        }else{
            uiNewOrgImg.image = UIImage(named: "ansubscribe")
            uiNewOrgTitle.text = "Отписаться от \rновости организатора"
        }
        
        
        
        uiNewOrgTitle.textColor = ButtonPrimary.backgroundColorActive.ok24
        uiNewOrgTitle.font = UIFont.boldSystemFont(ofSize: 16)
        uiNewOrgTitle.lineBreakMode = .byWordWrapping
        uiNewOrgTitle.numberOfLines = 2
        
        uiNewOrg.addSubview(uiNewOrgImg)
        uiNewOrg.addSubview(uiNewOrgTitle)
        stackView.addSubview(uiNewOrg)
        
        
        
        let uiNewZak = UIView(frame: CGRect(x: 0, y: 172, width: width, height: 72))
        uiNewZak.isUserInteractionEnabled = true
        uiNewZak.backgroundColor = .white
        let gesture2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(subscribeZakupka))
        gesture2.numberOfTapsRequired = 1
        uiNewZak.addGestureRecognizer(gesture2)
        
        uiNewOrgImg2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
        uiNewOrgTitle2 = UILabel(frame: CGRect(x: 100, y: 0, width: stackView.frame.width - 100, height: 72))
        
        if presenter.purchase?.brand?.isSubscription == false {
            uiNewOrgImg2.image = UIImage(named: "subscribe")
            uiNewOrgTitle2.text = "Подписаться на \rновости закупки"
        }else{
            uiNewOrgImg2.image = UIImage(named: "ansubscribe")
            uiNewOrgTitle2.text = "Отписаться от \rновости закупки"
        }
        
        
        uiNewOrgTitle2.textColor = ButtonPrimary.backgroundColorActive.ok24
        uiNewOrgTitle2.font = UIFont.boldSystemFont(ofSize: 16)
        uiNewOrgTitle2.lineBreakMode = .byWordWrapping
        uiNewOrgTitle2.numberOfLines = 2
        
        uiNewZak.addSubview(uiNewOrgImg2)
        uiNewZak.addSubview(uiNewOrgTitle2)
        stackView.addSubview(uiNewZak)
        
        return stackView
    }()
    
    @IBOutlet weak var catalogView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewHeight.constant = CGFloat(heightCatalog)
        purchaseDetailHeight.constant = CGFloat(heightDetail)
        self.scrollView.addSubview(tableView)
        self.scrollView.addSubview(collectionView)
        let verticalSpace = NSLayoutConstraint(item: PurchaseDetail ?? self.view as Any, attribute: .bottom, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1, constant: 50)
        NSLayoutConstraint.activate([verticalSpace])
        
        self.scrollView.addSubview(footerView)
        let verticalSpaceFooter = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: footerView, attribute: .bottom, multiplier: 1, constant: 50)
        NSLayoutConstraint.activate([verticalSpaceFooter])
        PurchaseDetail.presenter = presenter
        PurchaseDetail.configurateView(purchase: presenter.purchase)
        self.view.layoutIfNeeded()
    }
    @objc func  subscribeOrt() {
        presenter.subscribeOrg()
    }
    @objc func subscribeZakupka()
    {
        presenter.subscribeZak()
    }
}

extension PurchaseViewController: PurchaseViewProtocol {
    func shared() {
        let vc = UIActivityViewController(activityItems: [ URL(string: "https://24-ok.ru/purchase/\(presenter.purchase!.purchase_id)")! as URL], applicationActivities: [])
        self.present(vc, animated: true)
    }
    func subscribeZak(result: String) {
        DispatchQueue.main.async { [weak self] in
            if result == "false"
            {
                self!.uiNewOrgImg2.image = UIImage(named: "subscribe")
                self!.uiNewOrgTitle2.text = "Подписаться на \rновости закупки"
            }else{
                self!.uiNewOrgImg2.image = UIImage(named: "ansubscribe")
                self!.uiNewOrgTitle2.text = "Отписаться от \rновостей закупки"
            }
        }
    }
    
    func updateParams() {
        
    }
    
    func subscribeOrg(result: String) {
        print(result)
        DispatchQueue.main.async { [weak self] in
            if result == "false"
            {
                self!.uiNewOrgImg.image = UIImage(named: "subscribe")
                self!.uiNewOrgTitle.text = "Подписаться на \rновости организатора"
            }else{
                self!.uiNewOrgImg.image = UIImage(named: "ansubscribe")
                self!.uiNewOrgTitle.text = "Отписаться от \rновостей организатора"
            }
            
           
        }
        
    }
    
    func success() {
        
        
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.layoutIfNeeded()
        var frameTable = self.tableView.frame;
        frameTable.size.height = self.tableView.contentSize.height;
        self.tableView.frame = frameTable;
        self.tableViewHeight = Double(tableView.contentSize.height + 10)
        
        if (presenter.catalogs?.count == 0) {
            collectionView.setEmptyMessage("Закупки не найдены")
        } else {
            collectionView.restore()
        }
        collectionView.reloadData()
        //heightCollectionView = Double(collectionView.contentSize.height)
        heightCollectionView = Double(CGFloat(presenter.catalogs?.count ?? 0) * 90) + 60
        collectionView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: CGFloat(heightCollectionView))
        collectionView.frame = CGRect(x: CGFloat(leftSpacing), y:  CGFloat(heightDetail + tableViewHeight), width: scrollView.frame.width - 40, height: CGFloat(heightCollectionView))
        scrollViewHeight.constant = CGFloat(heightDetail) + CGFloat(heightCollectionView) + CGFloat(tableViewHeight) + CGFloat(heighFooter)
        
        var frameFooter = CGRect(x: CGFloat(leftSpacing), y: CGFloat(heightDetail) + CGFloat(heightCollectionView) + CGFloat(tableViewHeight) , width: self.footerView.frame.width, height: self.footerView.frame.height)
        
        self.footerView.frame = frameFooter;
        //self.tableViewHeight = Double(tableView.contentSize.height + 10)
        
        scrollView.layoutIfNeeded()
        self.view.layoutIfNeeded()
        
        
    }
    func failure(error: Error) {
        
        self.showAlert(message: error.localizedDescription)
    }
    
    
}
extension PurchaseViewController :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.catalogs?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let catalog = presenter.catalogs?[indexPath.row]
        presenter.goTogoods(search: nil, catalog: catalog)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCatalogCategory", for: indexPath) as! MainCollectionViewCell
        
        let catalog = presenter.catalogs?[indexPath.row]
        //cell.widthAnchor.constraint(equalTo: self.catalogView.widthAnchor, constant: 1000)
        cell.catalog = catalog
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
                let kWhateverHeightYouWant = 90
        return CGSize(width: self.view.frame.width, height: CGFloat(kWhateverHeightYouWant))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 15, bottom: 0, right: 15)
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            print(2)
            
             let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
            sectionHeader.label.text = "Каталоги"
             return sectionHeader
        } else {
             let res = UICollectionReusableView()
             return res
        }
    }
}

extension PurchaseViewController : UITableViewDelegate, UITableViewDataSource {
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.layoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.purchaseParams?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseParam", for: indexPath) as! PurchaseParam
        if indexPath.row == 8
        {
            let data = presenter?.purchaseParams?[indexPath.row].value!.data(using: .unicode)!
            let attributedString = try? NSAttributedString(
                data: data!,
                options: [.documentType: NSAttributedString.DocumentType.html, .defaultAttributes : [NSAttributedString.Key.font: 20]],
                documentAttributes: nil)
            cell.value?.attributedText = attributedString
            
            
        }else{
            cell.value?.text = presenter?.purchaseParams?[indexPath.row].value
        }
        if indexPath.row == 7 {
            cell.value?.textColor = .red
        }else {
            cell.value?.textColor = .black
        }
        cell.label?.text = presenter?.purchaseParams?[indexPath.row].label
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension PurchaseViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       textField.resignFirstResponder()
        presenter.goTogoods(search: textField.text, catalog: nil)
       
       return true
    }
}
