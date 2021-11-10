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
        tableview.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    let tableVieCell = TableViewCell()
    
    var arrayOfFilesName = [String]()
    var arrayOfImages = [UIImage]()
    
    var characters = [String]() {
        didSet {
            print(characters)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if SettingsModel.sort == 1 {
            sortAndReload()
            tableview.reloadData()
        } else if SettingsModel.sort == 2 {
            unSortAndReload()
            tableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = FileManager.default
        
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add photo", style: .plain, target: self, action: #selector(addPhoto))
        
        setupTableView()
        checkDirectory()
        view.backgroundColor = .white
        
        //Получаем путь для Documents
        guard let documentsUrl = fileManager.urls(
            for: .documentDirectory,
                in: .userDomainMask).first else { return }
        
        //Распечатываем директорию для documentsUrl
        print("DocumentsURL:\(documentsUrl.path)")
        
        //Создаём файл
        /*let fileApple = documentsUrl.appendingPathComponent("Apple.txt")
        let fileBananas = documentsUrl.appendingPathComponent("Bananas.txt")
        let filePeach = documentsUrl.appendingPathComponent("Peach.txt")
        let fileMelon = documentsUrl.appendingPathComponent("Melon.txt")
        let fileFruits = documentsUrl.appendingPathComponent("fruits.txt")
            
        fileManager.createFile(atPath: fileApple.path, contents: nil, attributes: [FileAttributeKey.creationDate: Date()])
        fileManager.createFile(atPath: fileBananas.path, contents: nil, attributes: [FileAttributeKey.creationDate: Date()])
        fileManager.createFile(atPath: filePeach.path, contents: nil, attributes: [FileAttributeKey.creationDate: Date()])
        fileManager.createFile(atPath: fileMelon.path, contents: nil, attributes: [FileAttributeKey.creationDate: Date()])
        fileManager.createFile(atPath: fileFruits.path, contents: nil, attributes: [FileAttributeKey.creationDate: Date()])
            
        characters.append(fileApple.lastPathComponent)
        characters.append(fileBananas.lastPathComponent)
        characters.append(filePeach.lastPathComponent)
        characters.append(fileMelon.lastPathComponent)
        characters.append(fileFruits.lastPathComponent)*/
        
        /*let documentDirectoryPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let myFilesPath = "\(documentDirectoryPath)"
        let filemanager = FileManager.default
        let files = filemanager.enumerator(atPath: myFilesPath)
        while let file = files?.nextObject() {
            characters.append(file as! String)
        }*/
    }
    
    //MARK: CREATE NAVBAR
    func setNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .init(red: 249/255, green: 249/255, blue: 249/255, alpha: 0.94)
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add photo", style: .plain, target: self, action: #selector(addPhoto))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func sortAndReload() {
        characters.sort { (lhs: String, rhs: String) -> Bool in
            return lhs.compare(rhs, options: .caseInsensitive) == .orderedAscending
        }
        tableview.reloadData()
    }
    
    func unSortAndReload() {
        characters.sort { (lhs: String, rhs: String) -> Bool in
            return lhs.compare(rhs, options: .caseInsensitive) == .orderedDescending
        }
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
    
    //MARK: CHECK FILES INTO CATALOGUE
    func checkDirectory() {
        
        let documentDirectoryPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let myFilesPath = "\(documentDirectoryPath)"
        let filemanager = FileManager.default
        let files = filemanager.enumerator(atPath: myFilesPath)
        while let file = files?.nextObject() {
            arrayOfFilesName.append(file as! String)
            arrayOfImages.append(loadImageFromDiskWith(fileName: file as! String) ?? UIImage())

        }
        
        //Получаем путь для Documents
        /*guard let documentsUrl = fileManager.urls(
                for: .documentDirectory,
                in: .userDomainMask) else { return }
        
        do {
            let filesInDirectory = try fileManager.contentsOfDirectory(
                        at: documentsUrl,
                        includingPropertiesForKeys: nil,
                        options: [])
            
            let files = filesInDirectory
            if files.count > 0 {
                print("Documents has files")

            } else {
                print("files not foung")
            }
        } catch {
            print(error)
        }*/
    }
    
    //MARK: SAVE IMAGE
    func saveImage(imageName: String, image: UIImage) {

     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }

    }
    
    //MARK: LOAD IMAGE
    func loadImageFromDiskWith(fileName: String) -> UIImage? {

        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }

        return nil
    }
    
    //MARK: SELECTORS
    @objc func addPhoto() {
        showImagePickerController()
    }
}

extension FilesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfFilesName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = arrayOfFilesName[indexPath.row]
        
        cell.imageView?.image = arrayOfImages[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: IMAGE PICKER
extension FilesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //MARK: CREATE FILE
        
        guard let directory = try? FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: false)
                                                                as NSURL else { return }
        
        let path = String(info.description)
        print("ИМЯ ФАЙЛА: \(path)")
        let fileName = URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent
        print("НОВОЕ ИМЯ ФАЙЛА: \(fileName)")
        _ = directory.appendingPathComponent(fileName)
        
        //Получаем значение imageURL в коде из словаря info
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            let imagePath = imageURL.lastPathComponent
                    
        //Присваиваю изображение
            guard let image = info[.editedImage] as? UIImage else { return }
            saveImage(imageName: imagePath, image: image)
            arrayOfImages.append(image)
            print("Теперь в массиве фото: \(arrayOfImages)")
            arrayOfFilesName.append(imageURL.lastPathComponent)
            tableview.reloadData()
            print("Теперь в массиве названий фото: \(arrayOfFilesName)")
            print("Файл записан")
                
            dismiss(animated: true, completion: nil)
        } else {
            print("imageURL not correct")
        }
    }
}

