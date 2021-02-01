import SwiftUI
import FirebaseFirestore
import Firebase

struct ListItemView : View {
    
    var list : ListName
    var entry : ListItemEntry? = nil
    private let defaultContent = "Today I..."
    var entry1: ListEntry 
    
    @State private var content : String = ""
    var db = Firestore.firestore()
    
    var date : String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        var date = ""
        
        if let entry = entry {
            date = formatter.string(from: entry.date)
        } else {
            date = formatter.string(from: Date())
        }
        return date
    }
    
    var body: some View {
        
        VStack {
            //Text(date)
            TextEditor(text: $content ).onTapGesture {
                //     clearText()
                
            }
            Button(action: {
                print("hi")
                if let documentId = entry1.docId {
                    print("hi1")
                    print(documentId)
                    db.collection("List").document(documentId).updateData(["listItems": FieldValue.arrayUnion([content])
                    ]) { error in
                    if let error = error{
                        print("error")
                    } else{
                        print ("Data is inserted")
                    }
                }
                }
            }) {
                Text("Save")
            }
        }.onAppear() {
            setContent()
        }.navigationBarItems(trailing: Button("Save") {
            
            /*if let documentId = entry?.docId {
            db.collection("List").document((entry?.docId!)!).setData(["listItem" : content]) { error in
                if let error = error{
                    print("error")
                } else{
                    print ("Data is inserted")
                }
            }
            }*/
            //saveEntry()
        })
        
        
    }
    
    func insert(){
        if let documentId = entry?.docId {
            db.collection("List").document(documentId).updateData(["listItems": FieldValue.arrayUnion([content])
            ]) { error in
            if let error = error{
                print("error")
            } else{
                print ("Data is inserted")
            }
        }
        }
    }
    private func clearText() {
        if(entry == nil) {
            content = ""
        }
        
    }
    
    
    private func setContent() {
        if let content = entry?.listItem {
            self.content = content
        } else {
            self.content = defaultContent
        }
    }
    
    
    private func saveEntry() {
        /*  // update existing entry in Journal
         if let entry = entry {
         if let index = list.entries.firstIndex(of: entry) {
         list.entries[index].content = self.content
         }
         }
         // add new entry to journal
         else {
         let newEntry = ListItemEntry(listItem: content)
         list.entries.append(newEntry)
         }
         }*/
        if let documentId = entry?.docId{
        db.collection("List").document((entry?.docId!)!).setData(["listItem" : content]) { error in
            if let error = error{
                print("error")
            } else{
                print ("Data is inserted")
            }
        }
    }
    
}
}


struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(list: ListName(), entry: ListItemEntry(listItem: "Bra dag"), entry1: ListEntry(listTitle: "Bra dag"))
    }
}
