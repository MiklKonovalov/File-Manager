//
//  LoginViewController.swift
//  FileManager
//
//  Created by Misha on 10.09.2021.
//

import Foundation
import UIKit
import Locksmith

class LoginViewController: UIViewController {
    
    private var firstPass: String? = nil
    
    private var count = 0
    
    private var passwordTextField: UITextField = {
        let userNameTextField = UITextField()
        userNameTextField.layer.borderColor = UIColor.white.cgColor
        userNameTextField.layer.cornerRadius = 10
        userNameTextField.layer.backgroundColor = UIColor.systemGray6.cgColor
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.placeholder = "Password"
        userNameTextField.leftViewMode = .always
        return userNameTextField
    }()
    
    private var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = UIColor.blue
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var errorTextField: UILabel = {
        let errorTextField = UILabel()
        errorTextField.text = ""
        errorTextField.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        errorTextField.textColor = .red
        errorTextField.textAlignment = .center
        errorTextField.translatesAutoresizingMaskIntoConstraints = false
        return errorTextField
    }()
    
    @objc func logInButtonPressed() {
        //По нажатию кнопку в первый раз записываем пароль в массив
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "MyAccount")
        if count == 0 && dictionary == nil {
        print(count)
        if let pass = passwordTextField.text, passwordTextField.text?.count ?? 1 > 3 {
            firstPass = pass
        } else {
            errorTextField.text = "Пароль должен содержать не менее 4ёх символов"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.3) {
                self.errorTextField.alpha = 0
                self.logInButton.setTitle("Создайте пароль", for: .normal)
                self.passwordTextField.text = ""
                }
            }
            
        }
        
        //После первого ввода пароля меняем название кнопки и обнуляем текстовое поле
        logInButton.setTitle("Повторите пароль", for: .normal)
        passwordTextField.text = ""
        count += 1
        print("После первого нажатия кнопки count = \(count)")
        } else if count == 1 {
        //При втором нажатии кнопки сравниваем введённый пароль с текстовым полем и, если они совпадают, то записываем пароль в keyChain
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "MyAccount")
        if dictionary == nil {
        //Сохраняем данные в keychain
            if let password = passwordTextField.text, passwordTextField.text?.count ?? 1 > 3, passwordTextField.text == firstPass {
            do {
                try Locksmith.saveData(data: ["password" : password], forUserAccount: "MyAccount")
                print(password)
                let tabBarController = TabBarController()
                navigationController?.pushViewController(tabBarController, animated: true)
            } catch {
                print("Unable to save data or data has already saved")
            }
            } else {
                errorTextField.text = "Пароли не совподают"
                //Возвращаемся к созданию пароля
                firstPass = nil
                count -= 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 0.3) {
                    self.errorTextField.alpha = 0
                    self.logInButton.setTitle("Создайте пароль", for: .normal)
                    self.passwordTextField.text = ""
                    self.count = 0
                    print("Если подтверждение пароля не верно, то count = \(self.count)")
                    }
                }
            }
        }
    } else {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "MyAccount")
        if dictionary != nil {
            print("Словарь не пустой")
            for (_, value) in dictionary ?? [:] {
                if passwordTextField.text == value as? String {
                    print("Password is: \(value)")
                    let tabBarController = TabBarController()
                    navigationController?.pushViewController(tabBarController, animated: true)
                } else {
                    self.errorTextField.text = "Введён не верный пароль"
                }
            }
        }
    }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //загружаем данные из keychain
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "MyAccount")
        print(dictionary ?? [:])
        
        if dictionary != nil {
            logInButton.setTitle("Введите пароль", for: .normal)
        } else {
            logInButton.setTitle("Создать пароль", for: .normal)
        }

        view.backgroundColor = .white
        
        view.addSubview(passwordTextField)
        view.addSubview(logInButton)
        view.addSubview(errorTextField)
        
        let constraints = [
        
            passwordTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            logInButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: 0),
            logInButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 0),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            
            errorTextField.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 20),
            errorTextField.leadingAnchor.constraint(equalTo: logInButton.leadingAnchor, constant: 0),
            errorTextField.trailingAnchor.constraint(equalTo: logInButton.trailingAnchor, constant: 0)
        
        ]
        NSLayoutConstraint.activate(constraints)

    }
    
}
