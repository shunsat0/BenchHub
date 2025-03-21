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

@Observable
final class NewReviewPostViewModel: ObservableObject {
    var isLoading = false
    var error: Error?
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    func postNewData(newPostData: NewPostModel) async {
        await MainActor.run { isLoading = true }
        
        do {
            let ref = db.collection("benchData").document(newPostData.id)
            let geopoint = GeoPoint(latitude: newPostData.latitude,
                                  longitude: newPostData.longitude)
            
            let reviewData: [String: Any] = [
                "date": Timestamp(date: Date()),
                "description": newPostData.description,
                "evaluation": newPostData.evaluation,
                "image": newPostData.imageUrl ?? nil
            ]
            
            try await ref.setData([
                "geopoint": geopoint,
                "name": newPostData.id,
                "reviews": [reviewData]
            ])
            
            await MainActor.run { isLoading = false }
        } catch {
            await MainActor.run {
                self.error = error
                self.isLoading = false
            }
        }
    }
    
    func uploadImage(name: String, image: UIImage?) async -> String? {
        guard let image = image,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        
        let id = UUID().uuidString
        let storageRef = storage.reference(forURL: "gs://benchhub-e9fca.appspot.com")
            .child("\(name)/\(id)")
        
        do {
            _ = try await storageRef.putDataAsync(imageData)
            let downloadURL = try await storageRef.downloadURL()
            return downloadURL.absoluteString
        } catch {
            await MainActor.run { self.error = error }
            return nil
        }
    }
}
