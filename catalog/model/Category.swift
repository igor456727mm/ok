//
//  Category.swift
//  ok24
//
//  Created by Igor Selivestrov on 19.01.2021.
//  Copyright © 2021 KCT. All rights reserved.
//

import Foundation

struct Category: Decodable {
    var productcat_maingroup_id: Int?
    var productcat_maingroup_name: String?
    var category: CatagoryChilds
}
struct CatagoryChilds: Decodable {
    var productcat_id: Int?
    var productcat_subcat: Int?
    var productcat_label: String?
    var productcat_label_menu: String?
    var productcat_forum: Int?
    var productcat_forum_archive: Int?
    var productcat_sale_hide: Int?
    var productcat_sale_cat: Int?
    var productcat_search_hide: Int?
    var productcat_order: Int?
    var productcat_img: String?
    var productcat_desc: String?
}
