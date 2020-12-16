//
//  APIFilesRequest.swift
//  Networking
//
//  Created by Felipe Correa on 14/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

public struct APIFilesRequest: APIModelType {
    
    let path: String
    let isRecursive: Bool
    let includeMediaInfo: Bool
    let includeDeleted: Bool
    let includeHasExplicitSharedMembers: Bool
    let includeMountedFolders: Bool
    let includeNonDownloadableFiles: Bool
    
    enum CodingKeys: String, CodingKey {
        case path = "path"
        case isRecursive = "recursive"
        case includeMediaInfo = "include_media_info"
        case includeDeleted = "include_deleted"
        case includeHasExplicitSharedMembers = "include_has_explicit_shared_members"
        case includeMountedFolders = "include_mounted_folders"
        case includeNonDownloadableFiles = "include_non_downloadable_files"
    }
    
    public init(path: String, isRecursive: Bool, includeMediaInfo: Bool = true, includeDeleted: Bool = true, includeHasExplicitSharedMembers: Bool = true, includeMountedFolders: Bool = true, includeNonDownloadableFiles: Bool = true) {
        self.path = path
        self.isRecursive = isRecursive
        self.includeMediaInfo = includeMediaInfo
        self.includeDeleted = includeDeleted
        self.includeHasExplicitSharedMembers = includeHasExplicitSharedMembers
        self.includeMountedFolders = includeMountedFolders
        self.includeNonDownloadableFiles = includeNonDownloadableFiles
    }
}
