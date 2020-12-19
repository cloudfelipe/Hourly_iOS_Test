//
//  FileInformationDetailViewModel.swift
//  Hourbox
//
//  Created by Felipe Correa on 18/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation
import RxSwift
import SwifterSwift

protocol FileInformationDetailViewModelType: BaseViewModelType {
    var informationDataView: Observable<[FileInformation]> { get }
}

final class FileInformationDetailViewModel: BaseViewModel, FileInformationDetailViewModelType {
    
    var informationDataView: Observable<[FileInformation]> {
        informationData.asObserver()
    }
    
    let dependencies: InputDependencies
    private var informationData = PublishSubject<[FileInformation]>()
    
    init(dependencies: InputDependencies) {
        self.dependencies = dependencies
        super.init()
        
    }
    
    override func viewAppearStateDidChange(_ state: ViewAppearState) {
        switch state {
        case .willAppear:
            prepareFileInformation(with: dependencies.file)
        default:
            break
        }
    }
    
    private func prepareFileInformation(with file: Entry) {
        let info = [FileInformation(title: "Name:", value: file.name),
                    FileInformation(title: "Type:", value: file.tag.rawValue),
                    FileInformation(title: "Downloadable:", value: file.isDownloadable.string),
                    FileInformation(title: "Size:", value: file.size?.string),
                    FileInformation(title: "Last modified:", value: file.modifiedDate?.string(withFormat: "dd/MM/yyyy HH:mm")),
                    FileInformation(title: "Full Path:", value: file.pathDisplay),
                    FileInformation(title: "Hash value:", value: file.hashValue ?? "")]
        
        informationData.onNext(info.filter { $0.value != nil })
    }
}

extension FileInformationDetailViewModel {
    struct InputDependencies {
        let file: Entry
    }
}

struct FileInformation {
    let title: String
    let value: String?
}
