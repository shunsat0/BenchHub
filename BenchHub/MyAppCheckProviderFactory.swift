//
//  MyAppCheckProviderFactory.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/18.
//

import Foundation
import FirebaseAppCheck
import FirebaseCore

class MyAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    return AppAttestProvider(app: app)
  }
}
