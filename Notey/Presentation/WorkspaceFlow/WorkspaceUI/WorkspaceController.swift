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
import RxSwift
import UIKit

// MARK: WorkspaceController
final class WorkspaceController: UIViewController {

    // MARK: DI Variable
    let disposeBag = DisposeBag()
    lazy var _view: WorkspaceView = {
        return DefaultWorkspaceView(
            delegate: self,
            navigationBar: self.navigationController?.navigationBar,
            navigationItem: self.navigationItem
        )
    }()
    var viewModel: WorkspaceViewModel!

    // MARK: Common Variable

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
        self.bind(to: self.viewModel)
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
    private func bind(to viewModel: WorkspaceViewModel) {
    }

    // MARK: SetupView By Lifecycle Function
    private func setupViewDidLoad() {
        self.view = (self._view as! UIView)
        self._view.viewDidLoad(self)
    }
    
    private func setupViewWillAppear() {
        self._view.viewWillAppear()
    }
    
    private func setupViewWillDisappear() {
        self._view.viewWillDisappear()
    }
    
}

// MARK: Observe ViewModel Function
extension WorkspaceController {

}

// MARK: WorkspaceViewDelegate
extension WorkspaceController: WorkspaceViewDelegate {
    
    func onSquarePencilBarButtonItemTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Create workspace",
                                                message: "Enter a name for this worksapce",
                                                preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Name of workspace"
            textField.clearButtonMode = .whileEditing
            textField.clearsOnBeginEditing = true
        }
        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] (action) in
            self?.viewModel.showWSDetailUI()
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
