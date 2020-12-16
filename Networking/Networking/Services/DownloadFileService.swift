//
//  DownloadFileService.swift
//  Networking
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation
import SwiftyDropbox

public struct APIDownloadedFile: APIModelType {
    public let data: Data
}

public protocol DownloadServiceType {
    func downloadFile(path: String, completion: @escaping RequestResultable<APIDownloadedFile>)
}

public final class DownloadService: DownloadServiceType {
    let dropboxClient: DropboxClient
    
    public init(client: DropboxClient) {
        self.dropboxClient = client
    }
    
    public func downloadFile(path: String, completion: @escaping RequestResultable<APIDownloadedFile>) {
        dropboxClient.files.download(path: path)
            .response { (response, error) in
                if let response = response {
                    debugPrint(response.0)
                    debugPrint(response.1)
                    completion(.success(APIDownloadedFile(data: response.1)))
                } else if let error = error {
                    debugPrint(error)
                    completion(.failure(.unableDownloadFile(error.description)))
                } else {
                    debugPrint("failError")
                    completion(.failure(.noDataResponse))
                }
            }
    }
}
