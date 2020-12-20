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
        let info = [FileInformation(title: "Name:", value: file.name),
                    FileInformation(title: "Type:", value: file.tag.rawValue),
                    FileInformation(title: "Downloadable:", value: file.isDownloadable.string),
                    FileInformation(title: "Size:", value: file.size?.string),
                    FileInformation(title: "Last modified:", value: file.modifiedDate?.string(withFormat: "dd/MM/yyyy HH:mm")),
                    FileInformation(title: "Full Path:", value: file.pathDisplay),
                    FileInformation(title: "Hash value:", value: file.hashValue ?? "")]
        
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
