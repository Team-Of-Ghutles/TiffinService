//
//  NetworkService.swift
//  TiffinService
//
//  Created by Nitin Jami on 5/8/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation
import FirebaseDatabase

typealias Item = [String : Any]
typealias Items = [String : Item]

struct NetworkService {
    
    static func fetchItems(from ref: FIRDatabaseReference, with completed: @escaping (Items) -> ()) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            completed(snapshot.value as! Items)
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
    }
    
    static func fetchItem(from ref: FIRDatabaseReference, with completed: @escaping (Item) -> ()) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            completed(snapshot.value as! Item)
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
    }
}
