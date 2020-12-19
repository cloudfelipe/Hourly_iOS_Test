//
//  FileInformationDetailViewController.swift
//  Hourbox
//
//  Created by Felipe Correa on 18/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class FileInformationDetailViewController<T: FileInformationDetailViewModelType>: BaseViewController<T> {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CumtonCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.layoutIfNeeded()
    }
    
    private func setupView() {
        tableView.addToParent(view)
        title = "File information"
    }
    
    private func setupBinding() {
        viewModel.informationDataView
        .bind(to: tableView.rx.items) { (tableView, row, item) in
            let cell: UITableViewCell!
            if let celld = tableView.dequeueReusableCell(withIdentifier: "CumtonCell") {
                cell = celld
            } else {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "CustomCell")
            }
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.value
            return cell
        }
        .disposed(by: disposableBag)
    }
}
