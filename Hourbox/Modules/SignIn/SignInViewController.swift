//
//  SignInViewController.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import UIKit
import SwiftyDropbox
import RxCocoa

final class SignInViewController<T: SignInViewModelType>: BaseViewController<T> {
    
    var signinButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        signinButton.setTitle("Sign In", for: .normal)
        signinButton.backgroundColor = .systemBlue
        signinButton.setTitleColor(.black, for: .normal)
        signinButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signinButton)
        
        signinButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signinButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        signinButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        setupBinding()
    }
    
    func setupBinding() {
        viewModel.binding(startSignIn: signinButton.rx.tap.asDriver())
    }
}
