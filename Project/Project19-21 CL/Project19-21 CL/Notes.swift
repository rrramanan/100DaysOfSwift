//
//  Notes.swift
//  Project19-21 CL
//
//  Created by R R on 05/02/21.
//

import UIKit

class Notes: NSObject,Codable {
    var title: String
    var content: String
    
    init(title: String,content: String) {
        self.title = title
        self.content = content
    }
    
}
