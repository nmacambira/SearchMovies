//
//  ServiceUrl.swift
//  SearchMovies
//
//  Created by Natalia Macambira on 17/02/18.
//  Copyright © 2018 Natalia Macambira. All rights reserved.
//

import Foundation

enum ServiceUrl {
    case search
    case movie
    
    var baseUrl: String {
        return "https://api.themoviedb.org/3/"
    }
    
    var path: String {
        switch self {
        case .search: return "search/movie?api_key=9fb1244aab053cf93fa00223bef8e80f&query="
        case .movie: return "movie/%s?api_key=9fb1244aab053cf93fa00223bef8e80f&append_to_response=videos"
        }
    }
    
    var url: String {
        return baseUrl + path
    }
    
    var responseKeyPath: String {
        switch self {
        case .search: return "results"
        case .movie: return ""
        }
    }
    
    var imageBaseUrl: String {
        return "https://image.tmdb.org/t/p/w780"
    }
    
    var videoBaseUrl: String {
        return "https://www.youtube.com/watch?v="
    }
}
