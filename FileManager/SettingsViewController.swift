//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Misha on 12.09.2021.
//

import Foundation
import UIKit

protocol FilesViewControllerDelegate {
    
    func sortAndReload()
}

class SettingsViewController: UIViewController {
    
    var delegate: FilesViewControllerDelegate?
    
    let changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = UIColor.blue
        button.setTitle("Изменить пароль", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
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
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(changeAlphabetRange), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func changeAlphabetRange() {
        let filesViewControlle = FilesViewController()
        sortAlphabetRange()
        filesViewControlle.sortAndReload()
        
    }
    
    @objc func changePassword() {
        let changePasswordViewController = ChangePasswordViewController()
        present(changePasswordViewController, animated: true, completion: nil)
    }
    
    func sortAlphabetRange() {
        delegate?.sortAndReload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        view.addSubview(changePasswordButton)
        view.addSubview(changeAlphabetButton)
        
        let constraints = [
        
            changePasswordButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            changePasswordButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            changePasswordButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 50),
            
            changeAlphabetButton.topAnchor.constraint(equalTo: changePasswordButton.bottomAnchor, constant: 20),
            changeAlphabetButton.leadingAnchor.constraint(equalTo: changePasswordButton.leadingAnchor, constant: 0),
            changeAlphabetButton.trailingAnchor.constraint(equalTo: changePasswordButton.trailingAnchor, constant: 0),
            changeAlphabetButton.heightAnchor.constraint(equalToConstant: 50),
        
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
