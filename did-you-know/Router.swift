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

enum Router<T where T : RouterObject>: URLRequestConvertible {
    case findAll(T)
    
    var method: Alamofire.Method {
        switch self {
        case .findAll:return .GET
        }
    }
    
    var path: String {
        switch self {
        case .findAll(let object): return object.findAll()
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let url = NSURL(string: baseUrl)
        return NSMutableURLRequest(URL: (url?.URLByAppendingPathComponent(path))!)
    }
    
}