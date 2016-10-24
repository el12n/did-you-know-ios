//
//  Router.swift
//  did-you-know
//
//  Created by Alvaro De La Cruz on 10/24/16.
//  Copyright © 2016 Alvaro De La Cruz. All rights reserved.
//

import Foundation
import Alamofire

let baseUrl = "http://did-you-know.herokuapp.com/api"

enum Router<T>: URLRequestConvertible where T : RouterObject {

    case findAll(T)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .findAll:return .get
        }
    }
    
    var path: String {
        switch self {
        case .findAll(let object): return object.findAll()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseUrl)
        return URLRequest(url: (url?.appendingPathComponent(path))!)
    }
    
    
    
}
