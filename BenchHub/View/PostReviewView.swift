//
//  PostReviewView.swift
//  BenchHub
//
//  Created by SHUN SATO on 2024/08/11.
//

import SwiftUI
import PhotosUI

struct PostReviewView: View {
    @State var isPressedThumbsUp: Bool = false
    @State var isPressedThumbsDown: Bool = false
    @Binding var isShowImagePicker: Bool
    @Binding var evaluation: Int
    @Binding var text: String
    var selectedMapInfo: MapModel
    var post = PostViewModel()
    @Binding var selectedImage: UIImage?
    @Binding var isGoodOrBad: Bool
    @FocusState var focus: Bool
    
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var image: UIImage? = nil
    
    @ObservedObject var detailViewModel: DetailViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("居心地")
                    .padding(.leading)
                
                Spacer()
                
                Group {
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
                }
                .foregroundColor(.secondary)
                .imageScale(.large)
            }
            .padding()
            
            Divider()
                .padding([.horizontal])
            
            HStack {
                VStack {
                    TextEditor(text: $text)
                        .textEditorStyle(PlainTextEditorStyle())
                        .frame(height: 120)
                        .keyboardType(.twitter)
                        .font(.body)
                        .background(Color.background)
                        .cornerRadius(10.0)
                        .focused($focus)
                }
                Spacer()
            }
            .padding([.horizontal])
            
            HStack {
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
                        if (isShowImagePicker) {
                            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                Label(
                                    title: { Text("写真を選ぶ") },
                                    icon: { Image(systemName: "photo") }
                                )
                            }
                            .onChange(of: selectedPhotoItem) {
                                Task {
                                    guard let imageData = try await selectedPhotoItem?.loadTransferable(type: Data.self) else { return }
                                    guard let uiImage = UIImage(data: imageData) else { return }
                                    selectedImage = uiImage
                                }
                            }
                        }
                        
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding()
            
            Divider()
                .padding([.horizontal])
        }
        .frame(width: 350)
        .background(Color.component)
        .cornerRadius(10)
        .padding()
        .onAppear {
            isShowImagePicker = true
        }
        .onChange(of: detailViewModel.isTapped) {
            focus = false
        }
        .onTapGesture {
            focus = false
        }
        
        
    }
}
