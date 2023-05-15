//
//  AnalyzedImageView.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 14/05/23.
//

import SwiftUI

struct AnalyzedImageView: View {
    var originalPhoto: UIImage
    var croppedPhoto: UIImage
    
    @State private var emotion: Emotion?
    @State private var adjustedEmotion: Emotion?
    @State private var isShowingEmotionActionSheet = false
    @State private var isPresentingAddImageSheet = false
    @State private var comment: String = ""
    
    var body: some View {
        VStack {
            if emotion == nil {
                ProgressView()
            } else {
                PhotoFrameView(photo: originalPhoto, emotion: emotion!, adjustedEmotion: $adjustedEmotion)
                    .padding(16.0)
                Spacer()
                
                HStack {
                    Button {
                        // handle change emotion value.
                        isShowingEmotionActionSheet = true
                    } label: {
                        Text("Not \(adjustedEmotion != nil ? adjustedEmotion!.rawValue : emotion!.rawValue)  ?")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    .clipped()
                    .confirmationDialog("Select Your Emotion!", isPresented: $isShowingEmotionActionSheet, titleVisibility: .visible) {
                        ForEach(Emotion.allCases, id: \.self) { emotionData in
                            Button(emotionData.rawValue) {
                                adjustedEmotion = emotionData
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        isPresentingAddImageSheet = true
                    } label: {
                        Text("Add")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    .clipped()
                    .sheet(isPresented: $isPresentingAddImageSheet, content: {
                        VStack {
                            HStack {
                                Button {
                                    isPresentingAddImageSheet = false
                                } label: {
                                    Text("Cancel")
                                }
                                
                                Spacer()
                                
                                Button {
                                    isPresentingAddImageSheet = false
                                    //TODO: Handle save data.
                                } label: {
                                    Text("Save")
                                }
                            }
                            
                            TextEditor(text: $comment)
                        }
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.hidden)
                    })
                }.padding([.horizontal], 16.0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            Task {
                analyzeEmotion()
            }
        }
    }
    
    private func analyzeEmotion() {
        let model = try? CNNEmotions(configuration: .init())
        guard let predictEmotion = try? model?.prediction(data: ImageUtil.buffer(from: croppedPhoto)!) else {
            fatalError("Unexpected Runtime Error")
        }
        
        emotion = Emotion(rawValue: predictEmotion.classLabel)
    }
}

struct AnalyzedImageView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyzedImageView(originalPhoto: UIImage(systemName: "PlaceholderPhoto")!, croppedPhoto: UIImage(systemName: "PlaceholderPhoto")!)
    }
}
