//
//  TransactionVM.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/22/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation

class TransactionVM {
    
    var networker =  TransactionNetworker()
    
    var model: Transaction!
    var id: String {
        return self.model.id
    }
    var amount: String { //Put in logic to detemine the prepend string based on current logged in user
        return "$" + "\(self.model.amount)"
    }
    var type: String {
        return self.model.type
    }
    var date: String { //May be a different date format?
        return self.model.date
    }
    var time: String {
        return self.model.time
    }
    var userId: String {
        return self.model.userId
    }
    
    ///For creating instances after fetching underlying model from network
    init(transaction: Transaction) {
        self.model = transaction
    }
    
    ///For creating an instance from UI
    init(amount: String, type: String, userId: String) {
        let txnAmount = String(amount.characters.dropFirst())
        self.model = Transaction(amount: Int(txnAmount)!, type: type, date: getCurrentDate(), time: getCurrentTime(), userId: userId)
    }
}
