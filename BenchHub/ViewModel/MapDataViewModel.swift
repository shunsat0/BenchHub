//
//  MapDataViewModel.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/06.
//

import Foundation
import FirebaseFirestore

class MapDataViewModel: ObservableObject {
    @Published var mapData = [MapModel]()
    
//    init() {
//        Task {
//            await fetchData()
//        }
//    }
    
    func fetchData() async {
        let db = Firestore.firestore()
        
        do {
            let snapshot = try await db.collection("benchData").getDocuments()
            for document in snapshot.documents {
                let data = document.data()
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let geoPoint = data["coordinate"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
                let latitude = geoPoint.latitude
                let longitude = geoPoint.longitude
                let imageName = "bench"
                let model = MapModel(latitude: latitude, longitude: longitude, name: name, ImageName: imageName, description: description)
                mapData.append(model)

            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
}
