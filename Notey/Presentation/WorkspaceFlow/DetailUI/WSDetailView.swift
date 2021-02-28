//
//  WSDetailView.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 27/02/21.
//  Copyright (c) 2021 All rights reserved.
//
//  Template:
//  Modified by Arif Luthfiansyah
//  Created by Oleh Kudinov

import UIKit

// MARK: WSDetailViewDelegate
protocol WSDetailViewDelegate: AnyObject {
    func onViewTapped(_ sender: UITapGestureRecognizer)
}

// MARK: WSDetailViewInput
protocol WSDetailViewInput {
    func viewWillAppear()
    func viewWillDisappear()
}

// MARK: WSDetailViewSubview
protocol WSDetailViewSubview {
    var navigationBar: UINavigationBar? { get }
    var navigationItem: UINavigationItem! { get }
}

// MARK: WSDetailView
protocol WSDetailView: WSDetailViewInput, WSDetailViewSubview { }

// MARK: DefaultWSDetailView
final class DefaultWSDetailView: UIView, WSDetailView {

    // MARK: Subview Variable
    weak var navigationBar: UINavigationBar?
    weak var navigationItem: UINavigationItem!

    // MARK: DI Variable
    weak var delegate: WSDetailViewDelegate?
    
    // MARK: Init Function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(delegate: WSDetailViewDelegate, navigationBar: UINavigationBar?, navigationItem: UINavigationItem) {
        self.delegate = delegate
        self.navigationBar = navigationBar
        self.navigationItem = navigationItem
        super.init(frame: UIScreen.main.fixedCoordinateSpace.bounds)
        self.addSubviews()
        self.makeConstraints()
        self.setupView()
    }

}

// MARK: Internal Function
extension DefaultWSDetailView {
    
    func addSubviews() {
    }
    
    func makeConstraints() {
    }
    
    func setupView() {
        self.backgroundColor = .green
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onViewTapped(_:)))
        self.gestureRecognizers = [tapGesture]
    }
    
}

// MARK: @objc Function
extension DefaultWSDetailView {
    
    @objc
    func onViewTapped(_ sender: UITapGestureRecognizer) {
        self.delegate?.onViewTapped(sender)
    }
    
}

// MARK: Input Function
extension DefaultWSDetailView {
    
    func viewWillAppear() {
        self.navigationItem.title = "Detail"
    }
    
    func viewWillDisappear() {
        
    }
    
}
