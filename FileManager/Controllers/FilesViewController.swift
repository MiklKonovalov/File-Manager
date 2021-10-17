//
//  FilesViewController.swift
//  FileManager
//
//  Created by Misha on 12.09.2021.
//

import Foundation
import UIKit

class FilesViewController: UIViewController, FilesViewControllerDelegate {
        
    let settingsViewController = SettingsViewController()
    
    let tableview: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = UIColor.white
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    var characters = ["Link", "Zelda", "Ganondorf", "Midna"] {
        didSet {
            print(characters)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sortAndReload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupTableView()
        view.backgroundColor = .white
        settingsViewController.delegate = self
        
    }
    
    func sortAndReload() {
        characters.sort()
        tableview.reloadData()
    }
    
    func setupTableView() {
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableview)
        
        let constraints = [
            tableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    
        tableview.dataSource = self
        tableview.dataSource = self
      }
}

extension FilesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = characters[indexPath.row]
        print(cell)
        return cell
        
    }
    
}
