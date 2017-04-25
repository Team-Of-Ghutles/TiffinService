//
//  Transaction.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/21/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation
import ObjectMapper

class Transaction: Mappable {
    
    var id: String!
    var amount: Int!
    var type: String!
    var date: String!
    var time: String!
    var userId: String!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.amount <- map["Amount"]
        self.type <- map["Type"]
        self.date <- map["Date"]
        self.time <- map["Time"]
    }
    
    
    init(amount: Int, type: String, date: String, time: String, userId: String) {
        self.id = UUID().uuidString
        self.amount = amount
        self.type = type
        self.date = date
        self.time = time
        self.userId = userId
    }
}
