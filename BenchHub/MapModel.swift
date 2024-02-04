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
}

struct MockData {
    static let mapData = [
        MapModel(latitude: 35.561282, longitude: 139.711039, name: "西蒲田公園",ImageName: ""),
        MapModel(latitude: 35.562362, longitude: 139.715177, name: "蒲田駅西口", ImageName: "")
    ]
}
