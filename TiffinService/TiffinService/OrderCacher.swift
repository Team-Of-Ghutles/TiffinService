//
//  OrderCacher.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/24/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation

import ObjectMapper

class OrderCaher {
    /**
    The purpose of this cacher for now is to maintain last order's information in UserDefaults. Timeline of this cache is 1 day 
    like stuff kept in locker rooms
    */
    static var userDefaultsKey = "PreviousOrderItems"
    var cache: [String: Any]?
    let prefs = UserDefaults.standard
    
    init() {
        self.cache = self.prefs.dictionary(forKey: OrderCaher.userDefaultsKey)
    }
    
    ///Method to serialize OrderItemVM as a [String:Any] into self.cache
    func serializeToCache(viewModel: OrderItemVM) {
        if self.cache == nil {
            self.cache = [String: Any]()
        }
        self.cache![viewModel.itemID] = Mapper().toJSON(viewModel.model)
    }
    
    /**
     When the previous order had an item that has been rmeoved from current order, that OrderItemVM instance needs to be appended
     to be passed on to the networker, i.e., that item's count needs to be deducted
     */
    func addMissingItemFromPrevOrder(newOrderItemVMs: [OrderItemVM]) -> [OrderItemVM]{
        var newOrderItemsCopy = newOrderItemVMs
        var missingDict = [String: Bool]()
        for orderItem in newOrderItemVMs {
            missingDict[orderItem.itemID] = true
        }
        if self.cache != nil {
            for (itemId, dictVal) in self.cache! {
                if missingDict[itemId] == nil {
                    let orderItem = Mapper<OrderItem>().map(JSON: dictVal as! [String : Any])
                    orderItem?.quantity = 0
                    orderItem?.itemID = itemId
                    newOrderItemsCopy.append(OrderItemVM(orderItem: orderItem!))
                }
            }
        }
        self.cache = [String: Any]()
        newOrderItemVMs.map {self.serializeToCache(viewModel: $0)}
        self.prefs.set(self.cache, forKey: "PreviousOrderItems")
        self.prefs.set(getCurrentDate(), forKey: "Date")
        return newOrderItemsCopy
    }
}
