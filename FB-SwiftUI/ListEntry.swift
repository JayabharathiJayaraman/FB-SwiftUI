//
//  ListEntry.swift
//  FB-SwiftUI
//
//  Created by Jayabharathi Jayaraman on 2021-01-22.
//

import Foundation

struct ListEntry : Identifiable {
    
    var id = UUID()
    var docId : String?
    var listTitle : String
    var date : Date = Date()
}
