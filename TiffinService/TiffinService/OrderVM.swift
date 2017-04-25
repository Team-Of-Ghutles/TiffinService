//
//  OrderVM.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/22/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation

class OrderItemVM {
    
    var model: OrderItem!
    var itemID: String!
    var name: String!
    var description: String! {
        return self.model.description
    }
    var price: String!
    var quantity: String! {
        get {
            return "\(model.quantity!)"
        }
        // This means that self.model must already be inittialized by the time quantity is set :(. How to make sure?
        set(newQty) {
            self.model.quantity = Int(newQty)!
        }
    }
    var instructions: String!
    var itemTotal: String {
        return "$" + "\(self.model.price * self.model.quantity)"
    }
    
    ///For creating instances after fetching underlying model from network
    init(orderItem: OrderItem) {
        self.model = orderItem
        self.itemID = orderItem.itemID
        self.name = orderItem.name
        self.price = "$" + "\(orderItem.price)"
        self.quantity = "\(orderItem.quantity!)"
        self.instructions = orderItem.instructions
    }
    
    
    init(menuItemVM: MenuItemVM, quantity: Int, instructions: String = "") {
        self.model = OrderItem(menuItem: menuItemVM.model, quantity: quantity)
        self.itemID = menuItemVM.itemID
        self.name = menuItemVM.name
        self.price = menuItemVM.price
        self.quantity = "\(quantity)"
        self.instructions = instructions
    }
}

class OrderVM {
    
    var networker = OrderNetworker()
    
    var userId: String!
    var userName: String!
    var orderTime: String!
    var containees: [OrderItemVM]!
    var model: Order!
    
    ///For creating instance after fetching underlying model form network
    init(order: Order) {
        self.userId = order.userId
        self.userName = order.userName
        self.orderTime = order.orderTime
        self.containees = order.containees.map {OrderItemVM(orderItem: $0)}
        self.model = order
    }
    
    /// For creating instance from UI
    init(userId: String, userName: String, orderTime: String, orderDate: String, orderItemVMs: [OrderItemVM]) {
        self.userId = userId
        self.userName = userName
        self.orderTime = orderTime
        self.containees = orderItemVMs.filter {Int($0.quantity)! > 0}
        self.model = Order(userId: userId, userName: userName, orderTime: orderTime, orderDate: orderDate, orderItems: self.containees.map {$0.model})
        
    }
}


