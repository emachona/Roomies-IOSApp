//
//  SignUpViewController.swift
//  Roomies
//
//  Created by Emilija Chona on 8/7/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    private let database = Database.database().reference()
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var occupationTF: UITextField!
    @IBOutlet weak var roomNumTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    let currentDateTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        if usernameTF.text?.isEmpty == true {
            print("Email field can't be empty!")
            //displayAlert(title: "Missing Information", message: "You must provide email!")
            return
        }
        
        if passwordTF.text?.isEmpty == true {
            print("Password field can't be empty!")
            //displayAlert(title: "Missing Information", message: "You must provide password!")
            return
        }
        
        signUp()
    }
    
    func signUp(){
        Auth.auth().createUser(withEmail: usernameTF.text!, password: passwordTF.text!){
            (user, error) in  if error != nil{
                print("Error \(error?.localizedDescription)")
                //self.displayAlert(title: "Error", message: error!.localizedDescription)
                return
            }
            else{
                print("Sign Up Success!")
                let object : [String:Any] = [
                    "name" : self.nameTF.text as Any,
                    "age" : self.ageTF.text as Any,
                    "phone" : self.phoneTF.text as Any,
                    "occupation" : self.occupationTF.text as Any,
                    "roomNumber" : self.roomNumTF.text as Any,
                    "joinDate" : self.currentDateTime.description as Any,
                    "username" : self.usernameTF.text as Any,
                    "password" : self.passwordTF.text as Any,
                ]
                let userID : String = (Auth.auth().currentUser?.uid)!
                print("Current user ID is" + userID)
                self.database.child("users").child(userID).setValue(object)
                print("Object written!")
                
//                    let req = Auth.auth().currentUser?.createProfileChangeRequest();
//                    req?.displayName = self.roomNumTF.text
//                    req?.commitChanges(completion: nil)
                self.performSegue(withIdentifier: "signupSegue", sender: nil)
                
            }

        }
    }
}
