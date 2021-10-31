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
    
    var characters = [String]() {
        didSet {
            print(characters)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = FileManager.default
        
        setupTableView()
        view.backgroundColor = .white
        
        if SettingsModel.sort == 1 {
            sortAndReload()
            tableview.reloadData()
        } else if SettingsModel.sort == 0 {
            unSortAndReload()
            tableview.reloadData()
        }
        
        //Получаем путь для Documents
        guard let documentsUrl = fileManager.urls(
            for: .documentDirectory,
                in: .userDomainMask).first else { return }
        
        //Распечатываем директорию для documentsUrl
        print("DocumentsURL:\(documentsUrl.path)")
            
        //Создаём файл
        let fileApple = documentsUrl.appendingPathComponent("Apple.txt")
        let fileBananas = documentsUrl.appendingPathComponent("Bananas.txt")
        let filePeach = documentsUrl.appendingPathComponent("Peach.txt")
        let fileMelon = documentsUrl.appendingPathComponent("Melon.txt")
            
        fileManager.createFile(atPath: fileApple.path, contents: nil, attributes: [FileAttributeKey.creationDate: Date()])
        fileManager.createFile(atPath: fileBananas.path, contents: nil, attributes: [FileAttributeKey.creationDate: Date()])
        fileManager.createFile(atPath: filePeach.path, contents: nil, attributes: [FileAttributeKey.creationDate: Date()])
        fileManager.createFile(atPath: fileMelon.path, contents: nil, attributes: [FileAttributeKey.creationDate: Date()])
            
        characters.append(fileApple.lastPathComponent)
        characters.append(fileBananas.lastPathComponent)
        characters.append(filePeach.lastPathComponent)
        characters.append(fileMelon.lastPathComponent)
        
        
        let documentDirectoryPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let myFilesPath = "\(documentDirectoryPath)"
        let filemanager = FileManager.default
        let files = filemanager.enumerator(atPath: myFilesPath)
        while let file = files?.nextObject() {
            characters.append(file as! String)
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
