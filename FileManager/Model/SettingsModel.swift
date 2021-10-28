//
//  SettingsModel.swift
//  FileManager
//
//  Created by Misha on 27.10.2021.
//

import Foundation

final class SettingsModel {
     
    private enum SettingsKeys: Int {
        case sort
    }
    
    static var sort: Int! {
        get {
            return UserDefaults.standard.integer(forKey: "sort")
        } set {
            //Устанавливаем новое значение и сохраняем в UserDefaults
            let defaults = UserDefaults.standard
            let key = SettingsKeys.sort.rawValue
            if let value = newValue {
                print("Новое значение: \(key)")
                defaults.setValue(value, forKey: "sort")
            }
        }
    }
}
