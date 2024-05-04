//
//  HelloView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/03/13.
//

import SwiftUI
import MapKit

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
        List {
            Section(header: Text("通知")){
                NavigationLink(
                    destination: EmptyView(),
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
                        destination:  EmptyView(),
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
        .navigationTitle("設定")
    }
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
    @State var isPosting: Bool = false
    @FocusState var focus:Bool
    
    @StateObject var post = NewReviewPostViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State var isInputAll: Bool = false
    
    
    init(evaluation: Int, text: String, isGoodOrBad: Bool) {
        self.evaluation = evaluation
        self.text = text
        self.isGoodOrBad = isGoodOrBad
    }
    
    func newPost() {
        isPosting = true
        Task {
            // 先に画像をアップロード
            imageUrl = await post.uploadImage(name: placeName, image: selectedImage)
            
            // データ全体をアップロード
            await post.postNewData(newPostData: NewPostModel(id: placeName, evaluation: evaluation, description: text, imageUrl: imageUrl, latitude: coordinate.latitude, longitude: coordinate.longitude))
            
            // 1秒間の遅延を挿入
            try await Task.sleep(nanoseconds: 5_000_000_000)
            
            isPosting = false
            
            dismiss()
        }
    }
    
    var body: some View {
        let place = [PostCoordinateModel(lat: coordinate.latitude, long: coordinate.longitude)]
        
        var isInputAll: Bool {
            return !placeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
//                   selectedImage != nil &&
//                   imageUrl != &&
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
                        .textEditorStyle(PlainTextEditorStyle())
                        .frame(height: 80)
                        .keyboardType(.twitter)
                        .font(.body)
                        .background(Color.background)
                        .cornerRadius(10.0)
                        .focused($focus)
                    
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
                    .sheet(isPresented: $isShowImagePicker) {
                        ImagePicker(image: $selectedImage)
                    }
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
    }
}


#Preview {
    //SettingView()
    PostBenchInfoView(evaluation: 0, text: "", isGoodOrBad: false)
}
