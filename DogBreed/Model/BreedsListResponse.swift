//
//  BreedsListResponse.swift
//  RandomDog
//
//  Created by Bold Lion on 5.01.20.
//  Copyright © 2020 Bold Lion. All rights reserved.
//

import Foundation

struct BreedsListResponse: Codable {
    let status: String
    let message: [String : [String]]
}
