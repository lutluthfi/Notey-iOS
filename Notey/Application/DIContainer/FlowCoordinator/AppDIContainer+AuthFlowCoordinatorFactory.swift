//
//  AppDIContainer+AuthFlowCoordinatorFactory.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 04/03/21.
//

import UIKit

//extension AppDIContainer: AuthFlowCoordinatorFactory { }
//
//extension AppDIContainer {
//    
//    func makeAuthSigninController(requestValue: AuthSigninViewModelRequestValue,
//                                  route: AuthSigninViewModelRoute) -> UIViewController {
//        let viewModel = self.makeAuthSigninViewModel(requestValue: requestValue, route: route)
//        return AuthSigninController.create(with: viewModel)
//    }
//    
//    private func makeAuthSigninViewModel(requestValue: AuthSigninViewModelRequestValue,
//                                         route: AuthSigninViewModelRoute) -> AuthSigninViewModel {
//        return DefaultAuthSigninViewModel(requestValue: requestValue, route: route)
//    }
//    
//}
//
//extension AppDIContainer {
//    
//    func makeAuthOnBoardingController(requestValue: AuthOnBoardingViewModelRequestValue,
//                                  route: AuthOnBoardingViewModelRoute) -> UIViewController {
//        let viewModel = self.makeAuthOnBoardingViewModel(requestValue: requestValue, route: route)
//        return AuthOnBoardingController.create(with: viewModel)
//    }
//    
//    private func makeAuthOnBoardingViewModel(requestValue: AuthOnBoardingViewModelRequestValue,
//                                             route: AuthOnBoardingViewModelRoute) -> AuthOnBoardingViewModel {
//        return DefaultAuthOnBoardingViewModel(requestValue: requestValue, route: route)
//    }
//    
//}
//
//extension AppDIContainer {
//    
//    func makeRxAuthSigninController(requestValue: RxAuthSigninViewModelRequestValue,
//                                    route: RxAuthSigninViewModelRoute) -> UIViewController {
//        let viewModel = self.makeRxAuthSigninViewModel(requestValue: requestValue, route: route)
//        return RxAuthSigninController.create(with: viewModel)
//    }
//    
//    private func makeRxAuthSigninViewModel(requestValue: RxAuthSigninViewModelRequestValue,
//                                           route: RxAuthSigninViewModelRoute) -> RxAuthSigninViewModel {
//        return DefaultRxAuthSigninViewModel(requestValue: requestValue, route: route)
//    }
//    
//}
