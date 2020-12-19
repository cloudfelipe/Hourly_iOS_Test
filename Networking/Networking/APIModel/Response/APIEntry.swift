//
//  APIEntry.swift
//  Networking
//
//  Created by Felipe Correa on 14/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

public struct APIEntry: APIModelType {
    public let tag: String
    public let name: String
    public let pathLower: String
    public let pathDisplay: String
    public let hashValue: String?
    public let isDownloadable: Bool?
    public let size: Int64?
    public let clientModified: Date?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case tag = ".tag"
        case pathLower = "path_lower"
        case pathDisplay = "path_display"
        case hashValue = "content_hash"
        case isDownloadable = "is_downloadable"
        case size = "size"
        case clientModified = "client_modified"
    }
}
