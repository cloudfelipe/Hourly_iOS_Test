//
//  GetFilesInteractor.swift
//  Hourbox
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

protocol GetFilesInteractorType {
    func getFiles(param: FilePath, completion: @escaping DataResultable<Files>)
}

final class GetFilesInteractor: GetFilesInteractorType {
    
    let repository: FilesRepositoryType
    
    init(repository: FilesRepositoryType) {
        self.repository = repository
    }
    
    func getFiles(param: FilePath, completion: @escaping DataResultable<Files>) {
        repository.getFiles(params: FileQueryParam(path: param), completion: completion)
    }
}
