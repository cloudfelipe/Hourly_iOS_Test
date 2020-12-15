//
//  APIEntry.swift
//  Networking
//
//  Created by Felipe Correa on 14/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

public struct APIEntry: APIModelType {
    let tag: String
    let name: String
    let pathLower: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case tag = "tag"
        case pathLower = "path_lower"
    }
}