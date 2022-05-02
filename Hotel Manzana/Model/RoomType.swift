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
