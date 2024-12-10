//
//  HelloView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/03/13.
//

import SwiftUI
import MapKit
import SystemNotification
import WebUI
import _PhotosUI_SwiftUI

struct SettingMenue: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let url: String
}

private var settings = [
    SettingMenue(name: "よくある質問",icon: "questionmark.circle",url: "https://community.inkdrop.app/note/5f46d1d5c439602613e138872cde6149/note:K4XCCb5XR"),
    SettingMenue(name: "利用規約",icon: "doc.plaintext",url: "https://community.inkdrop.app/note/5f46d1d5c439602613e138872cde6149/note:1ZbR7W81S"),
    SettingMenue(name: "プライバシーポリシー",icon: "hand.raised",url: "https://community.inkdrop.app/note/5f46d1d5c439602613e138872cde6149/note:muqknPaYI")
]


struct SettingView: View {
    // TODO: backgroundcolorをAssetsの色に変更する
    @Environment(\.dismiss) var dismiss
    @State var isToggleOn = true
    @State var isNotificationOn = false
    @FocusState var focus:Bool
    
    var body: some View {
        List {
            Section(header: Text("通知")){
                HStack {
                    Image(systemName: "bell")
                        .foregroundColor(.accentColor)
                    Toggle("お知らせ", isOn: $isToggleOn)
                }
                
            }
            Section(header: Text("その他")){
                ForEach(settings) { setting in
                    NavigationLink(
                        destination: WebView(request: URLRequest(url: URL(string: setting.url)!)),
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
            Section(header: Text("口コミ")){
                NavigationLink(
                    destination: PostBenchInfoView(evaluation: 0, text: "", isGoodOrBad: false),
                    label: {
                        HStack {
                            Image(systemName: "chair")
                                .foregroundColor(.accentColor)
                            Text("ベンチ情報を追加")
                        }
                    }
                )
            }
        }
        .scrollContentBackground(.hidden)
        .onChange(of: isToggleOn) {
            if(isToggleOn == true) {
                isNotificationOn = true
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                isNotificationOn = false
                UIApplication.shared.unregisterForRemoteNotifications()
            }
        }
        .systemNotification(isActive: $isNotificationOn) {
            Text("新着情報をプッシュ通知でお知らせします🔔")
                .padding()
        }
    }
}

#Preview {
    SettingView()
}
