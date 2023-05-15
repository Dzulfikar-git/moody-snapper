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
    
    var body: some View {
        VStack {
            if emotion == nil {
                ProgressView()
            } else {
                Image(uiImage: originalPhoto)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text("You looked \(emotion!.rawValue)")
            }
        }.onAppear {
            Task {
                analyzeEmotion()
            }
        }
    }
    
    private func analyzeEmotion() {
        let model = CNNEmotions()
        guard let predictEmotion = try? model.prediction(data: ImageUtil.buffer(from: croppedPhoto)!) else { 
            fatalError("Unexpected Runtime Error")
        }
        
        emotion = Emotion(rawValue: predictEmotion.classLabel)
    }
}

struct AnalyzedImageView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyzedImageView(originalPhoto: .init(), croppedPhoto: .init())
    }
}
