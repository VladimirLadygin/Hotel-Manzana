//
//  RegistrationsTableViewController.swift
//  Hotel Manzana
//
//  Created by Владимир Ладыгин on 08.05.2022.
//

import UIKit

class RegistrationsTableViewController: UITableViewController {
    // MARK: properties
    private let dataModel = DataModel()
    private var registrations: [Registration]! {
        didSet {
            // Sort registrations by room id
            registrations = registrations
                .sorted(by: { $0.roomType!.id < $1.roomType!.id})
            // Save registration in DataStorage
            dataModel.saveRegistration(registrations)
            // Grouping registrations by floor to display on the user interface
            sortByFloor()
        }
    }
    
    private var registrFloorToDisplay: [[Registration]] = []
    private var roomType: RoomType?
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registrations = dataModel.loadRegisration() ?? Registration.all
    }
    
    func sortByFloor() {
        registrFloorToDisplay = Array(Dictionary(grouping: registrations) { $0.roomType!.floor }.values)
            .sorted(by: {$0.first!.roomType!.floor < $1.first!.roomType!.floor})
    }
    
    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "editRegistration",
            let selectedPath = tableView.indexPathForSelectedRow,
            let description = segue.destination as? AddRegistrationTableViewController
        else { return }
        
        let registration = registrFloorToDisplay[selectedPath.section][selectedPath.row]
        description.registration = registration
    }
}

extension RegistrationsTableViewController/*: UITableViewDataSource */ {
    
    // Definition of the maximum number of floors to be grouped by floor by section
    override func numberOfSections(in tableView: UITableView) -> Int {
        print(#line, #function, registrFloorToDisplay.count)
        return registrFloorToDisplay.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#line, #function, registrFloorToDisplay[section].count)
        return registrFloorToDisplay[section].count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Floor \(registrFloorToDisplay[section].first!.roomType!.floor)"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        let registrationCell = registrFloorToDisplay[indexPath.section][indexPath.row]
        
        // Declaring service variables
        let firstName = registrationCell.firstName
        let lastName = registrationCell.lastName
        let numberOfAdults = registrationCell.numberOfAdults
        let numberOfChildren = registrationCell.numberOfChildren
        let roomNumber = String(describing: registrationCell.roomType!.id)
        let roomName = String(describing: registrationCell.roomType!.name)
        
        // Declaring icons from SF Symbols library
        let adultsSFImage = NSTextAttachment()
        let childrenSFImage = NSTextAttachment()
        let wifiSFImage = NSTextAttachment()
        
        // Insert SF symbol value to icon variables
        adultsSFImage.image = UIImage(systemName: "person.fill")?.withTintColor(UIColor.label)
        childrenSFImage.image = UIImage(systemName: "person.2.fill")?.withTintColor(UIColor.label)
        wifiSFImage.image = UIImage(systemName: "wifi")?.withTintColor(UIColor.label)
        
        // Generation string line
        let detailString = NSMutableAttributedString(string: "\(roomName) - ")
        detailString.append(NSAttributedString(attachment: adultsSFImage))
        detailString.append(NSAttributedString(string: ":\(numberOfAdults) "))
        detailString.append(NSAttributedString(attachment: childrenSFImage))
        detailString.append(NSAttributedString(string: ":\(numberOfChildren) "))
        if registrationCell.wifi {
            detailString.append(NSAttributedString(attachment: wifiSFImage))
        }
        
        // Send date to cell labels
        cell.textLabel?.text = "\(roomNumber) - \(firstName) \(lastName)"
        cell.detailTextLabel?.attributedText = detailString
        return cell
    }
}

extension RegistrationsTableViewController /*: UITableViewDataSource*/ {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            
        case .delete:
            registrFloorToDisplay[indexPath.section].remove(at: indexPath.row)
            print(registrFloorToDisplay)
            registrations = Array(registrFloorToDisplay.joined())
            dump(registrations)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        case .insert:
            break
        case .none:
            break
        @unknown default:
            break
        }
    }
}


extension RegistrationsTableViewController /*: UITableViewDataSource */ {
    @IBAction func unwind(_ segue: UIStoryboardSegue) {

        guard segue.identifier == "saveSegue" else { return }

        let source = segue.source as! AddRegistrationTableViewController
        let registration = source.registration!
        dump(registration)

//        if let selectedPath = tableView.indexPathForSelectedRow {
//            // Edited cell
//            registrations[selectedPath.row] = registration
//            tableView.reloadRows(at: [selectedPath], with: .automatic)
//        } else {
//            // Added cell
//            let indexPath = IndexPath(row: registrations.count, section: 0)
//            registrations.append(registration)
//            tableView.insertRows(at: [indexPath], with: .automatic)
//        }

        // TODO: - Modify the function for a less resource - intensive insertion of cells. See code above.
        if let selectedPath = tableView.indexPathForSelectedRow {
            // Edited cell
            registrFloorToDisplay[selectedPath.section][selectedPath.row] = registration
            registrations = Array(registrFloorToDisplay.joined())
        } else {
            // Added cell
            registrations.append(registration)
        }
        
        tableView.reloadData()
    }
        
        
}


