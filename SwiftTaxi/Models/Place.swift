//
//  Place.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import Foundation

struct Place: Equatable, Identifiable, Hashable {
    var id: String {
        return name
    }
    
    let name: String
}
