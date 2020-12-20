//
//  InteractorStubs.swift
//  HourboxTests
//
//  Created by Felipe Correa on 20/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

final class GetFilesInteractorStub: GetFilesInteractorType {
    
    var responseHandler: ((FilePath, DataResultable<Files>) -> Void)?
    
    func getFiles(param: FilePath, completion: @escaping DataResultable<Files>) {
        responseHandler?(param, completion)
    }
}

final class LogoutInteractorStub: LogoutInteractorType {
    
    var responseHandler: (() -> Void)?
    
    func logout() {
        responseHandler?()
    }
}

final class DownloadFileInteractorStub: DownloadFileInteractorType {
    
    var responseHandler: ((Entry, DataResultable<DownloadedFile>) -> Void)?
    
    func downloadFile(file: Entry, completion: @escaping DataResultable<DownloadedFile>) {
        responseHandler?(file, completion)
    }
}
