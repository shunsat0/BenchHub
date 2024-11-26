//
//  MapDataViewModel.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/06.
//

import Foundation
import FirebaseFirestore

final class MapDataViewModel: ObservableObject {
    @Published private(set) var mapData = [MapModel]()
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    private let db = Firestore.firestore()
    
    func fetchData() async {
        await MainActor.run { isLoading = true }
        
        do {
            let snapshot = try await db.collection("benchData").getDocuments()
            var newMapData: [MapModel] = []
            
            for document in snapshot.documents {
                if let model = try? createMapModel(from: document) {
                    newMapData.append(model)
                }
            }
            
            await MainActor.run {
                self.mapData = newMapData
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                self.isLoading = false
            }
        }
    }
    
    private func createMapModel(from document: QueryDocumentSnapshot) throws -> MapModel {
        let data = document.data()
        let name = data["name"] as? String ?? ""
        let geoPoint = data["geopoint"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
        
        var reviews: [Review] = []
        if let reviewsData = data["reviews"] as? [[String: Any]] {
            reviews = reviewsData.compactMap { reviewData in
                let description = reviewData["description"] as? String ?? ""
                let evaluation = reviewData["evaluation"] as? Int ?? 0
                let imageUrl = reviewData["image"] as? String ?? ""
                let timestamp = reviewData["date"] as? Timestamp
                let date = timestamp?.dateValue() ?? Date()
                
                return Review(description: description,
                            evaluation: evaluation,
                            ImageUrl: imageUrl,
                            date: date)
            }.sorted { $0.date > $1.date }
        }
        
        return MapModel(latitude: geoPoint.latitude,
                       longitude: geoPoint.longitude,
                       name: name,
                       reviews: reviews)
    }
}
