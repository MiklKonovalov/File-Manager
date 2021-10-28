//
//  TabBarController.swift
//  FileManager
//
//  Created by Misha on 12.09.2021.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    let filesViewController = FilesViewController()
    let settingsViewController = SettingsViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        settingsViewController.callback = {
            self.sortAndReload()
        }
        
        settingsViewController.callbackUnsort = {
            self.unSortAndReload()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewControllers([filesViewController, settingsViewController], animated: false)
        
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "files")
        myTabBarItem1.title = "Файлы"
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "settings")
        myTabBarItem2.title = "Настройки"
        
    }
    
    func sortAndReload() {
        filesViewController.characters.sort()
        filesViewController.tableview.reloadData()
    }
    
    func unSortAndReload() {
        filesViewController.characters.sort(by: >)
        filesViewController.tableview.reloadData()
    }
}
