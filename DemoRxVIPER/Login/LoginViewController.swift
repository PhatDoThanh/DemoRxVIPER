//
//  LoginViewController.swift
//  DemoRxVIPER
//
//  Created by PhatDT3 on 10/9/18.
//  Copyright © 2018 PhatDT3. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, LoginViewProtocol {
    
    //MARK: Outlets
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!{
        didSet {
            txtPassword.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var btnLogin: UIButton! {
        didSet {
            btnLogin.isUserInteractionEnabled = false
        }
    }
    
    //MARK: Properties
    var loginPresenter: LoginPresenterProtocol?
    let disposeBag = DisposeBag()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    //MARK: Logic
    private func configure() {
        guard let presenter = self.loginPresenter else {
            return
        }
        //Configure input
        self.txtUsername.rx.text
            .map {
                guard let text = $0 else {
                    return ""
                }
                return text
            }
            .bind(to: presenter.usernameDidChange)
        .disposed(by: disposeBag)
        
        self.txtPassword.rx.text
            .map {
                guard let text = $0 else {
                    return ""
                }
                return text
            }
            .bind(to: presenter.passwordDidChange)
            .disposed(by: disposeBag)
        
        self.btnLogin.rx.tap
            .map {[weak self] _ -> UserInfo in
                guard let user = self?.txtUsername.text, let pass = self?.txtPassword.text else {
                    return UserInfo(username: "", password: "")
                }
                return UserInfo(username: user, password: pass)
            }
            .bind(to: presenter.loginButtonDidTap)
            .disposed(by: disposeBag)
        
        //Receive output
        presenter.usernameState?.drive(onNext: {
            [weak self] value in
                if !value {
                    self?.txtUsername.backgroundColor = UIColor(red: 255/255, green: 159/255, blue: 152/255, alpha: 0.6)
                }
                else {
                    self?.txtUsername.backgroundColor = .clear
                }
            }, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
        
        presenter.passwordState?.drive(onNext: {
            [weak self] value in
                if !value {
                    self?.txtPassword.backgroundColor = UIColor(red: 255/255, green: 159/255, blue: 152/255, alpha: 0.6)
                }
                else {
                    self?.txtPassword.backgroundColor = .clear
                }
            }, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
        
        presenter.loginButtonState?.drive(onNext: {
                [weak self] value in
            if value {
                self?.btnLogin.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 0.6)
                self?.btnLogin.isUserInteractionEnabled = false
            }
            else {
                self?.btnLogin.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 255/255, alpha: 0.6)
                self?.btnLogin.isUserInteractionEnabled = true
            }
        }, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
        
        presenter.loginStatus.drive(onNext: {
            view in
            if let view = view {
                self.present(view, animated: true, completion: nil)
            }
        }, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
        
    }
}
