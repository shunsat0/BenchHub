//
//  MapViewModel.swift
//  BenchHub
//
//  Created by Shun Sato on 2023/12/31.
//

import Foundation
import Firebase
import FirebaseFirestore

class MapViewModel: ObservableObject {
    @Published var posts: [Post] = []

    init() {
        loadData()
    }

    func loadData() {
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.posts = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Post.self)
                } ?? []
            }
        }
    }
}
