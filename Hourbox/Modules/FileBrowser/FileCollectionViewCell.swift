//
//  FileCollectionViewCell.swift
//  Hourbox
//
//  Created by Felipe Correa on 15/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import UIKit
import SkeletonView

class FileCollectionViewCell: UICollectionViewCell {
    
    private var moreInfoAction: (() -> Void)?
    
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
        title.lineBreakMode = .byTruncatingHead
        return title
    }()
    
    lazy var moreOptionsButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.required, for: .vertical)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.addTarget(self, action: #selector(FileCollectionViewCell.moreInfoButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var fileIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .scaleAspectFill
        imageView.isOpaque = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let iconContainer = UIView()
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        fileIconImageView.addToParent(iconContainer)
        containerStackView.addArrangedSubview(iconContainer)
        containerStackView.addArrangedSubview(fileTitleLabel)
        containerStackView.addArrangedSubview(moreOptionsButton)
        containerStackView.addToParent(contentView)
        
        self.isSkeletonable = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        moreInfoAction = nil
        fileTitleLabel.text = nil
        fileIconImageView.image = nil
    }
    
    @objc func moreInfoButtonAction(_ sender: UIButton) {
        moreInfoAction?()
    }
    
    func setup(with data: FileViewData, moreInfoAction: @escaping (() -> Void)) {
        self.fileTitleLabel.text = data.name
        self.fileIconImageView.image = UIImage(named: data.iconName)
        self.moreInfoAction = moreInfoAction
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
