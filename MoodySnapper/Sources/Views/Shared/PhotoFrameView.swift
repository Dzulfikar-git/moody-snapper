//
//  PhotoFrameView.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 15/05/23.
//

import SwiftUI

struct PhotoFrameView: View {
    var photo: UIImage
    var emotion: Emotion
    @Binding var adjustedEmotion: Emotion?
    
    var body: some View {
        VStack {
            ZStack {
                // Background
                Color.white
                
                ZStack {
                    // Masking tape
                    Rectangle()
                        .frame(width: 200.0, height: 40.0)
                        .position(CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.minY))
                        .foregroundColor(Color("PhotoCardMaskingTape"))
                    // Card frame
                    VStack {
                        Image(uiImage: photo)
                            .resizable(resizingMode: .stretch)
                            .aspectRatio(contentMode: .fit)
                            .frame(height: UIScreen.main.bounds.height / 2.0)
                            .background(Color.gray)
                            .shadow(radius: 2.0)
                            .padding([.horizontal, .top], 32)
                        
                        Spacer()
                        
                        Text("You Look \(adjustedEmotion != nil ? adjustedEmotion!.rawValue : emotion.rawValue)")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                }
            }
            .rotationEffect(.degrees(-2))
            .frame(maxHeight: UIScreen.main.bounds.height / 1.5)
            .shadow(color: Color.gray, radius: 5, x: 0, y: 2)
        }
    }
}

//struct PhotoFrameView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoFrameView(photo: UIImage(systemName: "PlaceholderPhoto")!, emotion: Emotion.ANGRY)
//    }
//}
