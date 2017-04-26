//
//  TransactionCacher.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/24/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation
import ObjectMapper

class TransactionCacher {
    /**
     The purpose of this cacher for now is to maintain last transaction order information in UserDefaults. Timeline of this cache is 1 day -
     like stuff kept in locker rooms
     */
    static let userDefaultsKey = "LastTransactionOrder"
    var cache: [String: Any]?
    let prefs = UserDefaults.standard
    
    init() {
        self.cache = prefs.dictionary(forKey: TransactionCacher.userDefaultsKey)
    }
    
    func serializeToCache(viewModel: TransactionVM) {
        self.cache = Mapper().toJSON(viewModel.model)
        self.cache?["id"] = viewModel.id
        self.prefs.set(self.cache, forKey: "LastTransactionOrder")
    }
    
}
