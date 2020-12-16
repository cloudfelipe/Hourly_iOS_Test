//
//  FileCollectionViewCell.swift
//  Hourbox
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import UIKit

class FileCollectionViewCell: UICollectionViewCell {
    lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 3.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var fileTitleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.setContentHuggingPriority(.required, for: .vertical)
        title.setContentCompressionResistancePriority(.required, for: .vertical)
        title.text = "SAMPLE"
        title.textColor = .white
        return title
    }()
    
    lazy var moreOptionsButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.required, for: .vertical)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        return button
    }()
    
    lazy var fileIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .scaleAspectFit
//        imageView.image = UIImage(named: "folder")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        
        let iconContainer = UIView()
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        fileIconImageView.addToParent(iconContainer)
//        iconContainer.addSubview(fileIconImageView)
//        fileIconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor).isActive = true
//        fileIconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor).isActive = true
//        fileIconImageView.widthAnchor.constraint(equalTo: iconContainer.widthAnchor, multiplier: 0.6, constant: 1).isActive = true
//        fileIconImageView.heightAnchor.constraint(equalTo: iconContainer.heightAnchor, multiplier: 0.8, constant: 1).isActive = true
        
        
        containerStackView.addArrangedSubview(iconContainer)
        containerStackView.addArrangedSubview(fileTitleLabel)
        containerStackView.addArrangedSubview(moreOptionsButton)
        containerStackView.addToParent(contentView)
    }
    
    func setup(with data: FileViewData) {
        fileTitleLabel.text = data.name
        fileIconImageView.image = UIImage(named: data.iconName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    public func addToParent(_ parent: UIView) {
        parent.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
    }
}
