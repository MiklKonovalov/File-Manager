//
//  ViewController.swift
//  FileManager
//
//  Created by Misha on 08.09.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let fileManager = FileManager.default
    
    let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = UIImage(named: "бар2")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        return profileImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(profileImageView)
        
        setNavigationBar()
        
        //Получаем путь для Documents
        let documentsUrl = try! fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
        //Распечатываем директорию для documentsUrl
        print(documentsUrl)
        
        let constraints = [
        
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        
        ]
        NSLayoutConstraint.activate(constraints)
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
    
    @objc func addPhoto() {
        showImagePickerController()
    }
}

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
                    let fileURL = directory.appendingPathComponent("image.jpg")
                    let data = UIImage(named: "бар2")?.pngData()
                    fileManager.createFile(
                        atPath: fileURL!.path,
                        contents: data,
                        attributes: [FileAttributeKey.creationDate: Date()])
                } catch {
                    print(error)
                }
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = originalImage
        }
        
        print("Foto has already choosen")
        
        let documentsUrl = try! fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
    
        let content = try! fileManager.contentsOfDirectory(
                    at: documentsUrl,
                    includingPropertiesForKeys: nil,
                    options: [])
                
        content.forEach {
            print("url is: \($0.absoluteURL)")
        }
        
        dismiss(animated: true, completion: nil)
    }
}




