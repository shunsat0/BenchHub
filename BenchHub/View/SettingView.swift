//
//  HelloView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/03/13.
//

import SwiftUI

import SwiftUI

struct SettingMenue: Identifiable, Hashable {
    let name: String
    let icon: String
    let id = UUID()
}

private var settings = [
    
    SettingMenue(name: "よくある質問",icon: "questionmark.circle"),
    SettingMenue(name: "利用規約",icon: "doc.plaintext"),
    SettingMenue(name: "プライバシーポリシー",icon: "hand.raised")
]



struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationView {
            List {
                
                Section(header: Text("通知")){
                    NavigationLink(
                        destination: ContentView(),
                        label: {
                            HStack {
                                Image(systemName: "bell")
                                    .foregroundColor(.accentColor)
                                Text("通知設定")
                            }
                        }
                    
                    )
                }
                Section(header: Text("その他")){
                    ForEach(settings) { setting in
                        NavigationLink(
                            destination: ContentView(),
                            label: {
                                HStack {
                                    Image(systemName: setting.icon)
                                        .foregroundColor(.accentColor)
                                    Text(setting.name)
                                }
                            }
                        )
                        
                    }
                }
            }
        }
        .navigationTitle("設定")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                Button(
                    action: {
                        dismiss()
                    }, label: {
                        Text("\(Image(systemName: "chevron.backward"))戻る")
                    }
                ).tint(.accentColor)
            }
        }
    }
}

#Preview {
    SettingView()
}
