//
//  User.swift
//  TiffinService
//
//  Created by Nitin Jami on 5/8/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    var firstName: String!
    var lastName: String!
    var phone: String!
    var email: String!
    var role: String!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        firstName <- map["firstname"]
        lastName <- map["lastname"]
        phone <- map["phone"]
        email <- map["email"]
        role <- map["role"]
    }
}
