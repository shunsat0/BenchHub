//
//  PostViewModel.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/13.
//

import Foundation
import FirebaseFirestore

final class PostViewModel: ObservableObject {
    func addData(postData: PostModel) async {
        let db = Firestore.firestore()
        let reviewRef = db.collection("benchData").document("\(postData.id)")
        
        do {
            let document = try await reviewRef.getDocument()
            guard let documentData = document.data() else {
                print("エラー: データを取得できませんでした")
                return
            }
            
            // 新しいレビューを作成
            let newReview: [String: Any] = ["date": Timestamp(date: Date()), "description": postData.description, "evaluation": postData.evaluation]
            
            // 既存の`reviews`フィールドを取得し、新しいレビューを追加
            var reviews = documentData["reviews"] as? [[String: Any]] ?? []
            reviews.append(newReview)
            
            // Firestoreに更新したreviews配列を書き込み
            try await reviewRef.updateData(["reviews": reviews])
            print("Document successfully updated")
        } catch {
            print("Error updating document: \(error)")
        }
    }
}
