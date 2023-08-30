//
//  AddItemsViewController.swift
//  Roomies
//
//  Created by Emilija Chona on 8/29/23.
//

import UIKit
import FirebaseDatabase

class AddItemsViewController: UIViewController {

    @IBOutlet weak var item1TF: UITextField!
    @IBOutlet weak var item2TF: UITextField!
    @IBOutlet weak var item3TF: UITextField!
    @IBOutlet weak var item4TF: UITextField!
    @IBOutlet weak var item5TF: UITextField!
    private let ref = Database.database().reference()
    //var roomnum = ""
    var roomId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //roomId = "room\(roomnum)"
        print("AddItems \(self.roomId)")
    }
    
    func addToDatabase(items: [Item]){
        let query = ref.child("rooms").queryOrderedByKey().queryEqual(toValue: self.roomId)
        query.observeSingleEvent(of: .value) { snapshot in
            guard let roomData = snapshot.value as? [String: [String: Any]],
                  let roomID = roomData.keys.first,
                  var room = roomData[roomID] else {
            print("Room not found - AddItems")
            return }
            var newItemEntries: [[String: Any]] = []
            for item in items {
                    let newItemEntry: [String: Any] = ["item": item.product as String, "status": item.status as Bool]
                    newItemEntries.append(newItemEntry)
                }
                
            if var groceriesItems = room["groceries"] as? [[String: Any]] {
                groceriesItems.append(contentsOf: newItemEntries)
                room["groceries"] = groceriesItems
            } else {
                room["groceries"] = newItemEntries
            }
            
            self.ref.child("rooms").child(self.roomId).setValue(room) { error, _ in
                if let error = error {
                    print("Error updating room data: \(error)")
                } else {
                    print("Groceries item added successfully")
                }
            }
        }
    }

    @IBAction func addItems(_ sender: Any) {
        var newItems = [Item]()
        
        let newItem1 = Item()
        newItem1.product = item1TF.text
        newItem1.status = true
        newItems.append(newItem1)
        itemsList.append(newItem1)
        
        if item2TF.text != "" {
            let newItem2 = Item()
            newItem2.product = item2TF.text
            newItem2.status = true
            newItems.append(newItem2)
            itemsList.append(newItem2)
        }
        if item3TF.text != "" {
            let newItem3 = Item()
            newItem3.product = item3TF.text
            newItem3.status = true
            newItems.append(newItem3)
            itemsList.append(newItem3)
        }
        if item4TF.text != "" {
            let newItem4 = Item()
            newItem4.product = item4TF.text
            newItem4.status = true
            newItems.append(newItem4)
            itemsList.append(newItem4)
        }
        if item5TF.text != "" {
            let newItem5 = Item()
            newItem5.product = item5TF.text
            newItem5.status = true
            newItems.append(newItem5)
            itemsList.append(newItem5)
        }
        
        addToDatabase(items: newItems)
        self.dismiss(animated: true, completion: nil)
    }
}
