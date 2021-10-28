//
//  FilesViewController.swift
//  FileManager
//
//  Created by Misha on 12.09.2021.
//

import Foundation
import UIKit

class FilesViewController: UIViewController {
    
    let tableview: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = UIColor.white
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    var characters = ["Яблоко", "Банан", "Абрикос", "Персик"] {
        didSet {
            print(characters)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        view.backgroundColor = .white
        
        if SettingsModel.sort == 1 {
            sortAndReload()
            tableview.reloadData()
        } else if SettingsModel.sort == 1 {
            unSortAndReload()
            tableview.reloadData()
        }
    }
    
    func sortAndReload() {
        characters.sort()
        tableview.reloadData()
    }
    
    func unSortAndReload() {
        characters.sort(by: >)
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
