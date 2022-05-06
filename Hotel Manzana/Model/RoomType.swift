//
//  RoomType.swift
//  Hotel Manzana
//
//  Created by Владимир Ладыгин on 02.05.2022.
//

import Foundation

struct RoomType {
    var id: Int
    var name: String
    var shortName: String
    var price: Int
}

extension RoomType: Equatable {
    static func == (lhs: RoomType, rhs: RoomType) -> Bool {
        return lhs.id == rhs.id
    }
}

extension RoomType {
    static var all: [RoomType]{
        return [
        RoomType(id: 0, name: "Two Qeeens", shortName: "2Q", price: 250),
        RoomType(id: 1, name: "One King", shortName: "1K", price: 200),
        RoomType(id: 2, name: "One Prince", shortName: "1P", price: 150)
        ]
    }
}
