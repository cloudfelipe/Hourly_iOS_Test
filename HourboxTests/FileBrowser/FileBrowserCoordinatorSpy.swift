//
//  FileBrowserCoordinatorSpy.swift
//  HourboxTests
//
//  Created by Felipe Correa on 20/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

final class FileBrowserCoordinatorSpy: FileBrowserCoordinatorType {
    
    var navigateToDirectoryCallback: ((FilePath) -> Void)?
    var showPDFCallback: ((Data) -> Void)?
    var showImageCallback: ((Data) -> Void)?
    var showFileDetailCallback: ((Entry) -> Void)?
    var showErrorMessageCallback: (()->Void)?
    
    func navigateToDirectory(with path: FilePath) {
        navigateToDirectoryCallback?(path)
    }
    
    func showPDF(with data: Data) {
        showPDFCallback?(data)
    }
    
    func showImage(with data: Data) {
        showImageCallback?(data)
    }
    
    func showFileDetail(with file: Entry) {
        showFileDetailCallback?(file)
    }
    
    func showErrorMessage() {
        showErrorMessageCallback?()
    }
}
