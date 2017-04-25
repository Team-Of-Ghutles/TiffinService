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
    
    var cache: [String: Any]?
    let prefs = UserDefaults.standard
    
    init() {
        self.cache = self.prefs.dictionary(forKey: "PreviousOrderItems")
    }
    
    ///Method to serialize OrderItemVM as a [String:Any] into self.cache
    func _serializeToCache(orderVM: OrderItemVM) {
        if self.cache == nil {
            self.cache = [String: Any]()
        }
        self.cache![orderVM.itemID] = Mapper().toJSON(orderVM.model)
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
        newOrderItemVMs.map {self._serializeToCache(orderVM: $0)}
        self.prefs.set(self.cache, forKey: "PreviousOrderItems")
        return newOrderItemsCopy
    }
}
