//
//  MapModel.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/04.
//

import Foundation
import MapKit

struct MapModel:Identifiable{
    let id = UUID()
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    let name: String
    let ImageName: String
    let reviews: [Review]
}

struct Review: Identifiable,Hashable {
    let id = UUID()
    let description: String
    let evaluation: Int
    let title: String
}


struct MockData {
    static let sample = MapModel(latitude: 35.561282, longitude: 139.711039, name: "西蒲田公園",ImageName: "bench", reviews: [Review(description: "良い！", evaluation: 0,title: "良い！"),Review(description: "悪い！", evaluation: 1,title: "悪い！")] )
}
