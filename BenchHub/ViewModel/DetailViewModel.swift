//
//  DetailViewModel.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/07.
//

import Foundation

final class DetailViewModel: ObservableObject {
    
    var selectedFramework: MapModel?
    var isProgress:Bool = false
    @Published var isTapped : Bool = false
    
}
