//
//  GroceriesViewController.swift
//  Roomies
//
//  Created by Emilija Chona on 8/29/23.
//

import UIKit
import FirebaseDatabase

class GroceriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var rn = ""
    private let ref = Database.database().reference()
    var roomId = ""
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomId = "room\(self.rn)"
        getRoomData()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! EventCell
//        if itemsList[indexPath.row].status{
            cell.nameLabel.text = itemsList[indexPath.row].product
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemsList[indexPath.row].status.toggle()
        changeStatusDB(item: itemsList[indexPath.row])
        itemsList.remove(at: indexPath.row)

        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func changeStatusDB(item: Item) {
        let query = ref.child("rooms").queryOrderedByKey().queryEqual(toValue: self.roomId)
        query.observeSingleEvent(of: .value) { snapshot in
            guard let roomData = snapshot.value as? [String: [String: Any]],
                  let roomID = roomData.keys.first,
                  var room = roomData[roomID] else {
            print("Room not found - changeStatusDB")
            return }
//            print("roomData: \(room)")
            if var groceries = room["groceries"] as? [[String: Any]] {
                for (index, entry) in groceries.enumerated() {
                    if let productName = entry["item"] as? String,
                       productName == item.product
                    {
                        if var status = entry["status"] as? Bool, status == true {
                            status = false
                            groceries[index]["status"] = status
                            room["groceries"] = groceries
                            self.ref.child("rooms").child(self.roomId).setValue(room)
                        }
                        break
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    func getRoomData(){
        let query = ref.child("rooms").queryOrderedByKey().queryEqual(toValue: self.roomId)
        query.observeSingleEvent(of: .value) { snapshot in
            guard let roomData = snapshot.value as? [String: [String: Any]],
                  let roomID = roomData.keys.first,
                  let room = roomData[roomID] else {
            print("Room not found - GroceriesVC")
            return }
            print("roomData: \(room)")
            if let groceries = room["groceries"] as? [[String: Any]] {
                for entry in groceries {
                    if let productName = entry["item"] as? String,
                       let status = entry["status"] as? Bool,
                       status == true
                    {
                        let item = Item()
                        item.product = productName
                        item.status = status
                        itemsList.append(item)
                    }
                }
            }
        }
//        print(itemsList[0].product!)
//        print(itemsList[0].status as Any)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddItemSegue" {
            if let destinationVC = segue.destination as? AddItemsViewController {
                destinationVC.roomId = self.roomId
            }
        }
    }
    
    @IBAction func toAddItems(_ sender: Any) {
        performSegue(withIdentifier: "goToAddItemSegue", sender: self)
    }
    
    @IBAction func goBack(_ sender: Any) {
        itemsList = []
        self.dismiss(animated: true, completion: nil)
    }
    
}
