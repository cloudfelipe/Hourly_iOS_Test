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
    func downloadFile(file: Entry, completion: @escaping DataResultable<DownloadedFile>)
}

final class FilesRepository: FilesRepositoryType {
    
    let service: FilesServicesType
    let downloadService: DownloadServiceType
    
    init(service: FilesServicesType, downloadService: DownloadServiceType) {
        self.service = service
        self.downloadService = downloadService
    }
    
    func getFiles(params: FileQueryParam, completion: @escaping DataResultable<Files>) {
        let request = APIFilesRequest(path: params.path.path)
        service.getFiles(params: request) { (result) in
            switch result {
            case .success(let response):
                completion(.success(FilesWrapper().map(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func downloadFile(file: Entry, completion: @escaping DataResultable<DownloadedFile>) {
        downloadService.downloadFile(path: file.pathLower) { (result) in
            switch result {
            case .success(let response):
                completion(.success(DownloadedFile(data: response.data)))
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


public struct DownloadedFile {
    let data: Data
}
