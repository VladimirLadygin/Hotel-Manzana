//
//  Registration.swift
//  Hotel Manzana
//
//  Created by Владимир Ладыгин on 02.05.2022.
//

import Foundation
struct Registration {
    var firstName: String
    var lastName: String
    var emailAdress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var roomType: RoomType
    var wifi: Bool
}


