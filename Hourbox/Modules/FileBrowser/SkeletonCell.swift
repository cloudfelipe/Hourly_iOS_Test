//
//  SkeletonCell.swift
//  Hourbox
//
//  Created by Felipe Correa on 19/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Foundation
import SkeletonView

final class SkeletonCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isSkeletonable = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
