//
//  ImagePathTransform.swift
//  Natalia Macambira
//
//  Created by Natalia Macambira on 17/02/18.
//  Copyright © 2018 Natalia Macambira. All rights reserved.
//

import ObjectMapper

final class ImagePathTransform: TransformType {
    public typealias Object = String
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        guard let string = value as? String else {
            return nil
        }
        let baseUrl = ServiceUrl.movie.imageBaseUrl
        let path = baseUrl + string
        return path
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        guard let string = value else {
            return nil
        }
        let baseUrl = ServiceUrl.movie.imageBaseUrl
        let range = string.range(of: baseUrl)!
        let path = string.replacingCharacters(in: range, with: "")
        return path
    }
}
