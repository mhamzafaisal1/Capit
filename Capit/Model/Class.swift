//
//  Class.swift
//  Capit
//
//  Created by Abdullah on 29/02/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import Foundation
import RealmSwift

class Class: Object {
    @objc dynamic var title: String = ""
    let notes = List<Note>()
}
