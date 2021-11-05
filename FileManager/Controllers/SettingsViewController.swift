//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Misha on 12.09.2021.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    var callback: (() -> Void)?
    
    var callbackUnsort: (() -> Void)?
    
    let changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = UIColor.blue
        button.setTitle("Изменить пароль", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let changeAlphabetButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = UIColor.blue
        button.setTitle("Поменять алфавитный порядок", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(changeAlphabetRange), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let sortTextField: UILabel = {
        let sortTextField = UILabel()
        sortTextField.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        sortTextField.textColor = .green
        sortTextField.textAlignment = .center
        sortTextField.translatesAutoresizingMaskIntoConstraints = false
        return sortTextField
    }()
    
    @objc func changeAlphabetRange() {
        
        if SettingsModel.sort == 0 || SettingsModel.sort == 2 {
            callback?()
            SettingsModel.sort = 1
            sortTextField.text = "Показан алфавитный порядок"
        } else if SettingsModel.sort == 1 {
            callbackUnsort?()
            SettingsModel.sort = 2
            sortTextField.text = "Показан обратный порядок"
        }
    }
    
    @objc func changePassword() {
        let changePasswordViewController = ChangePasswordViewController()
        present(changePasswordViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        view.addSubview(changePasswordButton)
        view.addSubview(changeAlphabetButton)
        view.addSubview(sortTextField)
        
        if SettingsModel.sort == 1 {
            sortTextField.text = "Показан в алфавитном порядке"
        } else if SettingsModel.sort == 2 {
            sortTextField.text = "Показан обратный порядок"
        }
        
        let constraints = [
        
            changePasswordButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            changePasswordButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            changePasswordButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 50),
            
            changeAlphabetButton.topAnchor.constraint(equalTo: changePasswordButton.bottomAnchor, constant: 20),
            changeAlphabetButton.leadingAnchor.constraint(equalTo: changePasswordButton.leadingAnchor, constant: 0),
            changeAlphabetButton.trailingAnchor.constraint(equalTo: changePasswordButton.trailingAnchor, constant: 0),
            changeAlphabetButton.heightAnchor.constraint(equalToConstant: 50),
            
            sortTextField.topAnchor.constraint(equalTo: changeAlphabetButton.bottomAnchor, constant: 20),
            sortTextField.leadingAnchor.constraint(equalTo: changeAlphabetButton.leadingAnchor, constant: 0),
            sortTextField.trailingAnchor.constraint(equalTo: changeAlphabetButton.trailingAnchor, constant: 0),
            sortTextField.heightAnchor.constraint(equalToConstant: 50),
        
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
