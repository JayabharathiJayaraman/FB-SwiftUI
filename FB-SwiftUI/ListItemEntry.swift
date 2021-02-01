//
//  ListItemEntry.swift
//  FB-SwiftUI
//
//  Created by Jayabharathi Jayaraman on 2021-01-27.
//

import Foundation
struct ListItemEntry : Identifiable {
    
    var id = UUID()
    var docId : String?
    var listItem : String
    var date : Date = Date()
}
