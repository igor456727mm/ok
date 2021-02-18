//
//  NetworkService.swift
//  pattern
//
//  Created by Igor Selivestrov on 21.06.2020.
//  Copyright © 2020 Igor Selivestrov. All rights reserved.
//

import UIKit
import Foundation

protocol NetworkServiceProtocol {
    //Catalog
    func getCategory(completion: @escaping (Result<[GroupCategory]?, Error>) -> Void)
    func getPurchases(completion: @escaping (Result<([Purchase]?, Int, Int), Error>) -> Void)
    func getCatalogs(completion: @escaping (Result<([Catalog]?, Int, Int), Error>) -> Void)
    func getGoodsComments(completion: @escaping (Result<([PurchaseGoodsforComments]?, Int, Int), Error>) -> Void)
    func getReviews(completion: @escaping (Result<([PurchaseReviews]?), Error>) -> Void)
    func getAssetsCount(completion: @escaping (Result<Dictionary<String,Any>, Error>) -> Void)
    func getGoods(completion: @escaping (Result<([Goods]?, Int, Int), Error>) -> Void)
    func getGood(completion: @escaping (Result<(Goods?), Error>) -> Void)
    
    //Subscribe
    func subscribeOrg(completion: @escaping (String) -> Void)
    func subscribeZak(completion: @escaping (String) -> Void)
    
