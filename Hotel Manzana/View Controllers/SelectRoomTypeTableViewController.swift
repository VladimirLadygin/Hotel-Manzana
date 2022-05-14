//
//  SelectRoomTypeTableViewController.swift
//  Hotel Manzana
//
//  Created by Владимир Ладыгин on 03.05.2022.
//

import UIKit

class SelectRoomTypeTableViewController: UITableViewController {
    
    // MARK: - Properities
    private let dataModel = DataModel()
    var delegate: SelectRoomTypeTableViewControllerProtocol?
    var roomType: RoomType?
    var currentRoomType: RoomType?
    private var emptyRoomsbyFloor: [[RoomType]] = []
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let midnightToday = Calendar.current.startOfDay(for: Date())
        
        // Creating a list of rooms that are busy today
        let busyRmms = dataModel.loadRegisration()!
            .filter({ $0.checkInDate...$0.checkOutDate ~= midnightToday})
            .map { $0.roomType! }
        dump(dataModel.loadRegisration()!.filter({ $0.checkInDate...$0.checkOutDate ~= midnightToday}))
        
        // Filtering list of rooms that are free today
        var emptyRooms = RoomType.all.filter({ !busyRmms.contains($0)})
//        dump(emptyRooms)
        
        // Adding an already - occupied room to the vacancy list
        if let roomType = roomType {
            emptyRooms.append(roomType)
            emptyRooms = emptyRooms.sorted(by: { $0.id < $1.id })
            
            // Creating list of rooms which available today with sorted by floor
            emptyRoomsbyFloor = Array(Dictionary(grouping: emptyRooms) { $0.floor}.values)
                .sorted(by: { $0.first!.floor < $1.first!.floor})
        }
    }
}

//  MARK: - UITableViewDataSource
extension SelectRoomTypeTableViewController/*: UITableViewDataSource */ {
    
    // Definition of the maximum number of floors to ba grouped by floor in section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return emptyRoomsbyFloor.count
    }
    
    //  Determining the number of registrations per floor to displwy in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emptyRoomsbyFloor[section].count
    }
    
    // Getting the section name
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Floor \(String(emptyRoomsbyFloor[section].first!.floor))"
    }
    
    // Adding content to the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Declaring Table ViewCell value
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        
        // Get room value from rooms array
        let roomType = emptyRoomsbyFloor[indexPath.section][indexPath.row]
        
        // Adding checkmark indicator to cell
        cell.accessoryType = roomType == self.roomType ? .checkmark : .none
        
        // Send date to cell labels
        cell.textLabel?.text = "\(roomType.id) - \(roomType.name)"
        cell.detailTextLabel?.text = "$ \(roomType.price)"
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SelectRoomTypeTableViewController /*: UITableViewDelegate */ {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        roomType = emptyRoomsbyFloor[indexPath.section][indexPath.row]
        delegate?.didSelect(roomType: roomType!)
        tableView.reloadData()
    }
}

