//
//  LoginViewController.swift
//  Roomies
//
//  Created by Emilija Chona on 8/6/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var toSignUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignup", sender: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        validateFields()
    }
    func validateFields(){
        if emailTF.text?.isEmpty == true {
            print("Email field is required!")
            return
        }
        
        if passwordTF.text?.isEmpty == true {
            print("Password field is required!")
            return
        }
        
        login()
    }
    
    func login(){
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { (user, error) in
            if error != nil {
                print("Error logging in")
                //displayAlert(title: "Error", message: error!.localizedDescription)
            }
            else {
                print("Log In Successful")
//                if user?.user.displayName == "Roomate" {
//                    print("Roomate")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
//                }
            }
        }
    }
    

}
