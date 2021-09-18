//
//  ChangePasswordViewController.swift
//  FileManager
//
//  Created by Misha on 13.09.2021.
//

import Foundation
import UIKit
import Locksmith

class ChangePasswordViewController: UIViewController {
    
    let dictionary = Locksmith.loadDataForUserAccount(userAccount: "MyAccount")
    
    let newPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = UIColor.blue
        button.setTitle("Установить новый пароль", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(setNewPassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var newPasswordTextField: UITextField = {
        let newPasswordTextField = UITextField()
        newPasswordTextField.layer.borderColor = UIColor.white.cgColor
        newPasswordTextField.layer.cornerRadius = 10
        newPasswordTextField.layer.backgroundColor = UIColor.systemGray6.cgColor
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.placeholder = "Password"
        newPasswordTextField.leftViewMode = .always
        return newPasswordTextField
    }()
    
    @objc func setNewPassword() {
        if let password = newPasswordTextField.text {
            do {
                try Locksmith.updateData(data: ["password" : password], forUserAccount: "MyAccount")
                UserSettings.password = password
            } catch {
                print("Unable to create newpassword")
            }
        }
        self.dismiss(animated: true, completion: nil)
        print("Set new password")
        print(UserSettings.password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        
        view.addSubview(newPasswordButton)
        view.addSubview(newPasswordTextField)
        
        let constraints = [
        
            newPasswordButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            newPasswordButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            newPasswordButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            newPasswordButton.heightAnchor.constraint(equalToConstant: 50),
            
            newPasswordTextField.topAnchor.constraint(equalTo: newPasswordButton.bottomAnchor, constant: 20),
            newPasswordTextField.leadingAnchor.constraint(equalTo: newPasswordButton.leadingAnchor, constant: 0),
            newPasswordTextField.trailingAnchor.constraint(equalTo: newPasswordButton.trailingAnchor, constant: 0),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
