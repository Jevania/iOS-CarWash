//
//  CarModel.swift
//  CarWash
//
//  Created by jevania on 07/01/23.
//

import Foundation

enum CarStatus: String {
    case unwashed = "unwashed"
    case washing = "washing"
    case washed = "washed"
}

struct CarModel{
    var id: UUID?
    var name: String?
    var status: CarStatus?
    var isCollect: Bool?
    
    init(id: UUID, name: String, status: CarStatus?, isCollect: Bool){
        self.id = id
        self.name = name
        self.status = status
        self.isCollect = isCollect
    }
}
