//
//  FilesRepository.swift
//  Hourbox
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation
import Networking

typealias DataResultable<T> = (Result<T, Error>) -> Void

enum FilePath {
    case root
    case custom(String)
    
    var path: String {
        switch self {
        case .root:
            return ""
        case .custom(let customPath):
            return customPath
        }
    }
}

struct FileQueryParam {
    let path: FilePath
    let includeNonDownloadables: Bool = true
}

protocol FilesRepositoryType {
    func getFiles(params: FileQueryParam, completion: @escaping DataResultable<Files>)
}

final class FilesRepository: FilesRepositoryType {
    
    let service: FilesServicesType
    
    init(service: FilesServicesType) {
        self.service = service
    }
    
    func getFiles(params: FileQueryParam, completion: @escaping DataResultable<Files>) {
        let request = APIFilesRequest(path: params.path.path)
//
//        let entry = [Entry(tag: .file, name: "sample.png", pathLower: "sample", id: "123"),
//                     Entry(tag: .folder, name: "My documents", pathLower: "Path", id: "")]
//        let file = Files(entries: entry, coursor: nil)
//        completion(.success(file))
        
        service.getFiles(params: request) { (result) in
            switch result {
            case .success(let response):
                completion(.success(FilesWrapper().map(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}


class FilesWrapper {
    func map(_ api: APIResponse) -> Files {
        let entries = api.entries.map { Entry(tag: EntryTag(rawValue: $0.tag) ?? EntryTag.folder,
                                              name: $0.name,
                                              pathLower: $0.pathLower,
                                              id: "$0.id") }
        let files = Files(entries: entries, coursor: api.coursor)
        return files
    }
}
