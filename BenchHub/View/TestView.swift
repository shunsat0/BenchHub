//
//  TestView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/06.
//

import SwiftUI
import FirebaseFirestore

struct TestView: View {
    
    let db = Firestore.firestore()
    
    func fetchData() async {
        do {
            let snapshot = try await db.collection("benchData").getDocuments()
            for document in snapshot.documents {
                print("\(document.documentID) => \(document.data())")
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
    
    var body: some View {
        
        VStack {
            Button {
                Task {
                    await fetchData()
                }
            } label: {
                Text("Fire Storeのデータを読み取る")
            }
        }
        
    }
}

#Preview {
    TestView()
}
