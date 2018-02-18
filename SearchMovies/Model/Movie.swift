//
//  Movie.swift
//  SearchMovies
//
//  Created by Natalia Macambira on 17/02/18.
//  Copyright © 2018 Natalia Macambira. All rights reserved.
//

import RealmSwift
import ObjectMapper

final class Movie: Object, Mappable {
    
    @objc dynamic var identifier = 0
    @objc dynamic var title = ""
    @objc dynamic var synopsis = ""
    @objc dynamic var backdrop = ""
    @objc dynamic var poster = ""
    var videos = List<Video>()
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        title <- map["title"]
        synopsis <- map["overview"]
        poster <- (map["poster_path"], ImagePathTransform())
        backdrop <- (map["backdrop_path"], ImagePathTransform())
        videos <- (map["videos.results"], ListTransform<Video>())
    }
}
