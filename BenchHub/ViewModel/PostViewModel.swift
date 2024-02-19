//
//  PostViewModel.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/13.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

final class PostViewModel: ObservableObject {
    
    func addData(postData: PostModel) async {
        let db = Firestore.firestore()
        let reviewRef = db.collection("benchData").document("\(postData.id)")
        let defaultImage = "https://1.bp.blogspot.com/-zPZ0OW06M0A/Xlyf6yxwZHI/AAAAAAABXq0/wxIcEtCRXbU0Vu2Ufogbb8iEG66KiZedACNcBGAsYHQ/s1600/no_image_logo.png"
        
        do {
            let document = try await reviewRef.getDocument()
            guard let documentData = document.data() else {
                print("エラー: データを取得できませんでした")
                return
            }
            
            // 新しいレビューを作成
            let newReview: [String: Any] = ["date": Timestamp(date: Date()), "description": postData.description ?? "", "evaluation": postData.evaluation,"image": postData.imageUrl ?? defaultImage]
            
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
    
    func uploadImage(name: String, image: UIImage?)async-> String? {
        let id = UUID()
        let defaultImage = "https://1.bp.blogspot.com/-zPZ0OW06M0A/Xlyf6yxwZHI/AAAAAAABXq0/wxIcEtCRXbU0Vu2Ufogbb8iEG66KiZedACNcBGAsYHQ/s1600/no_image_logo.png"
        
        guard let selectedImage = image, let imageData = selectedImage.jpegData(compressionQuality: 1.0) else {
            print("画像が選択されていない、または画像データを取得できませんでした")
            return defaultImage
        }
        
        let storageRef = Storage.storage().reference(forURL: "gs://benchhub-e9fca.appspot.com").child("\(name)/\(id)")
        
        do {
            // 画像データをアップロード
            let _ = try await storageRef.putDataAsync(imageData)
            // アップロード成功後、ダウンロードURLを取得
            let downloadURL = try await storageRef.downloadURL()
            
            print("ダウンロードURL: \(String(describing: downloadURL))")
            return downloadURL.absoluteString
        } catch {
            print("アップロードまたはダウンロードURLの取得に失敗しました: \(error.localizedDescription)")
            return defaultImage
        }
    }
}