    var controller: UIViewController? { get set }
    var params: [String: Any]  { get set }
    func convert(text: String?) -> String
}
class NetworkService: NetworkServiceProtocol {
    func getGood(completion: @escaping (Result<(Goods?), Error>) -> Void) {
        guard let urlString = apiUrl! + "lot?lot_id=\(params["lot_id"] ?? "")" as String? else { return  }
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error ) in
            if error != nil {
                completion(.failure(error as! Error))
            }
            do {
                guard let  jsonString1 = String(data: data!, encoding: .utf8) else { return }
                
                let  jsonString = try JSONDecoder().decode(Goods.self, from: data!)
                completion(.success((jsonString)))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func convert(text: String?) -> String {
        if let encoded = (text as! NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue) {
            return encoded
        }
        return ""
    }
    
    func getGoods(completion: @escaping (Result<([Goods]?, Int, Int), Error>) -> Void) {
        if !(controller?.checkConnection())! { return }
        var catalogUrl = ""
        var purchaseUrl = ""
        if params["catalog_id"] != nil {
            catalogUrl = "&catalog_id=\(params["catalog_id"] ?? "")"
        }else{
            purchaseUrl = "&purchase_id=\(params["purchase_id"] ?? "")"
        }
        guard let urlString = apiUrl! + "lots?page=\(params["page"] ?? 1)\(purchaseUrl)\(catalogUrl)&Lots_search[find]=\(self.convert(text: ((params["search"] ?? "") as! String)) )" as String? else { return  }
        print(urlString)
        guard let url = URL(string: urlString) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { (data, response, error ) in
                var listPage = 0
                var listEnd = 0
                if let httpResponse = response as? HTTPURLResponse {
                     if let headers = httpResponse.allHeaderFields as? [String: String]  {
                        
                         listPage = Int(headers["x-pagination-current-page"] ?? "0")!
                         listEnd = Int(headers["x-pagination-page-count"] ?? "0")!
                     }
                }

                if error != nil {
                    completion(.failure(error as! Error))
                    return
                }
                
                guard let data = data else { return }
                do {
                    guard let  jsonString1 = String(data: data, encoding: .utf8) else { return }
                    print(jsonString1)
                    let  jsonString = try JSONDecoder().decode([Goods].self, from: data)
                    completion(.success((jsonString, listPage,listEnd)))
                } catch {
                    completion(.failure(error))
                }
                
                
            }.resume()
    }
    
    func getGoodsComments(completion: @escaping (Result<([PurchaseGoodsforComments]?, Int, Int), Error>) -> Void) {
        if !(controller?.checkConnection())! { return }
       
        guard let urlString = apiUrl! + "purchases/comment?purchase_id=\(params["purchase_id"] ?? "")&page=\(params["page"] as! Int)&find=\(self.convert(text: ((params["search"] ?? "") as! String)) )" as String? else { return  }
        print(urlString)
        guard let url = URL(string: urlString) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { (data, response, error ) in
                var listPage = 0
                var listEnd = 0
                if let httpResponse = response as? HTTPURLResponse {
                     if let headers = httpResponse.allHeaderFields as? [String: String]  {
                        
                         listPage = Int(headers["x-pagination-current-page"] ?? "0")!
                         listEnd = Int(headers["x-pagination-page-count"] ?? "0")!
                     }
                }

                if error != nil {
                    completion(.failure(error!))
                    return
                }
                print("start network")
                guard let data = data else { return }
                do {
                    guard let  jsonString1 = String(data: data, encoding: .utf8) else { return }
                    print(jsonString1)
                    
                    let  jsonString = try JSONDecoder().decode([PurchaseGoodsforComments].self, from: data)
                    
                    completion(.success((jsonString, listPage,listEnd)))
                } catch {
                    completion(.failure(error))
                }
                
                
            }.resume()
    }
    
    func getAssetsCount(completion: @escaping (Result<Dictionary<String,Any>, Error>) -> Void) {
        guard let urlString = apiUrl! + "purchases/asset-total?access-token=\(token ?? "")&purchase_id=\(params["purchase_id"] as! Int)" as String? else { return  }
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error ) in
            
            guard let data = data else { return }
            do {
                
                let  jsonString = String(data: data, encoding: .utf8)
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                    {
                    completion(.success(jsonArray))
                    } else {
                        completion(.failure(error as! Error))
                    }
            } catch {
                completion(.failure(error))
            }
            
            
        }.resume()
    }
    
    func getReviews(completion: @escaping (Result<([PurchaseReviews]?), Error>) -> Void) {
        
        let asset = ((params["asset"] != nil) ? "&asset=\((params["asset"] as! Int) )" : "")
        guard let urlString = apiUrl! + "purchases/asset?access-token=\(token ?? "")&purchase_id=\(params["purchase_id"] as! Int)\(asset)" as String? else { return  }
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error ) in
            
            guard let data = data else { return }
            do {
                
                let  jsonString = try JSONDecoder().decode([PurchaseReviews].self, from: data) 
                completion(.success(jsonString))
            } catch {
                completion(.failure(error))
            }
            
            
        }.resume()
    }
    
    
    
    func subscribeOrg(completion: @escaping (String) -> Void) {
        let urlString = apiUrl! + "subscription/change?access-token=\(token ?? "")&brand_id=\(params["brand_id"] ?? "")" as String?
        guard let url = URL(string: urlString!) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error ) in
            
            let  jsonString = String(data: data!, encoding: .utf8)
            
            completion(jsonString!)
            
        }.resume()
        
    }
    func subscribeZak(completion: @escaping (String) -> Void) {
        let urlString = apiUrl! + "subscription/change?access-token=\(token ?? "")&user_id=\(params["user_id"] ?? 0)" as String?
        guard let url = URL(string: urlString!) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error ) in
            
            let  jsonString = String(data: data!, encoding: .utf8)
            
            completion(jsonString!)
            
        }.resume()
        
    }
    
    func getCatalogs(completion: @escaping (Result<([Catalog]?, Int, Int), Error>) -> Void) {
        if !(controller?.checkConnection())! { return }
       
        guard let urlString = apiUrl! + "catalogs?purchase_id=\(params["purchase_id"] ?? "")&page=\(params["page"] ?? 1)" as String? else { return  }
        guard let url = URL(string: urlString) else { return }
        
        
        
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            
            URLSession.shared.dataTask(with: request) { (data, response, error ) in
                var listPage = 0
                var listEnd = 0
                if let httpResponse = response as? HTTPURLResponse {
                     if let headers = httpResponse.allHeaderFields as? [String: String]  {
                        
                         listPage = Int(headers["x-pagination-current-page"] ?? "0")!
                         listEnd = Int(headers["x-pagination-page-count"] ?? "0")!
                     }
                }

                if error != nil {
                    completion(.failure(error as! Error))
                    return
                }
                
                guard let data = data else { return }
                do {
                    guard let  jsonString1 = String(data: data, encoding: .utf8) else { return }
                    print(jsonString1)
                    let  jsonString = try JSONDecoder().decode([Catalog].self, from: data)
                    completion(.success((jsonString, listPage,listEnd)))
                } catch {
                    completion(.failure(error))
                }
                
                
            }.resume()
        
       
    }
    
    var controller: UIViewController?
    var params: [String: Any] = [:]
    func getPurchases(completion: @escaping (Result<([Purchase]?, Int, Int), Error>) -> Void) {
        if !(controller?.checkConnection())! { return }
       
        guard let urlString = apiUrl! + "purchases?PurchasesSearch[finder_category]=\(params["PurchasesSearch[finder_category]"] ?? "")&page=\(params["page"] ?? "")" as String? else { return  }
        guard let url = URL(string: urlString) else { return }
        
        print(params)
        
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            
            URLSession.shared.dataTask(with: request) { (data, response, error ) in
                var listPage = 0
                var listEnd = 0
                if let httpResponse = response as? HTTPURLResponse {
                     if let headers = httpResponse.allHeaderFields as? [String: String]  {
                        
                         listPage = Int(headers["x-pagination-current-page"] ?? "0")!
                         listEnd = Int(headers["x-pagination-page-count"] ?? "0")!
                     }
                }

                if error != nil {
                    completion(.failure(error as! Error))
                    return
                }
                
                guard let data = data else { return }
                do {
                    let  jsonString = try JSONDecoder().decode([Purchase].self, from: data)
                    completion(.success((jsonString, listPage,listEnd)))
                } catch {
                    completion(.failure(error))
                }
                
                
            }.resume()
        
       
        
    }
    
    
    
    
    func getCategory(completion: @escaping (Result<[GroupCategory]?, Error>) -> Void) {
        
        guard let urlString = apiUrl! + "category_group" as String? else { return  }
        guard let url = URL(string: urlString) else { return }
        if !(controller?.checkConnection())! { return }
        AppHelper.showActivityIndicator(view: controller!.view, withOpaqueOverlay: true)
        
        URLSession.shared.dataTask(with: url) { (data, response, error ) in
            
            if error != nil {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else { return }
            do {
                
                let  jsonString = try JSONDecoder().decode([GroupCategory].self, from: data)
                print(jsonString)
                completion(.success(jsonString))
            } catch {
                
                completion(.failure(error))
            }
            
            
        }
        .resume()
        AppHelper.hideActivityIndicator(view: controller!.view)
    }
    
    
    /*class func fetch(completion: @escaping (String) -> ())
    {
        guard let urlString = Setting.shared.urlString as String? else { return  }
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error ) in
            if error != nil {
                print("error")
            }
            guard let data = data else { return }
            guard let  jsonString = String(data: data, encoding: .utf8) else { return }
            completion(jsonString)
        }
        task.resume()
        
    }*/
}
