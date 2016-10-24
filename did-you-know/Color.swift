//
//  Color.swift
//  did-you-know
//
//  Created by Alvaro De La Cruz on 10/24/16.
//  Copyright © 2016 Alvaro De La Cruz. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Color: RouterObject {
    
    fileprivate let rootPath = "/colors"
    
    var name: String?
    var hex: String?
    
    init(){
        
    }
    
    init(json: JSON){
        self.name = json["name"].stringValue
        self.hex = json["hex"].stringValue
    }
    
    func getRandomColor() -> Color? {
        let defaults = UserDefaults.standard
        if let colors = defaults.array(forKey: "appColors"){
            let jsonColors = JSON(colors)
            let randomNumber = Int(arc4random_uniform(UInt32(jsonColors.arrayValue.count)))
            return(Color(json: jsonColors.arrayValue[randomNumber]))
        }
        return nil
    }
    
    func findAll() -> String {
        return rootPath
    }
}

extension Color {
    func getHexCode() -> Int? {
        if let code = self.hex {
            return Int(strtoul(code.replacingOccurrences(of: "#", with: ""), nil, 16))
        }
        return nil
    }
}
