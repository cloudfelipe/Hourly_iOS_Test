//
//  DownloadFileInteractor.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

protocol DownloadFileInteractorType {
    func downloadFile(file: Entry, completion: @escaping DataResultable<DownloadedFile>)
}

final class DownloadFileInteractor: DownloadFileInteractorType {
    
    let repository: FilesRepositoryType
    
    init(repository: FilesRepositoryType) {
        self.repository = repository
    }
    
    func downloadFile(file: Entry, completion: @escaping DataResultable<DownloadedFile>) {
        repository.downloadFile(file: file, completion: completion)
    }
}
