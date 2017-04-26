//
//  TransactionNetworker.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/22/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

struct TransactionNetworker {
    
    static var REF_TRANSACTIONS = FIRDatabase.database().reference().child("Transactions")
    
    func writeToDB(viewModel: TransactionVM, completed: @escaping ()->()) {
        let transactionJSON = Mapper().toJSON(viewModel.model)
        TransactionNetworker.REF_TRANSACTIONS.child(viewModel.userId).observeSingleEvent(of: .value, with: { (snapshot) in
            let txnCacher = TransactionCacher()
            if snapshot.exists() {
                if let prevTxn = txnCacher.cache {
                    if viewModel.type == "ORDER" {
                        TransactionNetworker.REF_TRANSACTIONS.child(viewModel.model.userId).child(prevTxn["id"] as! String).removeValue()
                        txnCacher.serializeToCache(viewModel: viewModel)
                    }
                }
                TransactionNetworker.REF_TRANSACTIONS.child(viewModel.model.userId).updateChildValues(
                    [viewModel.model.id: transactionJSON]
                ){_,_ in completed()}
            } else {
                TransactionNetworker.REF_TRANSACTIONS.updateChildValues(
                    [viewModel.model.userId: [viewModel.model.id: transactionJSON]]
                ){_,_ in completed()}
                if viewModel.type == "ORDER" {
                    txnCacher.serializeToCache(viewModel: viewModel)
                }
            }
            
        })
    }
}
