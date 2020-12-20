//
//  FileInformationContracts.swift
//  Hourbox
//
//  Created by Felipe Correa on 19/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

extension FileInformationDetailViewModel {
    struct InputDependencies {
        let file: Entry
        let getThumbnailInteractor: GetThumbnailInteractorType!
    }
}

struct FileInformation {
    let title: String
    let value: String?
}
