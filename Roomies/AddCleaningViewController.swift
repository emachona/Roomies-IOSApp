//
//  AddCleaningViewController.swift
//  Roomies
//
//  Created by Emilija Chona on 8/27/23.
//

import UIKit
import FirebaseDatabase

class AddCleaningViewController: UIViewController {

    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    private let ref = Database.database().reference()
    var roomId = "room\(roomnum)"
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd/MM/YY"
        datePicker.date = selectedDate
        print(roomnum)
    }

    func addToDatabase(event: Event){
        let query = ref.child("rooms").queryOrderedByKey().queryEqual(toValue: self.roomId)
        query.observeSingleEvent(of: .value) { snapshot in
            guard let roomData = snapshot.value as? [String: [String: Any]],
                  let roomID = roomData.keys.first,
                  var room = roomData[roomID] else {
            print("Room not found")
            return }
            let newCleaningPlanEntry: [String: Any] = ["date": self.dateFormatter.string(from: event.date) as Any, "name": event.name as Any]
            if var cleaningPlan = room["cleaningPlan"] as? [[String: Any]] {
                   cleaningPlan.append(newCleaningPlanEntry)
                   room["cleaningPlan"] = cleaningPlan
               } else {
                   room["cleaningPlan"] = [newCleaningPlanEntry]
               }
            
            self.ref.child("rooms").child("room"+roomnum).setValue(room) { error, _ in
                if let error = error {
                    print("Error updating room data: \(error)")
                } else {
                    print("Cleaning plan entry added successfully")
                }
            }
        }
    }
    
    @IBAction func saveEntry(_ sender: Any) {
        let newEvent = Event()
        newEvent.name = nameTF.text
        newEvent.date = datePicker.date
        eventsList.append(newEvent)
        addToDatabase(event:newEvent)
        self.dismiss(animated: true, completion: nil)
    }
    
}
