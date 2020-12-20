//
//  FilesRepository.swift
//  Hourbox
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation
import Networking

typealias DataResultable<T> = (Result<T, ErrorCategory>) -> Void

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
    
    var displayTitle: String {
        switch self {
        case .root:
            return Texts.General.home
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
    func getThumbnail(file: Entry, completion: @escaping DataResultable<DownloadedFile>)
}

final class FilesRepository: FilesRepositoryType {
    
    let service: FilesServicesType
    let downloadService: DownloadServiceType
    let errorProcessor: ErrorProcessorType
    
    init(service: FilesServicesType, downloadService: DownloadServiceType, errorProcessor: ErrorProcessorType) {
        self.service = service
        self.downloadService = downloadService
        self.errorProcessor = errorProcessor
    }
    
    func getFiles(params: FileQueryParam, completion: @escaping DataResultable<Files>) {
        let request = APIFilesRequest(path: params.path.path)
        service.getFiles(params: request) { [unowned errorProcessor] (result) in
            switch result {
            case .success(let response):
                completion(.success(FilesWrapper().map(response)))
            case .failure(let error):
                debugPrint(error)
                completion(.failure(errorProcessor.process(error: error)))
            }
        }
    }
    
    func downloadFile(file: Entry, completion: @escaping DataResultable<DownloadedFile>) {
        downloadService.downloadFile(path: file.pathLower) { [unowned errorProcessor] (result) in
            switch result {
            case .success(let response):
                completion(.success(DownloadedFile(data: response.data)))
            case .failure(let error):
                debugPrint(error)
                completion(.failure(errorProcessor.process(error: error)))
            }
        }
    }
    
    func getThumbnail(file: Entry, completion: @escaping DataResultable<DownloadedFile>) {
        downloadService.getThumbnail(path: file.pathLower) { [unowned errorProcessor] (result) in
            switch result {
            case .success(let response):
                completion(.success(DownloadedFile(data: response.data)))
            case .failure(let error):
                debugPrint(error)
                completion(.failure(errorProcessor.process(error: error)))
            }
        }
    }
}

class FilesWrapper {
    func map(_ api: APIResponse) -> Files {
        let entries = api.entries.map {
            Entry(tag: EntryTag(rawValue: $0.tag)!,
                  name: $0.name,
                  pathLower: $0.pathLower,
                  pathDisplay: $0.pathDisplay,
                  hashValue: $0.hashValue,
                  isDownloadable: $0.isDownloadable ?? false,
                  size: $0.size ?? nil,
                  modifiedDate: $0.clientModified)
        }
        let files = Files(entries: entries, coursor: api.coursor)
        return files
    }
}

public struct DownloadedFile {
    let data: Data
}
