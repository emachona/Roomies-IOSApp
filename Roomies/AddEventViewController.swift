//
//  AddEventViewController.swift
//  Roomies
//
//  Created by Emilija Chona on 8/24/23.
//

import UIKit
import FirebaseDatabase

class AddEventViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    private let ref = Database.database().reference()
   // var roomnum = ""
    var roomId = ""
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "dd/MM/YY"
        datePicker.date = selectedDate
       // roomId = "room\(self.roomnum)"
    }
    
    func addToDatabase(event: Event){
        let query = ref.child("rooms").queryOrderedByKey().queryEqual(toValue: self.roomId)
        query.observeSingleEvent(of: .value) { snapshot in
            guard let roomData = snapshot.value as? [String: [String: Any]],
                  let roomID = roomData.keys.first,
                  var room = roomData[roomID] else {
            print("Room not found")
            return }
            let newGarbagePlanEntry: [String: Any] = ["date": self.dateFormatter.string(from: event.date) as Any, "name": event.name as Any]
            if var garbagePlan = room["garbagePlan"] as? [[String: Any]] {
                   garbagePlan.append(newGarbagePlanEntry)
                   room["garbagePlan"] = garbagePlan
               } else {
                   room["garbagePlan"] = [newGarbagePlanEntry]
               }
            
            self.ref.child("rooms").child(self.roomId).setValue(room) { error, _ in
                if let error = error {
                    print("Error updating room data: \(error)")
                } else {
                    print("Garbage plan entry added successfully")
                }
            }
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let newEvent = Event()
        //newEvent.id = eventsList.count
        newEvent.name = nameTF.text
        newEvent.date = datePicker.date
        eventsList.append(newEvent)
        addToDatabase(event:newEvent)
        self.dismiss(animated: true, completion: nil)
    }

}
