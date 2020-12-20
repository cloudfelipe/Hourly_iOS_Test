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
import SkeletonView

final class FileInformationDetailViewController<T: FileInformationDetailViewModelType>: BaseViewController<T> {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "file")
        imageView.isSkeletonable = true
        return imageView
    }()
    
    lazy var thumbnailTitleLabel: UILabel = {
        let label = UILabel(text: "Thumbnail")
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    lazy var thumbnailStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [thumbnailImageView, thumbnailTitleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.isSkeletonable = true
        stack.spacing = 5.0
        return stack
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
        view.addSubview(thumbnailStack)
        thumbnailStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        thumbnailStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        thumbnailStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: 1.0).isActive = true
        thumbnailStack.heightAnchor.constraint(equalTo: thumbnailStack.widthAnchor, multiplier: 0.8, constant: 1).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: thumbnailStack.bottomAnchor, constant: 10.0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1).isActive = true
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
        .disposed(by: disposeBag)
        
        viewModel.dataRequestState
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] in self?.requestState($0) })
        .disposed(by: disposeBag)
        
        viewModel.thumbnailData
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak thumbnailImageView] data in
                thumbnailImageView?.image = UIImage(data: data)
            })
            .disposed(by: disposeBag)
    }
    
    func requestState(_ requestState: DataRequestState) {
        DispatchQueue.main.async {
            switch requestState {
            case .downloading:
                self.thumbnailStack.showAnimatedGradientSkeleton()
            default:
                self.thumbnailStack.hideSkeleton()
            }
        }
    }
}
