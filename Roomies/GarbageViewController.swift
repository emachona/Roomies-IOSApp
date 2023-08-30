//
//  GarbageViewController.swift
//  Roomies
//
//  Created by Emilija Chona on 8/22/23.
//

import UIKit
import FirebaseDatabase

var selectedDate = Date()
//var roomnum = ""

class GarbageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    public var rn = ""
    private let ref = Database.database().reference()
    var roomId = ""
    var totalSquares = [Date]()
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellsView()
        setWeekView()
        //roomnum = self.rn
        roomId = "room\(self.rn)"
        getRoomData()
    }
    
    func setCellsView()
        {
            let width = (collView.frame.size.width - 2) / 8
            let height = (collView.frame.size.height - 2)
            
            let flowLayout = collView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSize(width: width, height: height)
        }
    
    func setWeekView()
    {
        totalSquares.removeAll()
        
        var current = CalendarHelper().sundayForDate(date: selectedDate)
        let nextSunday = CalendarHelper().addDays(date: current, days: 7)
        
        while (current < nextSunday)
        {
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
        }
        
        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
            + " " + CalendarHelper().yearString(date: selectedDate)
        collView.reloadData()
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
        }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
                
            let date = totalSquares[indexPath.item]
            cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))
            
            if(date == selectedDate)
            {
                cell.backgroundColor = UIColor.systemBlue
            }
            else
            {
                cell.backgroundColor = UIColor.white
            }
            
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectedDate = totalSquares[indexPath.item]
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Event().eventsForDate(date: selectedDate).count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as! EventCell
        let event = Event().eventsForDate(date: selectedDate)[indexPath.row]
        //print(event.name + "vo TABELA!!!!")
        cell.nameLabel.text = event.name + " took out the trash " //+ CalendarHelper().timeString(date: event.date)
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
            if let garbagePlan = room["garbagePlan"] as? [[String: Any]] {
                for entry in garbagePlan {
                    if let dateString = entry["date"] as? String,
                       let name = entry["name"] as? String {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yy"
                        if let date = dateFormatter.date(from: dateString) {
                            let event = Event()
                            event.name = name
                            event.date = date
                            eventsList.append(event)
                        }
                    }
                    //print(eventsList[1])
                }
            }
        }
    }
    
    @IBAction func prevWeek(_ sender: Any) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
        setWeekView()
    }
    
    @IBAction func nextWeek(_ sender: Any) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
        setWeekView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddEventSegue" {
            if let destinationVC = segue.destination as? AddEventViewController {
                destinationVC.roomId = self.roomId
            }
        }
    }
    
    @IBAction func toAddEvent(_ sender: Any) {
        performSegue(withIdentifier: "toAddEventSegue", sender: self)
    }
    
    @IBAction func goBack(_ sender: Any) {
        eventsList = []
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}
