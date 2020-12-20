//
//  FileBrowserViewModelTest.swift
//  HourboxTests
//
//  Created by Felipe Correa on 20/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import XCTest
import RxBlocking
import Networking
import RxSwift

final class FileBrowserViewModelTest: XCTestCase {
    
    var logoutInteractorStub: LogoutInteractorStub!
    var getFilesInteractorStub: GetFilesInteractorStub!
    var coordinatorSpy: FileBrowserCoordinatorSpy!
    var downloadInteractorStub: DownloadFileInteractorStub!
    var sut: FileBrowserViewModel!
    
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        coordinatorSpy = FileBrowserCoordinatorSpy()
        getFilesInteractorStub = GetFilesInteractorStub()
        logoutInteractorStub = LogoutInteractorStub()
        downloadInteractorStub = DownloadFileInteractorStub()
        
        let dependencies = FileBrowserViewModel.InputDependencies(coordinator: coordinatorSpy,
                                                                  path: .root,
                                                                  getFilesInteractor: getFilesInteractorStub,
                                                                  logoutInteractor: logoutInteractorStub,
                                                                  down: downloadInteractorStub)
        sut = FileBrowserViewModel(dependencies: dependencies)
    }
    
    override func tearDown() {
        coordinatorSpy = nil
        getFilesInteractorStub = nil
        logoutInteractorStub = nil
        downloadInteractorStub = nil
        sut = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testGetData_WhenViewDidLoad_ThenGetFilesData() throws {
        //Given
        
        let getFilesExpectation = expectation(description: "Get files expectation")
        getFilesExpectation.expectedFulfillmentCount = 2
        
        var expectedFiles = [FileViewData]()
        
        getFilesInteractorStub.responseHandler = { param, completion in
            let fileEntry = Entry(tag: .file,
                                  name: "Sample",
                                  pathLower: "Sample.png",
                                  pathDisplay: "/sample",
                                  hashValue: "UUDI",
                                  isDownloadable: true,
                                  size: 1234567,
                                  modifiedDate: Date())
            
            let folderEntry = Entry(tag: .folder,
                                    name: "Sample",
                                    pathLower: "/sample",
                                    pathDisplay: "/Sample",
                                    hashValue: nil,
                                    isDownloadable: false,
                                    size: nil,
                                    modifiedDate: nil)
            
            let file = Files(entries: [fileEntry, folderEntry], coursor: nil)
            completion(.success(file))
        }
        
        sut.filesData
            .subscribe(onNext: { result in
                expectedFiles = result
                getFilesExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        //When
        sut.viewAppearStateDidChange(.didLoad)
        
        //Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(expectedFiles.count, 2)
    }
    
    func testGetData_WhenViewDidLoad_ThenGetExpectedError() throws {
        //Given
        
        getFilesInteractorStub.responseHandler = { param, completion in
            completion(.failure(.nonRetryable))
        }
                
        let errorExpectation = expectation(description: "Error expectation")
        coordinatorSpy.showErrorMessageCallback = {
            errorExpectation.fulfill()
        }
        
        //When
        sut.viewAppearStateDidChange(.didLoad)
        
        //Then
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testPeformLogout_WhenLogoutCalled_ThenLogoutInteractorCalled() {
        //Given
        let logoutExpectation = expectation(description: "Logout expectation")
        logoutInteractorStub.responseHandler = {
            logoutExpectation.fulfill()
        }
        
        //When
        sut.performLogout()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testOpenFolder_WhenSelectedFileAtIndexPath_ThenShowFileBrowser() {
        getFilesInteractorStub.responseHandler = { param, completion in
            let folderEntry = Entry(tag: .folder,
                                    name: "Sample",
                                    pathLower: "/sample",
                                    pathDisplay: "/Sample",
                                    hashValue: nil,
                                    isDownloadable: false,
                                    size: nil,
                                    modifiedDate: nil)
            
            let file = Files(entries: [folderEntry], coursor: nil)
            completion(.success(file))
        }
        
        let getFilesExpectation = expectation(description: "Get files expectation")
        getFilesExpectation.expectedFulfillmentCount = 2
        sut.filesData
            .subscribe(onNext: { result in
                getFilesExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.viewAppearStateDidChange(.didLoad)
        
        wait(for: [getFilesExpectation], timeout: 1.0)
        
        let showFlowExpectation = expectation(description: "Flow expectation")
        var resposePathToGo: FilePath?
        coordinatorSpy.navigateToDirectoryCallback = { filePath in
            resposePathToGo = filePath
            showFlowExpectation.fulfill()
        }
        
        //When
        sut.selectedFile(at: IndexPath(row: 0, section: 0))
        
        //Then
        wait(for: [showFlowExpectation], timeout: 1.0)
        XCTAssertEqual(resposePathToGo?.path, FilePath.custom("/sample").path)
    }
    
    func testOpenPhotoFile_WhenSelectedFileAtIndexPath_ThenShowPhotoViewer() {
        getFilesInteractorStub.responseHandler = { param, completion in
            let fileEntry = Entry(tag: .file,
                                  name: "Sample.png",
                                  pathLower: "/Sample",
                                  pathDisplay: "/sample",
                                  hashValue: "UUDI",
                                  isDownloadable: true,
                                  size: 1234567,
                                  modifiedDate: Date())
            
            let file = Files(entries: [fileEntry], coursor: nil)
            completion(.success(file))
        }
        
        let getFilesExpectation = expectation(description: "Get files expectation")
        getFilesExpectation.expectedFulfillmentCount = 2
        sut.filesData
            .subscribe(onNext: { result in
                getFilesExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.viewAppearStateDidChange(.didLoad)
        
        wait(for: [getFilesExpectation], timeout: 1.0)
        
        let expectedData = Data()
        downloadInteractorStub.responseHandler = { params, completion in
            completion(.success(DownloadedFile(data: expectedData)))
        }
        
        let showFlowExpectation = expectation(description: "Flow expectation")
        var resposeData: Data?
        coordinatorSpy.showImageCallback = { data in
            resposeData = data
            showFlowExpectation.fulfill()
        }
        
        //When
        sut.selectedFile(at: IndexPath(row: 0, section: 0))
        
        //Then
        wait(for: [showFlowExpectation], timeout: 1.0)
        XCTAssertEqual(expectedData, resposeData)
    }
    
    func testOpenPDF_WhenSelectedFileAtIndexPath_ThenShowPDFViewer() {
        getFilesInteractorStub.responseHandler = { param, completion in
            let fileEntry = Entry(tag: .file,
                                  name: "Sample.pdf",
                                  pathLower: "/Sample",
                                  pathDisplay: "/sample",
                                  hashValue: "UUDI",
                                  isDownloadable: true,
                                  size: 1234567,
                                  modifiedDate: Date())
            
            let file = Files(entries: [fileEntry], coursor: nil)
            completion(.success(file))
        }
        
        let getFilesExpectation = expectation(description: "Get files expectation")
        getFilesExpectation.expectedFulfillmentCount = 2
        sut.filesData
            .subscribe(onNext: { result in
                getFilesExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.viewAppearStateDidChange(.didLoad)
        
        wait(for: [getFilesExpectation], timeout: 1.0)
        
        let expectedData = Data()
        downloadInteractorStub.responseHandler = { params, completion in
            completion(.success(DownloadedFile(data: expectedData)))
        }
        
        let showFlowExpectation = expectation(description: "Flow expectation")
        var resposeData: Data?
        coordinatorSpy.showPDFCallback = { data in
            resposeData = data
            showFlowExpectation.fulfill()
        }
        
        //When
        sut.selectedFile(at: IndexPath(row: 0, section: 0))
        
        //Then
        wait(for: [showFlowExpectation], timeout: 1.0)
        XCTAssertEqual(expectedData, resposeData)
    }
    
    func testFileInformation_WhenSelectedFileAtIndexPath_ThenShowFileInformation() {
        getFilesInteractorStub.responseHandler = { param, completion in
            let fileEntry = Entry(tag: .file,
                                  name: "Sample.pdf",
                                  pathLower: "/Sample",
                                  pathDisplay: "/sample",
                                  hashValue: "UUDI",
                                  isDownloadable: true,
                                  size: 1234567,
                                  modifiedDate: Date())
            
            let file = Files(entries: [fileEntry], coursor: nil)
            completion(.success(file))
        }
        
        let getFilesExpectation = expectation(description: "Get files expectation")
        getFilesExpectation.expectedFulfillmentCount = 2
        sut.filesData
            .subscribe(onNext: { result in
                getFilesExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.viewAppearStateDidChange(.didLoad)
        
        wait(for: [getFilesExpectation], timeout: 1.0)
        
        
        let showFlowExpectation = expectation(description: "Flow expectation")
        coordinatorSpy.showFileDetailCallback = { file in
            showFlowExpectation.fulfill()
        }
        
        //When
        sut.fileInformation(for: IndexPath(row: 0, section: 0))
        
        //Then
        wait(for: [showFlowExpectation], timeout: 1.0)
    }
}
