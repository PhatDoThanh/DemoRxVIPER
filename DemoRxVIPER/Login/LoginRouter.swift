//
//  LoginRouter.swift
//  DemoRxVIPER
//
//  Created by PhatDT3 on 10/9/18.
//  Copyright © 2018 PhatDT3. All rights reserved.
//

import UIKit


class LoginRouter: LoginRouterProtocol {
    
    static func createLoginView() -> UIViewController {
        let view = LoginViewController()
        let interactor = LoginInteractor()
        let presenter = LoginPresenter(interactor: interactor)
        
        view.loginPresenter = presenter
        presenter.loginView = view
        presenter.loginInteractor = interactor
        interactor.loginPresenter = presenter
        return view
    }
    
    static func createMainScreen() -> UIViewController {
        return MainScreenRouter.createView()
    }
    
    
}
