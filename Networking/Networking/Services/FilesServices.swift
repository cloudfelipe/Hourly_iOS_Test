//
//  FilesServices.swift
//  Networking
//
//  Created by Felipe Correa on 14/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

public protocol FilesServicesType {
    func getFiles(params: APIFilesRequest, completion: @escaping RequestResultable<APIResponse>)
}

public final class FilesServices: WebService, FilesServicesType {
    public func getFiles(params: APIFilesRequest, completion: @escaping RequestResultable<APIResponse>) {
        
        let endpoint = RESTEndpoint(method: .post,
                                    baseUrl: baseUrl.baseURL,
                                    path: .relativePath("files/list_folder"),
                                    requestParameters: params,
                                    contentType: .json)
        
        let apiRequest = APIRequest<APIResponse>(endpoint: endpoint)
        client.loadAPIRequest(endpoint: apiRequest, completion: completion)
    }
}
