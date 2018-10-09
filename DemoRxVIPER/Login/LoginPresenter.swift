//
//  LoginPresenter.swift
//  DemoRxVIPER
//
//  Created by PhatDT3 on 10/9/18.
//  Copyright © 2018 PhatDT3. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginPresenter: LoginPresenterProtocol {
    
    //MARK: Properties
    weak var loginView: LoginViewProtocol?
    var loginInteractor: LoginInteractorProtocol?
    let disposeBag = DisposeBag()
    
    //MARK: Input
    var usernameDidChange: PublishSubject<String> = PublishSubject<String>()
    var passwordDidChange: PublishSubject<String> = PublishSubject<String>()
    var loginButtonDidTap: PublishSubject<UserInfo> = PublishSubject<UserInfo>()
    
    //MARK: Output
    var usernameState: Driver<Bool>?
    var passwordState: Driver<Bool>?
    var loginButtonState: Driver<Bool>?
    var loginStatus: Driver<UIViewController?>
    
    //MARK: Logic
    init(interactor: LoginInteractorProtocol) {
        self.loginInteractor = interactor
        //Bind input to interactor
        self.usernameDidChange.bind(to: interactor.usernameStream)
            .disposed(by: disposeBag)
        
        self.passwordDidChange.bind(to: interactor.passwordStream)
            .disposed(by: disposeBag)
        
        self.loginButtonDidTap.bind(to: interactor.loginButtonStream)
           .disposed(by: disposeBag)
        
        //Set output as driver
        self.usernameState = interactor.usernameState
        .asDriver(onErrorJustReturn: false)
        
        self.passwordState = interactor.passwordState
        .asDriver(onErrorJustReturn: false)
        
        self.loginButtonState = interactor.loginButtonState
        .asDriver(onErrorJustReturn: false)
        
        self.loginStatus = interactor.loginStatus
            .map {
                status -> UIViewController? in
                if status.isSuccess {
                    return LoginRouter.createMainScreen()
                }
                else {
                    let alert = UIAlertController(title: "Error", message: status.errorMessage, preferredStyle: .alert)
                    let actionRetry = UIAlertAction(title: "OK", style: .destructive, handler: nil)
                    alert.addAction(actionRetry)
                    return alert
                }
            }
        .asDriver(onErrorJustReturn: nil)
    }
    
}
