//
//  Video.swift
//  SearchMovies
//
//  Created by Natalia Macambira on 17/02/18.
//  Copyright © 2018 Natalia Macambira. All rights reserved.
//

import RealmSwift
import ObjectMapper

final class Video: Object, Mappable {
    
    @objc dynamic var identifier = 0
    @objc dynamic var name = ""
    @objc dynamic var key = ""    
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        name <- map["name"]
        key <- map["key"]
    }
}
