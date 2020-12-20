//
//  GetThumbnailInteractor.swift
//  Hourbox
//
//  Created by Felipe Correa on 19/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

protocol GetThumbnailInteractorType {
    func get(for file: Entry, completion: @escaping DataResultable<DownloadedFile>)
}

final class GetThumbnailInteractor: GetThumbnailInteractorType {
    
    let repository: FilesRepositoryType
    
    init(repository: FilesRepositoryType) {
        self.repository = repository
    }
    
    func get(for file: Entry, completion: @escaping DataResultable<DownloadedFile>) {
        repository.downloadFile(file: file, completion: completion)
    }
}
