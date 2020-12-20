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
import RxCocoa

protocol FileInformationDetailViewModelType: BaseViewModelType {
    var informationDataView: Observable<[FileInformation]> { get }
    var dataRequestState: Observable<DataRequestState> { get }
    var thumbnailData: Observable<Data> { get }
}

final class FileInformationDetailViewModel: BaseViewModel, FileInformationDetailViewModelType {
    
    var informationDataView: Observable<[FileInformation]> {
        informationData.asObserver()
    }
    
    var dataRequestState: Observable<DataRequestState> {
        requestState.asObservable()
    }
    
    var thumbnailData: Observable<Data> {
        thumbnail.asObserver()
    }
    
    private let dependencies: InputDependencies
    private let requestState = BehaviorRelay<DataRequestState>(value: .normal)
    private var informationData = PublishSubject<[FileInformation]>()
    private let thumbnail = PublishSubject<Data>()
    
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
        typealias Title = Texts.FileInformation
        let info = [FileInformation(title: Title.name, value: file.name),
                    FileInformation(title: Title.type, value: file.tag.rawValue),
                    FileInformation(title: Title.downloadable, value: file.isDownloadable.string),
                    FileInformation(title: Title.size, value: file.size?.string),
                    FileInformation(title: Title.lastModified, value: file.modifiedDate?.string(withFormat: Title.dateFormat)),
                    FileInformation(title: Title.fullPath, value: file.pathDisplay),
                    FileInformation(title: Title.hashValue, value: file.hashValue ?? Texts.General.na)]
        
        informationData.onNext(info.filter { $0.value != nil })
        
        downloadThumbnail(for: file)
    }
    
    private func downloadThumbnail(for file: Entry) {
        requestState.accept(.downloading)
        DispatchQueue.global(qos: .background).async {
            self.dependencies.getThumbnailInteractor.get(for: file) { [weak self] (result) in
                switch result {
                case .success(let thumbnail):
                    self?.requestState.accept(.downloadedFile)
                    self?.thumbnail.onNext(thumbnail.data)
                case .failure(_):
                    self?.requestState.accept(.error)
                }
            }
        }
    }
}
