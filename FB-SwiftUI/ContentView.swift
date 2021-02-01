//
//  ContentView.swift
//  FB-SwiftUI
//
//  Created by Jayabharathi Jayaraman on 2021-01-20.
//

import SwiftUI
import FirebaseFirestore
import Firebase
import UserNotifications

struct ContentView: View {
    @ObservedObject var list = ListName()
    @State private var listTitle: String = ""
    @State var addNewListAlert = false
    @State private var listName: String = ""
    @State private var score: Int = 2
    @State private var editMode = EditMode.inactive
    @State private var showingAlert = false
    var entry : ListEntry
    var itemEntry: ListItemEntry
    var db = Firestore.firestore()
    
    var body: some View {
        
        /*   VStack{
         TextField("Add New List", text: $listTitle, onEditingChanged: {_ in }, onCommit: {
         self.saveList()
         }).textFieldStyle(RoundedBorderTextFieldStyle())
         Spacer()
         }.padding()*/
        VStack{
            NavigationView {
                
                
                List(){
                    ForEach(list.entries) { entry in
                        NavigationLink(
                            destination: ListItemView(list: list, entry: itemEntry, entry1: entry)) {
                         CardView(entry: entry)
                                .contextMenu{
                                    VStack{
                                        Button(action: {
                                            // change country setting
                                            //editListAlertView(listName: listName)
                                            let alert = UIAlertController(title: "Edit List", message: "", preferredStyle: .alert)
                                            alert.addTextField{
                                                listName in listName.placeholder = "Enter name of the list"
                                            }
                                            
                                            let saveAction = UIAlertAction(title: "SAVE", style: .default) { (_) in
                                               listName = alert.textFields![0].text!
                                            
                                                db.collection("List").document(entry.docId!).setData(["listTitle" : listName]) { error in
                                                    if let error = error{
                                                        print("error")
                                                    } else{
                                                        print ("Data is updated")
                                                    }
                                                }
                                            }
                                            let cancelAction = UIAlertAction(title: "CANCEL", style: .destructive) { (_) in
                                            }
                                            alert.addAction(cancelAction)
                                            alert.addAction(saveAction)
                                            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {

                                            })
        
                                            
                                        }) {
                                            Text("Edit")
                                        }
                                        
                                        Button(action: {
                                            // enable geolocation
                                        }) {
                                            Text("Cancel")
                                        }
                                        Button(action: {
                                            if let documentId = entry.docId{
                                            db.collection("List").document(documentId).delete{
                                                error in
                                                if let error = error{
                                                    print(error.localizedDescription)
                                                    print("Hello")
                                                } else {
                                                    //self.list.fetchListFromDatabase()
                                                    print("deleteSuccess")
                                                    
                                                }
                                            }
                                               
                                        }
                                        }) {
                                            Text("Delete")
                                        }
                                    }
                                }
                        }
                    
                   // .onDelete(perform: self.deleteListInDB)
                    }.onDelete(perform: { indexSet in
                        list.entries.remove(atOffsets: indexSet)
                        if let documentId = entry.docId{
                        db.collection("List").document(documentId).delete{
                            error in
                            if let error = error{
                                print(error.localizedDescription)
                                print("Hello")
                            } else {
                                //self.list.fetchListFromDatabase()
                                print("deleteSuccess")
                                
                            }
                        }
                           
                    }
                        
                       })
                    .listRowBackground(Color.blue)
                }
                .navigationBarTitle("Lists")
                .navigationBarItems(trailing:   Button(action: {
                    addNewListAlertView()
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(width: 75, height: 75, alignment: .bottomLeading)
                })
            }
            .onAppear() {
                self.list.fetchListFromDatabase()
            }
            Spacer()
            
        }
        
    }
    
  /*  func deleteListInDB(at indexSet: IndexSet){
        //indexSet.forEach {index in
        //  let task = self.$list[index]
        db.collection("List").document("1iFUJgUkxIkx2uB3aai9").delete{
            error in
            if let error = error{
                print(error.localizedDescription)
                print("Hello")
            } else {
                //self.list.fetchListFromDatabase()
                print("deleteSuccess")
                
            }
        }
    }*/
    func deleteListInDB(){
        //indexSet.forEach {index in
        //  let task = self.$list[index]
        if let documentId = entry.docId{
        db.collection("List").document(documentId).delete{
            error in
            if let error = error{
                print(error.localizedDescription)
                print("Hello")
            } else {
                //self.list.fetchListFromDatabase()
                print("deleteSuccess")
                
            }
        }
           
    }
}
    func sendNotification(){
        print("notification")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){
            success, error in
            if success{
                print("Success")
            } else if let error = error {
                print("error")
            }
        }
        print("notification1")
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Shopping List"
        notificationContent.body = "You have some to buy for today"
        
        print("notification2")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(req)
        
    }
    func addNewListAlertView(){
        let alert = UIAlertController(title: "New List", message: "", preferredStyle: .alert)
        alert.addTextField{
            listName in listName.placeholder = "Enter name of the list"
        }
        
        let createAction = UIAlertAction(title: "CREATE", style: .default) { (_) in
            listName = alert.textFields![0].text!
            insertListInDB()
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .destructive) { (_) in
        }
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {

        })
        
    }
    
    func editListAlertView(listName: String){
        let alert = UIAlertController(title: "Edit List", message: "", preferredStyle: .alert)
        alert.addTextField{
            listName in listName.placeholder = "Enter name of the list"
        }
        
        let saveAction = UIAlertAction(title: "SAVE", style: .default) { (_) in
            self.listName = alert.textFields![0].text!
            let listName = self.listName
            db.collection("List").document(entry.docId!).setData(["listTitle" : listName]) { error in
                if let error = error{
                    print("error")
                } else{
                    print ("Data is updated")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .destructive) { (_) in
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {

        })
    }
    
    func insertListInDB(){
        
        db.collection("List").addDocument(data: ["listTitle" : listName]) { error in
            if let error = error{
                print("error")
            } else{
                print ("Data is inserted")
            }
        }
    }
    
    /*func updateListInDB(){
        if let docId = entry.docId{
        db.collection("List").document(docId).setData(["listTitle" : listName]) { error in
            if let error = error{
                print("error")
            } else{
                print ("Data is updated")
            }
        }
    }
}*/
    
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(entry: ListEntry(listTitle: "Bra dag"), itemEntry: ListItemEntry(listItem: "Hello"))
    }
}

struct RowView : View {
    
    var entry : ListEntry
    var date : String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        let date = formatter.string(from: entry.date)
        return date
        
    }
    
    
    var body: some View {
        HStack {
            Text(date)
            Text(entry.listTitle)
            //Text(entry.docId!)
            
        }
    }
    
    
}


/*private func saveList(){
 
 db.collection("listName").addDocument(data: ["listTitle" : listTitle]) { error in
 if let error = error{
 print("error")
 } else{ print ("Data is inserted")}
 
 }
 }*/

