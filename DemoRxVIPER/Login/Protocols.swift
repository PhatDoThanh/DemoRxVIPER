//
//  Protocols.swift
//  DemoRxVIPER
//
//  Created by cpu12130-local on 10/9/18.
//  Copyright © 2018 PhatDT3. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol LoginViewProtocol: class {
    
    var loginPresenter: LoginPresenterProtocol? { get set }
    
}

protocol LoginPresenterProtocol: class {
    
    //VIPERs' Properties
    var loginView: LoginViewProtocol? { get set }
    var loginInteractor: LoginInteractorProtocol? { get set }
    
    //Input
    var usernameDidChange: PublishSubject<String> { get }
    var passwordDidChange: PublishSubject<String> { get }
    var loginButtonDidTap: PublishSubject<UserInfo> { get set }
    
    //Output
    var usernameState: Driver<Bool>? { get }
    var passwordState: Driver<Bool>? { get }
    var loginButtonState: Driver<Bool>? { get }
    var loginStatus: Driver<UIViewController?> { get }
}

protocol LoginInteractorProtocol: class {
    
    var loginPresenter: LoginPresenterProtocol? { get set }
    
    //Input
    var usernameStream: PublishSubject<String> { get }
    var passwordStream: PublishSubject<String> { get }
    var loginButtonStream: PublishSubject<UserInfo> { get }
    
    //Output
    var usernameState: Observable<Bool> { get }
    var passwordState: Observable<Bool> { get }
    var loginButtonState: Observable<Bool> { get }
    var loginStatus: Observable<LoginStatus> { get }
    
}

protocol LoginRouterProtocol: class {
    
    static func createLoginView() -> UIViewController
    static func createMainScreen() -> UIViewController
}
