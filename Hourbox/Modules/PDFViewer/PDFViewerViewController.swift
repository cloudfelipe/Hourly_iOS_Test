//
//  PDFViewerViewController.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import UIKit
import PDFKit

final class PDFViewerViewController: UIViewController {
    
    var pdfView: PDFView!
    var data: Data!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        pdfView = PDFView()
        pdfView.addToParent(view)
        pdfView.autoScales = true
        let document = PDFDocument(data: data)
        pdfView.document = document
    }
}
