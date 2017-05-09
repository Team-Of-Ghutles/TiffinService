//
//  CompleteRegistrationViewController.swift
//  TiffinService
//
//  Created by Nitin Jami on 5/9/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CompleteRegistrationViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    var username: String!
    var password: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showAlertOnError(description: String) {
        // show alert popup
        let alert = UIAlertController(title: "Error!", message: description, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: OKAlertButtonHandler)
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Handle OK Button on Alert and dismiss this VC to go back to LoginVC.
    func OKAlertButtonHandler(alert: UIAlertAction) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func validateAndPrepareUserModelToWriteToFirebase() -> [String:String] {
        let usermodel: [String:String] = ["email" : username,
                         "firstname" : firstName.text!,
                         "lastname" : lastName.text!,
                         "phone" : phone.text!,
                         "role" : "customer"
                        ]
        return usermodel
    }
    
    @IBAction func handleButton(_ sender: UIButton) {
        guard let button = sender.titleLabel?.text else {
            print("CompleteRegistrationViewController :: How the fuck did I invoke?")
            return
        }
        
        switch button {
        case "Cancel":
            self.dismiss(animated: true, completion: nil)
        case "Complete Registration":
            FIRAuth.auth()?.createUser(withEmail: username, password: password, completion: { (user, error) in
                if error != nil {
                    self.showAlertOnError(description: (error?.localizedDescription)!)
                } else {
                    let ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!)
                    let usermodel = self.validateAndPrepareUserModelToWriteToFirebase()
                    ref.setValue(usermodel, withCompletionBlock: { (_, _) in
                        UserDefaults.standard.set(usermodel, forKey: "User")
                        // TODO : based on user role -- set the relevant root VC.
                        AppDelegate.LaunchViewController.ClientViewMenuVC.setAsRootviewController(animated: true)
                    })
                }
            })
        default:
            print("CompleteRegistrationViewController :: Unrecognized button")
        }
    }

}
