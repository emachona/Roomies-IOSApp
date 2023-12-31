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
                
                let roomId = "room" + self.roomNumTF.text!
                self.addToTenants(room:roomId, name: self.nameTF.text!)
                
                self.performSegue(withIdentifier: "signupSegue", sender: nil)
                
            }

        }
    }
    
    func addToTenants(room: String, name: String){
        let query = database.child("rooms").queryOrderedByKey().queryEqual(toValue: room)
        query.observeSingleEvent(of: .value) { snapshot in
            guard let roomData = snapshot.value as? [String: [String: Any]],
                  let roomID = roomData.keys.first,
                  var myRoom = roomData[roomID] else {
            print("Room not found")
            return }
            let newTenant = name
            if var tenants = myRoom["tenants"] as? [String] {
                   tenants.append(newTenant)
                   myRoom["tenants"] = tenants
               } else {
                   myRoom["tenants"] = [newTenant]
               }
            
            self.database.child("rooms").child(room).setValue(myRoom) { error, _ in
                if let error = error {
                    print("Error updating room data: \(error)")
                } else {
                    print("Rent payment entry added successfully")
                }
            }
        }
    }
}
