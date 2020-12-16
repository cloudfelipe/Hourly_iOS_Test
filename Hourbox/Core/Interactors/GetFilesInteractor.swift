//
//  GetFilesInteractor.swift
//  Hourbox
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

protocol GetHomeFilesInteractorType {
    func getFiles(completion: @escaping DataResultable<Files>)
}

final class GetHomeFilesInteractor: GetHomeFilesInteractorType {
    
    let repository: FilesRepositoryType
    
    init(repository: FilesRepositoryType) {
        self.repository = repository
    }
    
    func getFiles(completion: @escaping DataResultable<Files>) {
        let params = FileQueryParam(path: .home)
        repository.getFiles(params: params, completion: completion)
    }
}
