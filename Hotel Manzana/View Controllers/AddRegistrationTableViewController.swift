
//  AddRegistrationTableViewController.swift
//  Hotel Manzana
//
//  Created by Владимир Ладыгин on 02.05.2022.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    @IBOutlet var numberOfAdulrsLabel: UILabel!
    @IBOutlet var numberOfAdultsStepper: UIStepper!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    @IBOutlet var wifiSwitch: UISwitch!
    @IBOutlet var roomTypeLabel: UILabel!
    @IBOutlet var navigationTitle: UINavigationItem!
    
    
    
    
    // MARK: - Properities
    let checkInDateLabelIndexPath = IndexPath(row: 0, section: 1)
    let checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDateLabelIndexPath = IndexPath(row: 2, section: 1)
    let checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    
    
    var isCheckInDatePickerShown: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    var isCheckOutDatePickerShown: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
        }
    }
    
    var roomType: RoomType?
    var registration: Registration?
    private let midnightToday = Calendar.current.startOfDay(for: Date())
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInDatePicker.minimumDate = midnightToday
        checkOutDatePicker.date = midnightToday
        updateDataViews()
        updateNumberOfGuests()
        updateRoomType()
        editMode()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectRoomType" {
            let destination = segue.destination as! SelectRoomTypeTableViewController
            destination.delegate = self
            destination.roomType = roomType
        } else if segue.identifier == "saveSegue"{
            saveRegistration()
        }
    }
    
    
    // MARK: - UI Methods
    // Loading data into fields when editing data
    func editMode () {
        if let registration = registration {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.locale = Locale.current
            
            navigationTitle.title = "Edit registration"
            firstNameTextField.text = registration.firstName
            lastNameTextField.text = registration.lastName
            emailTextField.text = registration.emailAdress
            checkInDateLabel.text = dateFormatter.string(from: registration.checkInDate)
            checkInDatePicker.minimumDate = registration.checkInDate < midnightToday ? registration.checkInDate : midnightToday
            checkOutDateLabel.text = dateFormatter.string(from: registration.checkOutDate)
            checkOutDatePicker.minimumDate = registration.checkInDate.addingTimeInterval(60 * 60 * 24)
            numberOfAdultsStepper.value = Double(registration.numberOfAdults)
            numberOfAdulrsLabel.text = String(registration.numberOfAdults)
            numberOfChildrenStepper.value = Double(registration.numberOfChildren)
            numberOfChildrenLabel.text = String(registration.numberOfChildren)
            wifiSwitch.isOn = registration.wifi
            roomTypeLabel.text = "\(registration.roomType!.id) - \(registration.roomType!.name)"
            roomType = registration.roomType
        }
    }
    
    // Wtiting data from an input form into a variable to send to the database
    func saveRegistration() {
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let wifi = wifiSwitch.isOn
        
        registration = Registration(
            firstName: firstName,
            lastName: lastName,
            emailAdress: email,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            numberOfAdults: numberOfAdults,
            numberOfChildren: numberOfChildren,
            roomType: roomType,
            wifi: wifi
        )
    }
    
    // Updating the date display in the checkout and checkout labels
    func updateDataViews() {
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(60 * 60 * 24)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    // Updating the data of a guest data in adult and child labels
    func updateNumberOfGuests() {
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        numberOfAdulrsLabel.text = "\(numberOfAdults)"
        numberOfChildrenLabel.text = "\(numberOfChildren)"
    }
    
    // Updating the room information to be displayed on the label
    func updateRoomType()  {
        if let roomType = roomType {
            roomTypeLabel.text = "\(roomType.id) - \(roomType.name)"
            
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    
    // MARK: - Actions
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDataViews()
    }
    
    
    @IBAction func doneBarButtonTapped (_ sender: UIBarButtonItem) {
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
}

// MARK: UITableViewDataSource

extension AddRegistrationTableViewController /*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerIndexPath:
            return isCheckInDatePickerShown ? UITableView.automaticDimension : 0
        case checkOutDatePickerIndexPath:
            return isCheckOutDatePickerShown ? UITableView.automaticDimension : 0
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: UITableViewDelegate
extension AddRegistrationTableViewController /*: UITableViewDelegate*/ {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case checkInDateLabelIndexPath:
            isCheckInDatePickerShown.toggle()
            isCheckOutDatePickerShown = false
        case checkOutDateLabelIndexPath:
            isCheckOutDatePickerShown.toggle()
            isCheckInDatePickerShown = false
        default:
            return
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

// MARK: - SelectRoomTypeTableViewControllerProtocol
extension AddRegistrationTableViewController: SelectRoomTypeTableViewControllerProtocol {
    func didSelect(roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
}

