//
//  Category.swift
//  SQLiteDB-iOS
//
//  Created by Fahim Farook on 6/11/15.
//  Copyright © 2015 RookSoft Pte. Ltd. All rights reserved.
//

import Foundation
import SQLite_swift_android

class Category: SQLTable {
    var name = ""

    var description: String {
        return "id: \(id), name: \(name)"
    }
}
