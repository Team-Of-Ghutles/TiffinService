//
//  LoginViewController.swift
//  firebase-ios-auth
//
//  Created by Nitin Jami on 3/5/17.
//  Copyright © 2017 Nitin Jami. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, LoginViewModelDelegate {
    
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.appTitle.text = "Firebase Auth Testing"
        loginViewModel.delegate = self
        
        // conform to textfield delegate methods
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleSignIn(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else {
            print("LoginViewController :: How the fuck did I invoke?")
            return
        }
        
        switch buttonTitle {
        case "Sign In":
            loginViewModel.signinButtonPressed()
        default:
            print("LoginViewController :: Unrecognized button")
        }
    }
    
    // MARK: - LoginViewModel Delegate Methods
    
    func moveToProfileView() {
        // segue to profile view
        switch loginViewModel.getUserRole() {
        case "customer":
            AppDelegate.LaunchViewController.ClientViewMenuVC.setAsRootviewController(animated: true)
        case "vendor":
            AppDelegate.LaunchViewController.VendorBalance.setAsRootviewController(animated: true)
        default:
            showAlertOnError(description: "Error with User Role")
        }
    }
    
    func showAlertOnError(description: String) {
        // show alert popup
        let alert = UIAlertController(title: "Error!", message: description, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - TextField Delegate Methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case usernameTextField:
            loginViewModel.validateTextFields(textValue: textField.text!, fieldType: "uname")
        case passwordTextField:
            loginViewModel.validateTextFields(textValue: textField.text!, fieldType: "pword")
        default:
            showAlertOnError(description: "textFieldDidEndEditing -- Invalid text field.")
        }
    }
    
     // MARK: - Navigation
     
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !loginViewModel.textFieldsValid {
            showAlertOnError(description: "Username and/or Password fields should not be empty")
            return false
        }
        return true
    }
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        let destVC = segue.destination as! CompleteRegistrationViewController
        
        destVC.username = loginViewModel.usernameTextValue
        destVC.password = loginViewModel.passwordTextValue
     }
    
}
