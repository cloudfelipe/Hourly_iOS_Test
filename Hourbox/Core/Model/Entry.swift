//
//  Entry.swift
//  Hourbox
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

enum EntryTag: String {
    case folder
    case file
    
    var iconName: String {
        switch self {
        case .file:
            return "file"
        case .folder:
            return "folder"
        }
    }
}

struct Entry {
    let tag: EntryTag
    let name: String
    let pathLower: String
    let pathDisplay: String
    let hashValue: String?
    let isDownloadable: Bool
    let size: Int64?
    let modifiedDate: Date?
    
    var isImage: Bool {
        return name.hasSuffix(".jpg") || name.hasSuffix(".png")
    }
    
    var isPDF: Bool {
        return name.hasSuffix(".pdf")
    }
    
    var iconReference: String {
        if isImage {
            return "img"
        }
        
        if isPDF {
            return "pdf"
        }
        
        return tag.iconName
    }
}

struct Files {
    let entries: [Entry]
    let coursor: String?
}
