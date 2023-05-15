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
    
//    private var emotion: Emotion
//    private var adjustedEmotion: Emotion?
    
    var body: some View {
        VStack {
            Image(uiImage: originalPhoto)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
//            Text("You looked \(emotion.rawValue)")
        }
    }
}

//struct AnalyzedImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnalyzedImageView()
//    }
//}
