//
//  BaseViewModelType.swift
//  Hourbox
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import RxSwift

protocol BaseViewModelType: AnyObject {
    var viewAppearState: PublishSubject<ViewAppearState> { get }
}
