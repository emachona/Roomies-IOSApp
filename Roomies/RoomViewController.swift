//
//  RoomViewController.swift
//  Roomies
//
//  Created by Emilija Chona on 8/15/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

//var roomnum = ""

class RoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var vcTitle: UINavigationItem!
    @IBOutlet weak var tableview: UITableView!
    private let ref = Database.database().reference()
    let currentUserID : String = (Auth.auth().currentUser?.uid)!
    var roomNum = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! RoomTableViewCell
        
        var imageName = "roomies.png"
        var labelText = "label"
        if indexPath.row == 0 {
            imageName = "garbage.png"
            labelText = "Garbage"
        }else if indexPath.row == 1 {
            imageName = "cleaning.png"
            labelText = "Cleaning"
        }else if indexPath.row == 2 {
            imageName = "groceries.png"
            labelText = "Groceries"
        }else if indexPath.row == 3 {
            imageName = "bills.png"
            labelText = "Bills"
        }else if indexPath.row == 4 {
            imageName = "rent.png"
            labelText = "Rent"
        }
                
        cell.configure(image: UIImage(named: imageName)!, text: labelText)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier:"garbageView")as? GarbageViewController
            vc?.rn = self.roomNum
            vc!.modalPresentationStyle = .overFullScreen
            present(vc!, animated: true)
//            navigationController?.pushViewController(vc!, animated: true)
        }else if indexPath.row == 1{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier:"cleaningView")as? CleaningViewController
            vc?.rn = self.roomNum
            vc!.modalPresentationStyle = .overFullScreen
            present(vc!, animated: true)
        }else if indexPath.row == 2{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier:"groceriesView")as? GroceriesViewController
            vc?.rn = self.roomNum
            vc!.modalPresentationStyle = .overFullScreen
            present(vc!, animated: true)
        }else if indexPath.row == 3{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier:"billsView")as? BillsViewController
            vc?.rn = self.roomNum
            vc!.modalPresentationStyle = .overFullScreen
            present(vc!, animated: true)
        }else if indexPath.row == 4{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier:"rentView")as? RentViewController
            vc?.rn = self.roomNum
            vc!.modalPresentationStyle = .overFullScreen
            present(vc!, animated: true)
        }
    }
    
    func getData(){
        ref.child("users").queryOrderedByKey().queryEqual(toValue: self.currentUserID).observeSingleEvent(of: .value) { (snapshot) in
            // Check if the snapshot has any children
            if snapshot.exists() {
                for childSnapshot in snapshot.children {
                    if let userSnapshot = childSnapshot as? DataSnapshot {
                        if let userData = userSnapshot.value as? [String: Any] {
                            //print("User data: \(userData)")
                            
                            self.roomNum = (userData["roomNumber"] as? String)!
                            self.vcTitle.title = "Room Number " + self.roomNum
                            print ("Room Number: \(self.roomNum)")
                        }
                    }
                }
            } else {
                print("User not found")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        //roomnum = self.roomNum
        self.tableview.dataSource = self
        self.tableview.delegate = self
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        try? Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier:"LoginVC")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}
