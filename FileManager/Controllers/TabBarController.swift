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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        self.setViewControllers([filesViewController, settingsViewController], animated: false)
        
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "files")
        myTabBarItem1.title = "Файлы"
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "settings")
        myTabBarItem2.title = "Настройки"
        
    }
    
}
