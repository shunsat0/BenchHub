//
//  PostBenchInfoView.swift
//  BenchHub
//
//  Created by SHUN SATO on 2024/11/18.
//

import SwiftUI
import MapKit
import SystemNotification
import WebUI
import _PhotosUI_SwiftUI

//TODO: 背景色の色とコンポーネントの色が逆かも
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
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    
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
        
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Text("ベンチの位置をタップしてください")
                            .font(.caption2)
                            .padding([.leading,.top])
                        Spacer()
                    }
                    
                    MapReader{ proxy in
                        //TODO: Mapの倍率を高くする
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
                        .padding()
                    }
                    
                    Divider()
                        .padding([.horizontal])
                    
                    HStack {
                        Text("場所名を入力してください")
                            .font(.caption2)
                            .padding([.leading,.top])
                        Spacer()
                    }
                    
                    TextEditor(text: $placeName)
                        .textEditorStyle(PlainTextEditorStyle())
                        .frame(height: 40)
                        .font(.body)
                        .background(Color.background)
                        .cornerRadius(10.0)
                        .submitLabel(.done)
                        .padding()
                        .focused($focusInputPlaceName)
                        .onSubmit {
                            focusInputPlaceName = false
                        }
                        .onTapGesture {
                            focusInputPlaceName = true
                        }
                    
                    Divider()
                        .padding([.horizontal])
                    
                    HStack {
                        Text("居心地を選択してください")
                            .font(.caption2)
                            .padding([.leading,.top,.bottom])
                        Spacer()
                    }
                    
                    HStack {
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
                                .imageScale(.large)
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
                                .imageScale(.large)
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                        
                    }
                    .padding([.horizontal,.bottom])
                    
                    Divider()
                        .padding([.horizontal])
                    
                    HStack {
                        Text("口コミを入力してください")
                            .font(.caption2)
                            .padding([.leading,.top])
                        Spacer()
                    }
                    
                    TextEditor(text: $text)
                        .textEditorStyle(PlainTextEditorStyle())
                        .frame(height: 120)
                        .font(.body)
                        .background(Color.background)
                        .cornerRadius(10.0)
                        .padding()
                        .focused($focusInputReview)
                        .submitLabel(.return)
                        .onTapGesture {
                            focusInputReview = true
                        }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    VStack {
                        ZStack(alignment: .topTrailing) {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                
                            }
                            
                            if(selectedImage != nil) {
                                Button(action: {
                                    selectedImage = nil
                                }, label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                })
                                .padding(.top,20)
                                .padding(.trailing,10)
                            }
                        }
                        
                        
                        HStack {
                            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                Label(
                                    title: { Text("写真を選ぶ") },
                                    icon: { Image(systemName: "photo") }
                                )
                                .padding(.leading)
                            }
                            .onChange(of: selectedPhotoItem) {
                                Task {
                                    guard let imageData = try await selectedPhotoItem?.loadTransferable(type: Data.self) else { return }
                                    guard let uiImage = UIImage(data: imageData) else { return }
                                    selectedImage = uiImage
                                }
                            }
                            
                            Spacer()
                        }
                        .padding()
                        
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    
                    HStack {
                        Spacer()
                        
                        Button("送信") {
                            newPost()
                        }
                        .disabled(!isInputAll)
                        
                        Spacer()
                    }
                    .padding()
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
        .background(Color.component)
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
