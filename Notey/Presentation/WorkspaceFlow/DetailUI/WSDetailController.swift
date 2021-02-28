//
//  WSDetailController.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 27/02/21.
//  Copyright (c) 2021 All rights reserved.
//
//  Template:
//  Modified by Arif Luthfiansyah
//  Created by Oleh Kudinov

import UIKit

// MARK: WSDetailController
final class WSDetailController: UIViewController {

    // MARK: DI Variable
    lazy var _view: WSDetailView = {
        return DefaultWSDetailView(
            delegate: self,
            navigationBar: self.navigationController?.navigationBar,
            navigationItem: self.navigationItem
        )
    }()
    var viewModel: WSDetailViewModel!

    // MARK: Common Variable


    // MARK: Create Function
    class func create(with viewModel: WSDetailViewModel) -> WSDetailController {
        let vc = WSDetailController()
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
    private func bind(to viewModel: WSDetailViewModel) {
    }

    // MARK: SetupView By Lifecycle Function
    private func setupViewDidLoad() {
        self.view = (self._view as! UIView)
    }
    
    private func setupViewWillAppear() {
        self._view.viewWillAppear()
    }
    
    private func setupViewWillDisappear() {
        self._view.viewWillDisappear()
    }
    
}

// MARK: Observe ViewModel Function
extension WSDetailController {

}

// MARK: WSDetailViewDelegate
extension WSDetailController: WSDetailViewDelegate {

    func onViewTapped(_ sender: UITapGestureRecognizer) {
        self.viewModel.showWorkspaceUI()
    }
    
}
