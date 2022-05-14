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
        let dataformatter = DateFormatter()
        dataformatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        return [
            Registration(
                firstName: "Vladimir",
                lastName: "Ladygin",
                emailAdress: "ladygin@lenvoku.ru",
                checkInDate: dataformatter.date(from: "2022/06/07 14:30")!,
                checkOutDate: dataformatter.date(from: "2022/07/03 12:00")!,
                numberOfAdults: 2,
                numberOfChildren: 2,
                roomType: RoomType(id: 0, name: "Two Qeeens", shortName: "2Q", price: 250),
                wifi: false
            ),
            Registration(
                firstName: "Semen",
                lastName: "Mogilevsky",
                emailAdress: "mogila@mail.ru",
                checkInDate: dataformatter.date(from: "2022/06/05 14:30")!,
                checkOutDate: dataformatter.date(from: "2022/06/18 12:00")!,
                numberOfAdults: 1,
                numberOfChildren: 0,
                roomType: RoomType(id: 2, name: "One Prince", shortName: "1P", price: 150),
                wifi: true
            )
        ]
    }
}

