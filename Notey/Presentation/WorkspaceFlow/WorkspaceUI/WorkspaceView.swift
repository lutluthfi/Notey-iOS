//
//  WorkspaceView.swift
//  Writey
//
//  Created by Arif Luthfiansyah on 21/02/21.
//  Copyright (c) 2021 All rights reserved.
//
//  Template:
//  Modified by Arif Luthfiansyah
//  Created by Oleh Kudinov

import UIKit

// MARK: WorkspaceViewDelegate
@objc
protocol WorkspaceViewDelegate: AnyObject {
    
    @objc
    optional func onRightBarButtonItemTapped(_ sender: UIBarButtonItem)
    
    @objc
    optional func onSquarePencilBarButtonItemTapped(_ sender: UIBarButtonItem)
    
}

// MARK: WorkspaceViewSubview
protocol WorkspaceViewSubview {
    var navigationBar: UINavigationBar? { get }
    var navigationItem: UINavigationItem! { get }
    var tableView: UITableView { get }
}

// MARK: WorkspaceViewInput
protocol WorkspaceViewInput {
    func viewDidLoad(_ controller: UIViewController)
    func viewWillAppear()
    func viewWillDisappear()
}

// MARK: WorkspaceView
protocol WorkspaceView: WorkspaceViewInput, WorkspaceViewSubview {
    func getWorkspaceTableCellIdentifier() -> String
}

extension WorkspaceView {
    func getWorkspaceTableCellIdentifier() -> String {
        return "WorkspaceTableCell"
    }
}

// MARK: DefaultWorkspaceView
final class DefaultWorkspaceView: UIView, WorkspaceView {

    // MARK: Subview Variable
    weak var navigationBar: UINavigationBar?
    weak var navigationItem: UINavigationItem!
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.bounds)
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.getWorkspaceTableCellIdentifier())
        return tableView
    }()
    
    // MARK: DI Variable
    weak var delegate: WorkspaceViewDelegate?

    // MARK: Init Function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(delegate: WorkspaceViewDelegate, navigationBar: UINavigationBar?, navigationItem: UINavigationItem) {
        self.delegate = delegate
        self.navigationBar = navigationBar
        self.navigationItem = navigationItem
        super.init(frame: UIScreen.main.fixedCoordinateSpace.bounds)
        self.addSubviews()
        self.makeConstraints()
    }

}

// MARK: Internal Function
extension DefaultWorkspaceView {
    
    func addSubviews() {
        self.addSubview(self.tableView)
    }
    
    func makeConstraints() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}

// MARK: @objc Function
extension DefaultWorkspaceView {
    
    @objc
    func onRightBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.delegate?.onRightBarButtonItemTapped?(sender)
    }
    
    @objc
    func onSquarePencilBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.delegate?.onSquarePencilBarButtonItemTapped?(sender)
    }
    
}

// MARK: Input View
extension DefaultWorkspaceView {
    
    func viewDidLoad(_ controller: UIViewController) {
        self.navigationItem.title = "Notey"
        self.navigationBar?.prefersLargeTitles = true
        controller.navigationController?.isToolbarHidden = false
        controller.toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"),
                            style: .done,
                            target: self,
                            action: #selector(self.onSquarePencilBarButtonItemTapped(_:)))
        ]
    }
    
    func viewWillAppear() {
    }
    
    func viewWillDisappear() {
        
    }
    
}
