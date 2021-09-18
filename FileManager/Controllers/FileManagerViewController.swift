//
//  ViewController.swift
//  FileManager
//
//  Created by Misha on 08.09.2021.
//

import UIKit

class ViewController: UIViewController {
    
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
        print(documentsUrl)

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
        
        do {
            let filesInDirectory = try! fileManager.contentsOfDirectory(
                        at: documentsUrl,
                        includingPropertiesForKeys: nil,
                        options: [])
            
            let files = filesInDirectory
            if files.count > 0 {
                print("Documents has files")

            } else {
                print("files not foung")
            }
        } catch {}
    }
    
    //MARK: SAVE IMAGE
    func saveImage(imageName: String, image: UIImage) {

     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
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
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //MARK: CREATE FILE
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else { return }
                do {
                    //Присваиваю изображение
                    guard let image = info[.editedImage] as? UIImage else { return }
                    arrayOfImages.append(image)
                    print("Теперь в массиве фото: \(arrayOfImages)")
                    let fileURL = directory.appendingPathComponent(info.description)
                    arrayOfFilesName.append(fileURL!.lastPathComponent)
                    tableView.reloadData()
                    /*let data = UIImage(named: "бар2")?.pngData()
                    fileManager.createFile(
                        atPath: fileURL!.path,
                        contents: data,
                        attributes: [FileAttributeKey.creationDate: Date()])*/
                    print("Теперь в массиве названий фото: \(arrayOfFilesName)")
                } catch {
                    print(error)
                }
        
        print("Файл записан")
        dismiss(animated: true, completion: nil)
    }
}



extension ViewController: UITableViewDataSource, UITableViewDelegate {
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




