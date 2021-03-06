//
//  ViewController.swift
//  FileManager
//
//  Created by Misha on 08.09.2021.
//

import UIKit

class FileManagerViewController: UIViewController {
    
    let fileManager = FileManager.default
    
    let path = Bundle.main.resourcePath!
    
    let tableVieCell = TableViewCell()
    
    var arrayOfFilesName = [String]()
    var arrayOfImages = [UIImage]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        setupTableView()
        setNavigationBar()
        checkDirectory()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        print(arrayOfFilesName)
        print(arrayOfImages)
        
        //Получаем путь для Documents
        let documentsUrl = try! fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
        
        //Распечатываем директорию для documentsUrl
        print("DocumentsURL:\(documentsUrl.path)")

    }
    
    //MARK: CREATE TABLEVIEW
    func setupTableView() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
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
        
        let documentsUrl = try! fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
        
            let filesInDirectory = try! fileManager.contentsOfDirectory(
                        at: documentsUrl,
                        includingPropertiesForKeys: nil,
                        options: [])
            
            let file = filesInDirectory
            if file.count > 0 {
                print("Documents has files")

            } else {
                print("files not foung")
            }

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


//MARK: IMAGE PICKER
extension FileManagerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //MARK: CREATE FILE
        
        //Получаем значение imageURL в коде из словаря info
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            let imagePath = imageURL.lastPathComponent
            
            //Присваиваю изображение
            guard let image = info[.editedImage] as? UIImage else { return }
            saveImage(imageName: imagePath, image: image)
            arrayOfImages.append(image)
            print("Теперь в массиве фото: \(arrayOfImages)")
            arrayOfFilesName.append(imageURL.lastPathComponent)
            tableView.reloadData()
            print("Теперь в массиве названий фото: \(arrayOfFilesName)")
            print("Файл записан")
            
            dismiss(animated: true, completion: nil)
        } else {
            print("imageURL not correct")
        }
       
    }
}



extension FileManagerViewController: UITableViewDataSource, UITableViewDelegate {
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




