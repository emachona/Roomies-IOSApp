//
//  AddBillsViewController.swift
//  Roomies
//
//  Created by Emilija Chona on 8/29/23.
//

import UIKit
import FirebaseDatabase

class AddBillsViewController: UIViewController {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthTF: UITextField!
    @IBOutlet weak var sumTF: UITextField!
    var year = Calendar.current.component(.year, from: Date())
    private let ref = Database.database().reference()
   // var roomnum = ""
    var roomId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // roomId = "room\(self.roomnum)"
        yearLabel.text = "\(self.year)"
    }
    
    func addToDatabase(payment: Payment){
        print("Add to Database Bills - roomId \(self.roomId)")
        let query = ref.child("rooms").queryOrderedByKey().queryEqual(toValue: self.roomId)
        query.observeSingleEvent(of: .value) { snapshot in
            guard let roomData = snapshot.value as? [String: [String: Any]],
                  let roomID = roomData.keys.first,
                  var room = roomData[roomID] else {
            print("Room not found")
            return }
            let newBillsPaymentEntry: [String: Any] = ["year": self.year as Any, "month": payment.month as Any, "sum": payment.sum as Any]
            if var billsPayments = room["billsPlan"] as? [[String: Any]] {
                   billsPayments.append(newBillsPaymentEntry)
                   room["billsPlan"] = billsPayments
               } else {
                   room["billsPlan"] = [newBillsPaymentEntry]
               }
            
            self.ref.child("rooms").child(self.roomId).setValue(room) { error, _ in
                if let error = error {
                    print("Error updating room data: \(error)")
                } else {
                    print("Bills payment entry added successfully")
                }
            }
        }
    }

    @IBAction func savePayment(_ sender: Any) {
        let newPayment = Payment()
        newPayment.year = self.year
        newPayment.month = monthTF.text
        let suma:Int? = Int(sumTF.text!)
        newPayment.sum = suma
        paymentsList.append(newPayment)
        addToDatabase(payment:newPayment)
        self.dismiss(animated: true, completion: nil)
    }
    
}
