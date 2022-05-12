//
//  RegistrationsTableViewController.swift
//  Hotel Manzana
//
//  Created by Владимир Ладыгин on 08.05.2022.
//

import UIKit

class RegistrationsTableViewController: UITableViewController {
    // MARK: properties
    let dataModel = DataModel()
    var registrations: [Registration]! {
        didSet {
            dataModel.saveRegistration(registrations)
        }
    }
    var roomType: RoomType?
    override func viewDidLoad() {
        super.viewDidLoad()
        registrations = dataModel.loadRegisration() ?? Registration.all
        
    }
    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "editRegistration",
            let selectedPath = tableView.indexPathForSelectedRow,
            let description = segue.destination as? AddRegistrationTableViewController
        else { return }
        
        let registration = registrations[selectedPath.row]
        description.registration = registration
    }
}

extension RegistrationsTableViewController/*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        let registrationCell = registrations[indexPath.row]
        
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

extension RegistrationsTableViewController {
    @IBAction func unwind(_ segue: UIStoryboardSegue) {

        guard segue.identifier == "saveSegue" else { return }

        let source = segue.source as! AddRegistrationTableViewController
        let registration = source.registration!
        dump(registration)

        if let selectedPath = tableView.indexPathForSelectedRow {
            // Edited cell
            registrations[selectedPath.row] = registration
            tableView.reloadRows(at: [selectedPath], with: .automatic)
        } else {
            // Added cell
            let indexPath = IndexPath(row: registrations.count, section: 0)
            registrations.append(registration)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}
