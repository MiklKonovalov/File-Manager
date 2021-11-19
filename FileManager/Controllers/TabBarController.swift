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
        
        if SettingsModel.sort == 0 || SettingsModel.sort == 2 {
            unSortAndReload()
        } else if SettingsModel.sort == 1 {
            sortAndReload()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewControllers([filesViewController, settingsViewController], animated: false)
        
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(systemName: "folder")
        myTabBarItem1.title = "Файлы"
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(systemName: "gear")
        myTabBarItem2.title = "Настройки"
    }
    
    func sortAndReload() {
        filesViewController.arrayOfFilesName.sort { (lhs: String, rhs: String) -> Bool in
            return lhs.compare(rhs, options: .caseInsensitive) == .orderedAscending
        }
        filesViewController.tableview.reloadData()
    }
    
    func unSortAndReload() {
        filesViewController.arrayOfFilesName.sort { (lhs: String, rhs: String) -> Bool in
            return lhs > rhs && lhs.compare(rhs, options: .caseInsensitive) == .orderedDescending
        }
        filesViewController.tableview.reloadData()
    }

}
