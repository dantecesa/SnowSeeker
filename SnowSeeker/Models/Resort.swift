//
//  Resort.swift
//  SnowSeeker
//
//  Created by Dante Cesa on 3/5/22.
//

import SwiftUI

struct Resort: Codable, Identifiable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
    
    var facilityTypes: [Facility] {
        facilities.map(Facility.init)
    }
    
    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example: Resort = allResorts[0]
    
    //static let example = (Bundle.main.decode("resorts.json") as [Resort])[0]
}
