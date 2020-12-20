//
//  FileBrowerContracts.swift
//  Hourbox
//
//  Created by Felipe Correa on 19/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

struct FileViewData {
    let name: String
    let iconName: String
}

extension FileBrowserViewModel {
    struct InputDependencies {
        let coordinator: FileBrowserCoordinatorType
        let path: FilePath
        let getFilesInteractor: GetFilesInteractorType
        let logoutInteractor: LogoutInteractorType
        let down: DownloadFileInteractorType
    }
}

enum DataRequestState {
    case loading
    case error
    case normal
    case downloading
    case downloadedFile
}

extension Entry {
    func dataView() -> FileViewData {
        return FileViewData(name: name, iconName: iconReference)
    }
}
