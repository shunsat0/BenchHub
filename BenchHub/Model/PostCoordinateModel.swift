//
//  PostCoordinateModel.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/04/06.
//

import Foundation
import MapKit

struct PostCoordinateModel: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    init(id: UUID = UUID(), lat: Double, long: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
}
