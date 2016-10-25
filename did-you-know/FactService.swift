//
//  FactService.swift
//  did-you-know
//
//  Created by Alvaro De la Cruz on 24/10/16.
//  Copyright © 2016 Alvaro De La Cruz. All rights reserved.
//

import Foundation

struct FactService: RouterObject {
    private let rootPath = "/fact"
    
    func findAll() -> String {
        return rootPath
    }
}
