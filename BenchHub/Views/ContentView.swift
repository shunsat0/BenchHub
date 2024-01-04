//
//  ContentView.swift
//  BenchHub
//
//  Created by Shun Sato on 2023/12/29.
//

import SwiftUI

struct ContentView: View {
    // 入力中の文字列を保持する状態変数
    @State var inputText: String = ""
    // 検索キーワードを保持する状態変数、初期値は"東京駅"
    @State var displaySearchKey: String = "東京駅"
    // マップ種類　最初は標準
    @State var dispalayMapType: MapType = .standard
    
    var body: some View {
        // テキストフィールド
        TextField("キーワード", text: $inputText, prompt: Text("地名を入力してください"))
        // 入力が完了した時
            .onSubmit {
                displaySearchKey = inputText
            }
        
            .padding()
        
        ZStack(alignment: .bottomTrailing){
            MapView(searchKey: displaySearchKey , mapType: dispalayMapType)
            
            VStack {
                Button {
                    if dispalayMapType == .standard {
                        dispalayMapType = .hybrid
                    }else{
                        dispalayMapType = .standard
                    }
                }label: {
                    Image(systemName: "map.circle")
                        .resizable()
                        .frame(width: 35.0,height: 35.0)
                }
                .padding(.trailing, 20.0)
                .padding(.bottom, 35.0)
                
                
                Button {
                    // 現在地に戻る
                    print("現在地へ戻る")
                }label: {
                    Image(systemName: "location.fill")
                        .resizable()
                        .frame(width: 35.0,height: 35.0)
                }
                .padding(.trailing, 20.0)
                .padding(.bottom, 30.0)

                
            }
            
        }
    }
}

#Preview {
    ContentView()
}
