//
//  BillsViewController.swift
//  Roomies
//
//  Created by Emilija Chona on 8/28/23.
//

import UIKit
import FirebaseDatabase

class BillsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public var rn = ""
    var year = Calendar.current.component(.year, from: Date())
    private let ref = Database.database().reference()
    var roomId = ""
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var collView: UICollectionView!
    var months : [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellsView()
        setYearView()
        roomId = "room\(self.rn)"
        getRoomData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        collView.reloadData()
    }
    
    func setCellsView()
    {
        let width = (collView.frame.size.width)
        let height = (collView.frame.size.height)
        let flowLayout = collView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func setYearView(){
        yearLabel.text = String(self.year)
        collView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "billsCell", for: indexPath) as! YearlyCalendarCell
        cell.monthLabel.text = months[indexPath.item]
        cell.sumLabel.text = ""
        if let payment = Payment().findPayment(year: self.year, month: cell.monthLabel.text!) {
            cell.sumLabel.text = "\(payment.sum ?? 0) $"
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func getRoomData(){
        let query = ref.child("rooms").queryOrderedByKey().queryEqual(toValue: self.roomId)
        query.observeSingleEvent(of: .value) { snapshot in
            guard let roomData = snapshot.value as? [String: [String: Any]],
                  let roomID = roomData.keys.first,
                  let room = roomData[roomID] else {
            print("Room not found")
            return }
            //print("roomID: " + roomID)
            print("roomData: \(room)")
            if let billsPlan = room["billsPlan"] as? [[String: Any]] {
                for entry in billsPlan {
                    if let yearInt = entry["year"] as? Int,
                       let monthString = entry["month"] as? String,
                        let sumInt = entry["sum"] as? Int{
                            let payment = Payment()
                            payment.year = yearInt
                            payment.month = monthString
                            payment.sum = sumInt
                            paymentsList.append(payment)
                    }
                    print(paymentsList)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddBillsSegue" {
            if let destinationVC = segue.destination as? AddBillsViewController {
                destinationVC.roomId = self.roomId
            }
        }
    }
    
    @IBAction func toAddBills(_ sender: Any) {
        performSegue(withIdentifier: "toAddBillsSegue", sender: self)
    }
    
    @IBAction func prevYear(_ sender: Any) {
        year = year - 1
        setYearView()
    }
    @IBAction func nextYear(_ sender: Any) {
        year = year + 1
        setYearView()
    }
    @IBAction func goBack(_ sender: Any) {
        paymentsList  = []
        self.dismiss(animated: true, completion: nil)
    }
}
