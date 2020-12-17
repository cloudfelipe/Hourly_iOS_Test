//
//  Entry.swift
//  Hourbox
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

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
    let id: String
    
    var isImage: Bool {
        return name.hasSuffix(".jpg") || name.hasSuffix(".png")
    }
    
    var isPDF: Bool {
        return name.hasSuffix(".pdf")
    }
}

struct Files {
    let entries: [Entry]
    let coursor: String?
}
