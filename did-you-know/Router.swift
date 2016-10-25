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

    case findAll(String?, T)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .findAll:return .get
        }
    }
    
    var result: (path: String, parameters: Parameters) {
        switch self {
        case .findAll(let query, let object): return (object.findAll(), query != nil ? ["lang":query!] : Parameters())
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseUrl)
        let urlRequest = URLRequest(url: (url?.appendingPathComponent(result.path))!)
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
    
}
