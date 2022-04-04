//
//  Notes.swift
//  Capit
//
//  Created by Abdullah on 29/02/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import Foundation
import RealmSwift

class Note: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var dateCreated: Date?
    var parentClass = LinkingObjects(fromType: Class.self, property: "notes")
}
