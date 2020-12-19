//
//  UIViewController+Extensions.swift
//  Hourbox
//
//  Created by Felipe Correa on 19/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import UIKit

extension UIViewController {
    var topPresentedViewController: UIViewController {
        var topController: UIViewController = self
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
}
