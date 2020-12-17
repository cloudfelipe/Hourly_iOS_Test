//
//  ImageViewerViewController.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import Lightbox

final class ImageViewerViewController: LightboxController {
    
    init(imageData: Data) {
        guard let image = UIImage(data: imageData) else {
            super.init(images: [])
            return
        }
        let lightboxImage = LightboxImage(image: image)
        super.init(images: [lightboxImage])
        self.dynamicBackground = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
