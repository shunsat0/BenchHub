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
    let reviews: [Review]
}

struct Review: Identifiable,Hashable {
    let id = UUID()
    let description: String
    let evaluation: Int
    let ImageUrl: String
}
