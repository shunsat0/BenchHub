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

@Observable
final class PostViewModel: ObservableObject {
    var isLoading = false
    var error: Error?
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    func addData(postData: PostModel) async {
        await MainActor.run { isLoading = true }
        
        do {
            let reviewRef = db.collection("benchData").document(postData.id)
            let document = try await reviewRef.getDocument()
            
            guard let documentData = document.data() else {
                throw NSError(domain: "PostViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document data not found"])
            }
            
            let newReview: [String: Any] = [
                "date": Timestamp(date: Date()),
                "description": postData.description ?? "",
                "evaluation": postData.evaluation,
                "image": postData.imageUrl ?? NSNull()
            ]
            
            var reviews = documentData["reviews"] as? [[String: Any]] ?? []
            reviews.append(newReview)
            
            try await reviewRef.updateData(["reviews": reviews])
            
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
