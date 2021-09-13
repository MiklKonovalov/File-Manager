//
//  UserSettings.swift
//  FileManager
//
//  Created by Misha on 13.09.2021.
//

import Foundation

final class UserSettings {
    
    private enum SettingsKeys: String {
        case password
    }
    
    static var password: String? {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.password.rawValue)
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.password.rawValue
            if let password = newValue {
                print("\(password) is \(key)")
                defaults.set(password, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
//    init(password: String) {
//        self.password = password
//    }
}
