//
//  HelloView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/03/13.
//

import SwiftUI

struct SettingView: View {
    @Binding var showSearchSheet:Bool
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    SettingView(showSearchSheet: .constant(false))
}
