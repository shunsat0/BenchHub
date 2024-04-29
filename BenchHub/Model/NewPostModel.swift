//
//  NewPostModel.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/04/29.
//

import Foundation

struct NewPostModel {
    let id: String // Place Name
    let evaluation: Int // Good Or Bad
    let description: String // Review
    let imageUrl: String?// Image
    let latitude: Double
    let longitude: Double
}
