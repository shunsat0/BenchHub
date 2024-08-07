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
    @Environment(\.dismiss) var dismiss
    @State var isToggleOn = true
    @State var isNotificationOn = false
    @FocusState var focus:Bool
    
    var body: some View {
        VStack {
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
        }
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
                .onDisappear {
                    print("消えます")
                }
        }
    }
}

#Preview {
    SettingView()
}

struct PostBenchInfoView: View {
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var placeName: String = ""
    @State private var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    let locationManager = CLLocationManager()
    
    @State var isPressedThumbsUp: Bool = false
    @State var isPressedThumbsDown: Bool = false
    @State var isShowSheet: Bool = false
    @State var isShowImagePicker: Bool = false
    @State var evaluation: Int
    @State var text: String
    @State var selectedImage: UIImage?
    @State var isGoodOrBad: Bool
    @State var imageUrl: String?
    @FocusState var focusInputPlaceName:Bool
    @FocusState var focusInputReview:Bool
    
    @StateObject var post = NewReviewPostViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State var isInputAll: Bool = false
    
    @State var isPosting: Bool = false
    @State var isPosted: Bool = false
    
    func newPost() {
        isPosting = true
        Task {
            // 先に画像をアップロード
            imageUrl = await post.uploadImage(name: placeName, image: selectedImage)
            
            // データ全体をアップロード
            await post.postNewData(newPostData: NewPostModel(id: placeName, evaluation: evaluation, description: text, imageUrl: imageUrl, latitude: coordinate.latitude, longitude: coordinate.longitude))
            
            // 5秒間の遅延を挿入
            try await Task.sleep(nanoseconds: 5_000_000_000)
            
            isPosting = false
            isPosted.toggle()
        }
    }
    
    var body: some View {
        let place = [PostCoordinateModel(lat: coordinate.latitude, long: coordinate.longitude)]
        
        var isInputAll: Bool {
            return !placeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            coordinate.latitude != 0.0 &&
            coordinate.longitude != 0.0
        }
        
        
        ZStack(alignment: .topLeading) {
            
            Form {
                Section(header: Text("座標(ベンチの場所をタップしてください)")){
                    MapReader{ proxy in
                        Map(position: $position) {
                            Annotation("", coordinate: place[0].location) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(.orange)
                                    Text("🪑")
                                        .padding(5)
                                }
                            }
                        }
                        .frame(width: 300,height: 200)
                        .cornerRadius(10.0)
                        .mapControls {
                            MapUserLocationButton()
                                .mapControlVisibility(.hidden)
                        }
                        .task {
                            let manager = CLLocationManager()
                            manager.requestWhenInUseAuthorization()
                        }
                        .onTapGesture { position in
                            if let selectedCoordinate = proxy.convert(position, from: .local) {
                                coordinate = selectedCoordinate
                            }
                        }
                    }
                }
                
                Section(header: Text("場所名")) {
                    TextField(text: $placeName, prompt: Text("場所名")) {
                        Text("placeName")
                    }
                    .submitLabel(.done)
                    .focused($focusInputPlaceName)
                    .onSubmit {
                        focusInputPlaceName = false
                    }
                    .onTapGesture {
                        focusInputPlaceName = true
                    }
                }
                
                Section(header: Text("レビュー")) {
                    HStack {
                        Text("居心地")
                        
                        Spacer()
                        
                        Button(action: {
                            isPressedThumbsUp.toggle()
                            if isPressedThumbsUp {
                                isPressedThumbsDown = false
                            }
                            
                            isGoodOrBad = isPressedThumbsUp // ボタンが押されているかどうかの判別
                            
                            evaluation = 0 // good
                            
                        }, label: {
                            Image(systemName: "hand.thumbsup.circle.fill")
                                .foregroundColor(isPressedThumbsUp ? .accentColor : .secondary)
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            isPressedThumbsDown.toggle()
                            if isPressedThumbsDown {
                                isPressedThumbsUp = false
                            }
                            
                            isGoodOrBad = isPressedThumbsDown // ボタンが押されているかどうかの判別
                            
                            evaluation = 1 // bad
                        }, label: {
                            Image(systemName: "hand.thumbsdown.circle.fill")
                                .foregroundColor(isPressedThumbsDown ? .accentColor : .secondary)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    TextEditor(text: $text)
                        .frame(height: 80)
                        .font(.body)
                        .background(Color.background)
                        .cornerRadius(10.0)
                        .focused($focusInputReview)
                        .submitLabel(.return)
                        .onTapGesture {
                            focusInputReview = true
                        }

                    
                    HStack {
                        VStack {
                            Button("\(Image(systemName: "camera.fill"))あなたの写真を追加"){
                                isShowImagePicker = true
                            }
                            .foregroundColor(.accentColor)
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                }
                
                HStack {
                    Spacer()
                    
                    Button("送信") {
                        newPost()
                    }
                    .disabled(!isInputAll)
                    
                    Spacer()
                }
            }
            
            
            if(isPosting) {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .fullScreenCover(isPresented: $isPosted) {
            ZStack {
                VStack {
                    Text("投稿完了しました👏")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("閉じる")
                            .frame(width: 200, height: 50)
                    }
                    .accentColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10.0)
                    
                }
                
                
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
                    .modifier(ParticlesModifier())
                    .offset(x: -100, y : -50)
                
                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .modifier(ParticlesModifier())
                    .offset(x: 60, y : 70)
            }
        }
        .onTapGesture {
            focusInputPlaceName = false
            focusInputReview = false
        }
    }
}

#Preview {
    //SettingView()
    PostBenchInfoView(evaluation: 0, text: "", isGoodOrBad: false)
}
