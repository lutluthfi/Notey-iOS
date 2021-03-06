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
protocol WorkspaceViewDelegate: AnyObject {
    
}

// MARK: WorkspaceViewSubview
protocol WorkspaceViewSubview {
    var navigationBar: UINavigationBar? { get }
    var navigationItem: UINavigationItem! { get }
    
    var squarePencilBarButtonItem: UIBarButtonItem { get }
    var tableView: UITableView { get }
    var titleBarButtonItem: UIBarButtonItem { get }
}

// MARK: WorkspaceViewVariable
protocol WorkspaceViewVariable {
    var delegate: WorkspaceViewDelegate? { get }
    
    var workspaceTableCellIdentifier: String { get }
}

// MARK: WorkspaceViewFunction
protocol WorkspaceViewFunction {
    func viewDidLoad(_ controller: UIViewController)
    func viewWillAppear()
    func viewWillDisappear()
}

// MARK: WorkspaceView
protocol WorkspaceView: WorkspaceViewFunction, WorkspaceViewSubview, WorkspaceViewVariable { }

// MARK: DefaultWorkspaceView
final class DefaultWorkspaceView: UIView, WorkspaceView {

    // MARK: Subview Variable
    weak var navigationBar: UINavigationBar?
    weak var navigationItem: UINavigationItem!
    
    lazy var squarePencilBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"),
                               style: .done,
                               target: self,
                               action: nil)
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.bounds)
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.workspaceTableCellIdentifier)
        return tableView
    }()
    lazy var titleBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "No workspace",
                               style: .done,
                               target: self,
                               action: nil)
    }()
    
    // MARK: DI Variable
    weak var delegate: WorkspaceViewDelegate?
    let workspaceTableCellIdentifier: String = "WorkspaceTableCell"

    // MARK: Init Function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(navigationBar: UINavigationBar?, navigationItem: UINavigationItem) {
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
    
}

// MARK: Input View
extension DefaultWorkspaceView {
    
    func viewDidLoad(_ controller: UIViewController) {
        self.navigationItem.title = "Notey"
        self.navigationBar?.prefersLargeTitles = true
        controller.navigationController?.isToolbarHidden = false
        controller.toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            self.titleBarButtonItem,
            self.squarePencilBarButtonItem
        ]
    }
    
    func viewWillAppear() {
    }
    
    func viewWillDisappear() {
    }
    
}
