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
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com:443/v0/b/benchhub-e9fca.appspot.com/o/%E8%A5%BF%E8%92%B2%E7%94%B0%E5%85%AC%E5%9C%92%2FD7B625B6-C808-4231-B44C-F43B39B7C1B6?alt=media&token=34afca05-eff5-40cd-b5c2-b89dc80f4894")
        
        VStack {
            Button {
                Task {
                    await fetchData()
                }
            } label: {
                Text("Fire Storeのデータを読み取る")
            }
            
            AsyncImage(url: imageUrl) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 240, height: 126)
        }
        
    }
}

#Preview {
    TestView()
}
