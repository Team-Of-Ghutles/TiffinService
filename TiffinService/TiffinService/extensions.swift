//
//  extensions.swift
//  TiffinService
//
//  Created by Nitin Jami on 5/8/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth

extension UIButton {
    
    func logout() {
        try! FIRAuth.auth()?.signOut()
        UserDefaults.standard.removeObject(forKey: "User")
        AppDelegate.LaunchViewController.Login.setAsRootviewController(animated: true)
    }
}
