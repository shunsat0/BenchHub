//
//  NewReviewPostView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/04/29.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

final class NewReviewPostViewModel: ObservableObject {
    func postNewData(newPostData: NewPostModel) async {
        let db = Firestore.firestore()

        let customDocId = newPostData.id // place name
        let ref = db.collection("benchData").document(customDocId)
        
        // 位置情報
        let geopoint = GeoPoint(latitude: newPostData.latitude,longitude: newPostData.longitude)
        // Reviewを辞書に変換
        let reviewData: [String: Any] = [
            "date": Timestamp(date: Date()),
            "description": newPostData.description ?? nil,
            "evaluation": newPostData.evaluation,
            "image": newPostData.imageUrl ?? nil]
        
        do {
            try await ref.setData([
                "geopoint": geopoint,
                "name": customDocId,
                "reviews": [reviewData]
            ])
            print("Document added with custom ID: \(customDocId)")
        } catch {
            print("Error adding document: \(error)")
        }
    }

    
    
    func uploadImage(name: String, image: UIImage?)async-> String? {
        let id = UUID()
        
        guard let selectedImage = image, let imageData = selectedImage.jpegData(compressionQuality: 1.0) else {
            print("画像が選択されていない、または画像データを取得できませんでした")
            return nil
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
            return nil
        }
    }
}
