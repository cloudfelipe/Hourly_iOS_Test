//
//  APIResponse.swift
//  Networking
//
//  Created by Felipe Correa on 14/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation

public struct APIResponse: APIModelType {
    public let entries: [APIEntry]
    public let coursor: String?
}
