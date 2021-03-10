//
//  UIViewController+Alert.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 07/03/21.
//

import RxSwift
import UIKit

class AlertActionProperties {
    
    let title: String
    let style: UIAlertAction.Style
    
    init(title: String, style: UIAlertAction.Style = .default) {
        self.title = title
        self.style = style
    }
    
}

extension UIViewController {
    
    func showAlert(title: String, message: String, actions: [AlertActionProperties]) -> Observable<UIAlertAction> {
        return Observable<UIAlertAction>.create { [unowned self] (observer) -> Disposable in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            actions.forEach { (properties) in
                let alertAction = UIAlertAction(title: properties.title, style: properties.style) { action in
                    observer.onNext(action)
                }
                alertController.addAction(alertAction)
            }
            self.present(alertController, animated: true)
            return Disposables.create()
        }.observeOn(MainScheduler.instance)
    }
    
    func showActionSheet(title: String, message: String, actions: [AlertActionProperties]) -> Observable<UIAlertAction> {
        return Observable<UIAlertAction>.create { [unowned self] (observer) -> Disposable in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            actions.forEach { (properties) in
                let alertAction = UIAlertAction(title: properties.title, style: properties.style) { action in
                    observer.onNext(action)
                }
                alertController.addAction(alertAction)
            }
            self.present(alertController, animated: true)
            return Disposables.create()
        }.observeOn(MainScheduler.instance)
    }
    
}
