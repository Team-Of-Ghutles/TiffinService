//
//  MenuInventoryItem.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/21/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation

import Foundation
import Firebase
import ObjectMapper


class MenuItem: Mappable {
    
    var itemID: String!
    var name: String!
    var price: Int!
    var description: String!
    var customOptions: String!
    
    init(name: String, desc: String, price: Int, customOptions: String="") {
        self.name = name
        self.price = price
        self.description = desc
        self.customOptions = customOptions
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.name <- map["Name"]
        self.description <- map["Description"]
        self.price <- map["Price"]
        self.customOptions <- map["CustomOptions"]
    }
}

class PublishedMenu {
    
    static var networkDelegate = PublishedMenuNetworker.self
    
    var publishDate: String!
    var containees: [MenuItem]!
    
    init(publishDate: String, menuItems: [MenuItem]) {
        self.publishDate = publishDate
        self.containees = menuItems
    }
}
