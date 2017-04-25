//
//  MenuViewModel.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/22/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation

class MenuItemVM {
    
    var itemID: String!
    var name: String!
    var price: String!
    var description: String!
    var model: MenuItem!
    
    ///For creating instances after fetching underlying model from network
    init(menuItem: MenuItem) {
        self.name = menuItem.name
        self.price = "$" + "\(menuItem.price!)"
        self.description = menuItem.description
        self.model = menuItem
        self.itemID = menuItem.itemID == nil ? "0": menuItem.itemID
        
    }
    
    ///For creating an instance form the UI
    init(name: String, price: Int, description: String) {
        self.name = name
        self.price = "$" + "\(price)"
        self.description = description
        self.model = MenuItem(name: name, desc: description, price: price)
    }
}

class PublishedMenuVM {
    
    var publishDate: String!
    var model: PublishedMenu!
    var containees: [MenuItemVM]!
    
    ///For creating instances after fetching underlying model from network
    init(publishedMenu: PublishedMenu) {
        self.publishDate = publishedMenu.publishDate
        self.containees = publishedMenu.containees.map {MenuItemVM(menuItem: $0)}
        self.model = publishedMenu
    }
    
    ///For creating an instance form the UI
    init(pubDate: String, menuItemVMs: [MenuItemVM]) {
        self.publishDate = pubDate
        self.containees = menuItemVMs
        var menuItems = [MenuItem]()
        self.model = PublishedMenu(publishDate: pubDate, menuItems: menuItemVMs.map {$0.model})
    }
}
