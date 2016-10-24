//
//  Fact.swift
//  did-you-know
//
//  Created by Alvaro De La Cruz on 10/24/16.
//  Copyright © 2016 Alvaro De La Cruz. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Fact: RouterObject{
    fileprivate let rootPath = "/fact"
    
    var value: String?
    var lang: String?
    
    init(){
        
    }
    
    init(json: JSON){
        self.value = json["value"].stringValue
        self.lang = json["lang"].stringValue
    }
    
    func findAll() -> String {
        return rootPath
    }
}

extension Fact {
    func getLanguage() -> String{
        switch self.lang! {
        case "en": return "English"
        case "es": return "Spanish"
        case "fr": return "French"
        default: return ""
        }
    }
}
