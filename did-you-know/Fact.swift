//
//  Fact.swift
//  did-you-know
//
//  Created by Alvaro De La Cruz on 10/24/16.
//  Copyright © 2016 Alvaro De La Cruz. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Dictionary where Value: Equatable{
    func keysForValue(value: Value) -> [Key] {
        return flatMap { (key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }
}

struct Fact{
    
    let languagesDef = [
        "en": "English",
        "es": "Spanish",
        "fr": "French"
    ]
    
    fileprivate let rootPath = "/fact"
    
    var value: String?
    var lang: String?
    
    init(){
        
    }
    
    init(json: JSON){
        self.value = json["value"].stringValue
        self.lang = json["lang"].stringValue
    }
}

extension Fact {
    func getLanguage() -> String{
        return self.languagesDef[self.lang!]!
    }
    func getLanguageCode(lang: String) -> String{
        return self.languagesDef.keysForValue(value: lang)[0]
    }
    func getLanguagesList() -> [String]{
        return self.languagesDef.map{"\($1)"}
    }
}
