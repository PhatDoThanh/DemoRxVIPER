//
//  LoginInteractor.swift
//  DemoRxVIPER
//
//  Created by PhatDT3 on 10/9/18.
//  Copyright © 2018 PhatDT3. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

class LoginInteractor: LoginInteractorProtocol {
    
    //MARK: Properties
    weak var loginPresenter: LoginPresenterProtocol?
    let statusStream = PublishSubject<LoginStatus>()
    let disposeBag = DisposeBag()
    
    //MARK: Input
    var usernameStream: PublishSubject<String> = PublishSubject<String>()
    var passwordStream: PublishSubject<String> = PublishSubject<String>()
    var loginButtonStream: PublishSubject<UserInfo> = PublishSubject<UserInfo>()
    
    
    //MARK: Output
    var usernameState: Observable<Bool>
    var passwordState: Observable<Bool>
    var loginButtonState: Observable<Bool>
    var loginStatus: Observable<LoginStatus>
    
    //MARK: Logic
    init() {
        self.usernameState = self.usernameStream
            .map { username -> Bool in
                return LoginInteractor.verifyUsername(username: username)
            }
        
        self.passwordState = self.passwordStream
            .map { password -> Bool in
                return LoginInteractor.verifyPassword(password: password)
            }
        
        self.loginButtonState = Observable.combineLatest(usernameState, passwordState) {
            return !($0 && $1)
        }
        
        self.loginStatus = self.statusStream
            .map {
                status -> LoginStatus in
                return status
            }
        
        self.loginButtonStream
            .asDriver(onErrorJustReturn: UserInfo(username: "", password: ""))
            .map {
                user in
                if user.username == "" {
                    return
                }
                Auth.auth().signIn(withEmail: user.username, password: user.password) {
                    [weak self] (_, error) in
                    if let error = error {
                        let status = LoginStatus(errorMessage: error.localizedDescription)
                        self?.statusStream.on(.next(status))
                        return
                    }
                    let status = LoginStatus(isSuccess: true)
                    self?.statusStream.on(.next(status))
                }
            }.drive().disposed(by: disposeBag)
        
        
    }
    
    private static func verifyUsername(username: String) -> Bool {
        let format = "[a-zA-Z0-9]{4,}\\@[a-z]+\\.[a-z]+"
        let regex = try! NSRegularExpression(pattern: format, options: .caseInsensitive)
        guard let firstMatch = regex.firstMatch(in: username, options: [], range: NSRange(location: 0, length: username.count)),
            let range = Range(firstMatch.range, in: username) else {
            return false
        }
        return String(username[range]).count == username.count
    }
    
    private static func verifyPassword(password: String) -> Bool {
        return password.count > 5
    }
}
