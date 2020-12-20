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
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "frontLogo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 0.7).isActive = true
        
        let welcomeLabel = UILabel()
        welcomeLabel.text = Texts.SignIn.welcomeTitle
        welcomeLabel.numberOfLines = 0
        welcomeLabel.font = .boldSystemFont(ofSize: 25.0)
        welcomeLabel.textAlignment = .center
        
        signinButton.setTitle(Texts.SignIn.button, for: .normal)
        signinButton.backgroundColor = .systemBlue
        signinButton.setTitleColor(.white, for: .normal)
        signinButton.translatesAutoresizingMaskIntoConstraints = false
        signinButton.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
        signinButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        
        let stackView = UIStackView(arrangedSubviews: [logoImageView, welcomeLabel, signinButton])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        setupBinding()
    }
    
    func setupBinding() {
        viewModel.binding(startSignIn: signinButton.rx.tap.asDriver())
    }
}
