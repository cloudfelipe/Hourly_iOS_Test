//
//  PDFViewerViewController.swift
//  Hourbox
//
//  Created by Felipe Correa on 16/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import PDFKit

final class PDFViewerViewController: UIViewController {
    
    private(set) var pdfView: PDFView!
    private(set) var data: Data!
    
    init(data: Data) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        pdfView = PDFView()
        pdfView.addToParent(view)
        pdfView.autoScales = true
        let document = PDFDocument(data: data)
        pdfView.document = document
    }
}
