//
//  List.swift
//  FB-SwiftUI
//
//  Created by Jayabharathi Jayaraman on 2021-01-22.
//

import Foundation
import FirebaseFirestore


class ListName : ObservableObject {
    
    @Published var entries = [ListEntry]()
    
    private var db = Firestore.firestore()
    
    init(){
        fetchListFromDatabase()
    }
    
    func fetchListFromDatabase() {
            db.collection("List").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.entries = documents.map { (queryDocumentSnapshot) -> ListEntry in
                    let data = queryDocumentSnapshot.data()
                    let listTitle = data["listTitle"] as? String ?? ""
                    let docId = queryDocumentSnapshot.documentID
                    return ListEntry(docId: docId, listTitle: listTitle)
                    
                }
            }
        }
    /*func fetchListFromDatabase(){
        entries.append(ListEntry(listName: "Dag 1"))
                entries.append(ListEntry(listName: "Jag åt mat"))
                entries.append(ListEntry(listName: "Sov mest"))
                entries.append(ListEntry(listName: "Programmerade hela dagen"))
        
    }*/
    /*func fetchListFromDatabase(){
        db.collection("List").getDocuments {(snapshot, error)  in
            if let snapshot = snapshot{
                self.entries = snapshot.documents.map { doc in
                    return ["listTitle": doc.data()["listTitle"] as! String]
                }
                
            }
        }
        
    }*/
    }
