//
//  WorkspaceController.swift
//  Writey
//
//  Created by Arif Luthfiansyah on 21/02/21.
//  Copyright (c) 2021 All rights reserved.
//
//  Template:
//  Modified by Arif Luthfiansyah
//  Created by Oleh Kudinov

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// MARK: WorkspaceController
final class WorkspaceController: UIViewController {

    // MARK: DI Variable
    lazy var _view: WorkspaceView = {
        return DefaultWorkspaceView(
            navigationBar: self.navigationController?.navigationBar,
            navigationItem: self.navigationItem
        )
    }()
    var viewModel: WorkspaceViewModel!

    // MARK: Common Variable
    let disposeBag = DisposeBag()
    var displayedWorkspaces: [WorkspaceDomain] = []

    // MARK: Create Function
    class func create(with viewModel: WorkspaceViewModel) -> WorkspaceController {
        let vc = WorkspaceController()
        vc.viewModel = viewModel
        return vc
    }

    // MARK: UIViewController Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewDidLoad()
        self.bind(viewModel: self.viewModel, with: self._view)
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setupViewWillDisappear()
    }

    // MARK: Bind ViewModel Function
    private func bind(viewModel: WorkspaceViewModel, with view: WorkspaceView) {
        self.subscribeSquarePencilBarButtonItemTap(
            view: view,
            barButtonItem: view.squarePencilBarButtonItem
        )
        self.subscribeDisplayedWorkspacesThenBindWithTitleBarButtonItem(
            obserables: viewModel.displayedWorkspaces,
            titleBarButtonItem: view.titleBarButtonItem
        )
        self.subscribeDisplayedWorkspacesThenBindWithTableView(
            view: view,
            observables: viewModel.displayedWorkspaces,
            tableView: view.tableView
        )
    }

    // MARK: SetupView By Lifecycle Function
    private func setupViewDidLoad() {
        self.view = (self._view as! UIView)
        self._view.viewDidLoad(self)
        self._view.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
    }
    
    private func setupViewWillAppear() {
        self._view.viewWillAppear()
    }
    
    private func setupViewWillDisappear() {
        self._view.viewWillDisappear()
    }
    
}

// MARK: SubscribeDisplayedWorkspacesThenBindWithTitleBarButtonItem
extension WorkspaceController {
    
    func subscribeDisplayedWorkspacesThenBindWithTitleBarButtonItem(
        obserables: BehaviorSubject<[WorkspaceDomain]>,
        titleBarButtonItem: UIBarButtonItem
    ) {
        obserables
            .map({ (workspaces) -> String in
                if workspaces.isEmpty {
                    return "No workspace"
                } else if workspaces.count > 1 {
                    return "\(workspaces.count) workspaces"
                } else {
                    return "\(workspaces.count) workspace"
                }
            })
            .subscribeOn(MainScheduler.instance)
            .bind(to: titleBarButtonItem.rx.title)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: SubscribeDisplayedWorkspacesThenBindWithTableView
extension WorkspaceController {
    
    func subscribeDisplayedWorkspacesThenBindWithTableView(
        view: WorkspaceView,
        observables: BehaviorSubject<[WorkspaceDomain]>,
        tableView: UITableView
    ) {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionItems<WorkspaceDomain>>
        { [unowned view] (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: view.workspaceTableCellIdentifier)
            cell.selectionStyle = .none
            cell.textLabel?.text = item.name
            let createdAtFormatted = item.createdAt.toDate().formatted(components: [
                .dayOfWeekAbbreviationName,
                .comma,
                .whitespace,
                .dayOfMonthPadding,
                .dash,
                .monthOfYearDouble,
                .dash,
                .yearFullDigits,
                .whitespace,
                .hour12Padding,
                .colon,
                .minutePadding,
                .whitespace,
                .meridiem
            ])
            cell.detailTextLabel?.text = "Created at \(createdAtFormatted)"
            return cell
        }
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        observables
            .observeOn(MainScheduler.instance)
            .map { [unowned self] (workspaces) -> [SectionItems<WorkspaceDomain>] in
                self.displayedWorkspaces = workspaces
                return [SectionItems(footer: nil, header: nil, items: workspaces)]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: SubscribeSquarePencilBarButtonItemTap
extension WorkspaceController {
    
    func subscribeSquarePencilBarButtonItemTap(view: WorkspaceView, barButtonItem: UIBarButtonItem) {
        barButtonItem.rx.tap
            .bind(onNext: self.onNextSubscribeSquarePencilBarButtonItemTap())
            .disposed(by: self.disposeBag)
    }
    
    private func onNextSubscribeSquarePencilBarButtonItemTap() -> (() -> Void) {
        return { [unowned self] in
            let alertController = UIAlertController(title: "Create workspace",
                                                    message: "Enter a name for this worksapce",
                                                    preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = "Name of workspace"
                textField.clearButtonMode = .whileEditing
                textField.clearsOnBeginEditing = false
                textField.autocapitalizationType = .words
            }
            let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] (action) in
                guard let alertNameTextField = alertController.textFields?[0],
                      let name = alertNameTextField.text else { return }
                self?.viewModel.doCreateWorkspace(name: name)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in }
            alertController.addAction(cancelAction)
            alertController.addAction(createAction)
            guard let alertNameTextField = alertController.textFields?[0] else { return }
            alertNameTextField.rx.text.orEmpty
                .subscribe(onNext: { createAction.isEnabled = !$0.isEmpty })
                .disposed(by: self.disposeBag)
            self.present(alertController, animated: true)
        }
    }
    
}

extension WorkspaceController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "DELETE")
        { [unowned self] (action, view, canPerform) in
            let workspace = self.displayedWorkspaces[indexPath.row]
            self.viewModel.doRemoveWorkspace(workspace)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    
}
