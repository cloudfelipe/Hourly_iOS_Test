//
//  BaseViewModel.swift
//  Hourbox
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import RxSwift

class BaseViewModel: BaseViewModelType {
    let disposeBag = DisposeBag()
    
    let viewAppearState = PublishSubject<ViewAppearState>()
    
    init() {
        self.viewAppearState
            .subscribe(onNext: { [weak self] in self?.viewAppearStateDidChange($0) })
            .disposed(by: disposeBag)
    }
    
    func viewAppearStateDidChange(_ state: ViewAppearState) { }
}
