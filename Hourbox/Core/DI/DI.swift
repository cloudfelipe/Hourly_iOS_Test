//
//  DI.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Networking
import KeychainAccess
import SwiftyDropbox

struct URLProvider: BaseURLProviderType {
    var baseURL: String {
        "https://api.dropboxapi.com/2/"
    }
}

final class DI {
    
    private var keychainAccess: Keychain { Keychain(service: "com.felipeco.Hourbox") }
    private var accessTokenRepository: AccessTokenRepositoryType { keychainAccess }
    private var tokenProvider: AuthProviderType { TokenAccess(token: keychainAccess.token, header: keychainAccess.header) }
    private var dropboxClient: DropboxClient { DropboxClient(accessToken: keychainAccess.getToken() ?? "" ) }
    private var client: WebClient { WebClient(authProvider: tokenProvider) }
    private var service: FilesServices { FilesServices(baseUrlProvider: URLProvider(), client: client) }
    private var downloadService: DownloadService { DownloadService(client: dropboxClient) }
    private var repo: FilesRepository { FilesRepository(service: service, downloadService: downloadService, errorProcessor: ErrorProcessor()) }
   
    var getFilesInteractor: GetFilesInteractor { GetFilesInteractor(repository: repo) }
    var downloadFileInteractor: DownloadFileInteractorType { DownloadFileInteractor(repository: repo) }
    var isUserLoggedInInteractor: IsUserLoggedInInteractorType { IsUserLoggedInInteractor(repository: accessTokenRepository) }
    var storeAccessTokenInteractor: StoreAccessTokenInteractorType { StoreAccessTokenInteractor(repository: accessTokenRepository)}
    var removeAccessTokenInteractor: RemoveAccessTokenInteractorType { RemoveAccessTokenInteractor(repository: accessTokenRepository) }
    var getThumbnailInteractor: GetThumbnailInteractorType { GetThumbnailInteractor(repository: repo) }
    var logoutInteractor: LogoutInteractorType { LogoutInteractor() }
    
    init() { }
}

struct TokenAccess: AuthProviderType {
    let token: String
    let header: String
}
