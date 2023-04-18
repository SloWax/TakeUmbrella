//
//  Paser.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2022/07/21.
//  Copyright © 2022 SloWax. All rights reserved.
//

import Foundation

class Paser: JSONDecoder {
    
    static let dateFormat = "E, dd MMM yyyy HH:mm:ss z"
    
    override init() {
        super.init()

        self.keyDecodingStrategy = .convertFromSnakeCase

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Paser.dateFormat
        self.dateDecodingStrategy = .formatted(dateFormatter)
    }
}
