//
//  UserModel.swift
//  FileManager
//
//  Created by Misha on 12.09.2021.
//

import Foundation
import UIKit

class UserModel {
    let name: String
    let surname: String
    let city: String
    
    init(name: String, surname: String, city: String) {
        self.name = name
        self.surname = surname
        self.city = city
    }
}
