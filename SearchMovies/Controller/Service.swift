//
//  Service.swift
//  SearchMovies
//
//  Created by Natalia Macambira on 16/02/18.
//  Copyright © 2018 Natalia Macambira. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

final class Service {
//    typealias ArrayCompletionHandler<T: Mappable> = ([T]?, _ error: Error?) -> Void
    typealias ArrayCompletionHandler = (_ resultArray: [Movie]?, _ error: Error?) -> Void
    typealias ObjectCompletionHandler = (_ resultValue: Movie?, _ error: Error?) -> Void
    
    static func searchMovies(_ title: String, completionHandler: @escaping ArrayCompletionHandler) {
        let trimTitle = title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let codifyTitle = trimTitle.replacingOccurrences(of: " ", with: "+")
        let url = ServiceUrl.search.url + codifyTitle
    
        Alamofire.request(url).validate().responseArray(keyPath: ServiceUrl.search.responseKeyPath) { (response: DataResponse<[Movie]>) in
            switch response.result {
            case .success(let resultArray):
                print("Validation Successful")
//                print(resultArray)
                completionHandler(resultArray, nil)
            case .failure(let error):
                print("Validation Failure: " + error.localizedDescription)
                completionHandler(nil, error)
            }
        }
    }
    
    static func getDetails(_ id: String, completionHandler:@escaping ObjectCompletionHandler) {
        let url = ServiceUrl.movie.url.replacingOccurrences(of: "%s", with: id)

        Alamofire.request(url).validate().responseObject(keyPath: ServiceUrl.movie.responseKeyPath) { (response: DataResponse<Movie>) in
            switch response.result {
            case .success(let resultValue):
                print("Validation Successful")
//                print(resultValue)
                completionHandler(resultValue, nil)
            case .failure(let error):
                print("Validation Failure: " + error.localizedDescription)
                completionHandler(nil, error)

            }
        }
    }

}
