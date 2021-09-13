//
//  FilesViewController.swift
//  FileManager
//
//  Created by Misha on 12.09.2021.
//

import Foundation
import UIKit

class FilesViewController: UIViewController, FilesViewControllerDelegate {
        
    var settingsViewController = SettingsViewController()
    
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var characters = ["Link", "Zelda", "Ganondorf", "Midna"] {
        didSet {
            print(characters)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        view.backgroundColor = .green
        
        tableView.dataSource = self
        
        settingsViewController.delegate = self
        
    }
    
    func sortAndReload() {
        characters.sort()
        tableView.reloadData()
    }
    
//    func reverseSort() {
//        for i in characters {
//            let reversed = characters.sorted { $0 > $1 }
//        }
//        characters.reverse()
//        tableView.reloadData()
//    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
