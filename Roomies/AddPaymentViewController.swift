//
//  AddPaymentViewController.swift
//  Roomies
//
//  Created by Emilija Chona on 8/29/23.
//

import UIKit
import FirebaseDatabase

class AddPaymentViewController: UIViewController {

    @IBOutlet weak var monthTF: UITextField!
    @IBOutlet weak var sumTF: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    var year = Calendar.current.component(.year, from: Date())
    private let ref = Database.database().reference()
   // var roomnum = ""
    var roomId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearLabel.text = "\(self.year)"
    }
    
    func addToDatabase(payment: Payment){
        let query = ref.child("rooms").queryOrderedByKey().queryEqual(toValue: self.roomId)
        query.observeSingleEvent(of: .value) { snapshot in
            guard let roomData = snapshot.value as? [String: [String: Any]],
                  let roomID = roomData.keys.first,
                  var room = roomData[roomID] else {
            print("Room not found")
            return }
            let newRentPaymentEntry: [String: Any] = ["year": self.year as Any, "month": payment.month as Any, "sum": payment.sum as Any]
            if var rentPayments = room["rentPlan"] as? [[String: Any]] {
                   rentPayments.append(newRentPaymentEntry)
                   room["rentPlan"] = rentPayments
               } else {
                   room["rentPlan"] = [newRentPaymentEntry]
               }
            
            self.ref.child("rooms").child(self.roomId).setValue(room) { error, _ in
                if let error = error {
                    print("Error updating room data: \(error)")
                } else {
                    print("Rent payment entry added successfully")
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
