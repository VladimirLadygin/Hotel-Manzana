//
//  Registration.swift
//  Hotel Manzana
//
//  Created by Владимир Ладыгин on 02.05.2022.
//

import Foundation
struct Registration: Codable {
    var firstName: String
    var lastName: String
    var emailAdress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var roomType: RoomType?
    var wifi: Bool
}

extension Registration {
    static var all: [Registration] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = today.addingTimeInterval(60 * 60 * 24)
        return [
            Registration(
                firstName: "Arseniy",
                lastName: "Petrov",
                emailAdress: "petrovbars@ya.com",
                checkInDate: today,
                checkOutDate: tomorrow,
                numberOfAdults: 1,
                numberOfChildren: 0,
                roomType: RoomType(
                    id: 104,
                    name: "One Queen",
                    shortName: "1Q",
                    price: 129
                ),
                wifi: true
            ),
            Registration(
                firstName: "Valentine ",
                lastName: "Petukhov",
                emailAdress: "ads@wilsa.com",
                checkInDate: today,
                checkOutDate: tomorrow,
                numberOfAdults: 2,
                numberOfChildren: 2,
                roomType: RoomType(
                    id: 203,
                    name: "Two Queens",
                    shortName: "2Q",
                    price: 179),
                wifi: true
            ),
            Registration(
                firstName: "Jhon",
                lastName: "Appleseed",
                emailAdress: "jhon@appleseed.com",
                checkInDate: today,
                checkOutDate: tomorrow,
                numberOfAdults: 1,
                numberOfChildren: 0,
                roomType: RoomType(
                    id: 204,
                    name: "Two Queens",
                    shortName: "2Q",
                    price: 179),
                wifi: true
            ),
            Registration(
                firstName: "Vuasya",
                lastName: "Pumpkin",
                emailAdress: "vyasya@pumpkon.ru",
                checkInDate: today,
                checkOutDate: tomorrow,
                numberOfAdults: 2,
                numberOfChildren: 2,
                roomType: RoomType(
                    id: 205,
                    name: "Two Queens",
                    shortName: "2Q",
                    price: 179),
                wifi: false
            ),
            Registration(
                firstName: "Takuya",
                lastName: "Matsuyama",
                emailAdress: "info@inkdrop.app",
                checkInDate: today,
                checkOutDate: tomorrow,
                numberOfAdults: 1,
                numberOfChildren: 0,
                roomType: RoomType(
                    id: 306,
                    name: "One King",
                    shortName: "K", price: 209
                ),
                wifi: true),
            Registration(
                firstName: "Pasha",
                lastName: "Durov ",
                emailAdress: "durov@telegram.com",
                checkInDate: today,
                checkOutDate: tomorrow,
                numberOfAdults: 1,
                numberOfChildren: 0,
                roomType: RoomType(
                    id: 402,
                    name: "Penthouse Suite",
                    shortName: "PHS",
                    price: 309),
                wifi: false
            )
        ]
    }
}

