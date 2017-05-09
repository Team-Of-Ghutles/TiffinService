//
//  File.swift
//  firebase-ios-auth
//
//  Created by Nitin Jami on 2/23/17.
//  Copyright © 2017 Nitin Jami. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase


protocol LoginNetworkDelegate {
    func didFinishNetworkCall(caller: String)
}

class LoginNetworkService {
    
    var delegate: LoginNetworkDelegate?
    var error: Error?
    var user: User?
    
    var signInCompletionHandler: (FIRUser?, Error?) -> () { return
    { (user, error) in
        if error != nil {
            self.error = error
        }
        self.delegate?.didFinishNetworkCall(caller: "signInViaFirebase")
        }
    }
    
    func signInViaFirebase(withEmail username: String, andPassword password: String) {
        FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: signInCompletionHandler)
    }
    
    var signUpCompletionHandler: (FIRUser?, Error?) -> () { return
    { (user, error) in
        if error != nil {
            self.error = error
        }
        self.delegate?.didFinishNetworkCall(caller: "signUpViaFirebase")
        }
    }
    
    func createUserViaFirebase(withEmail username: String, andPassword password: String) {
        FIRAuth.auth()?.createUser(withEmail: username, password: password, completion: signUpCompletionHandler)
    }
    
    func fetchUser() {
        // TODO: Use of forced un-wrap of uid.
        let ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!)
        NetworkService.fetchItem(from: ref) { (item) in
            // TODO: Use of forced un-wrap.
            self.user = User(JSON: item)!
            UserDefaults.standard.set(item, forKey: "User")
            self.delegate?.didFinishNetworkCall(caller: "fetchUser")
        }
    }
}
