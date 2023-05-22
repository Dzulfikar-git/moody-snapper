//
//  DetailDailySnapItemView.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 21/05/23.
//

import SwiftUI

struct DetailDailySnapItemView: View {
    var dailySnapItem: DailySnapItems
    @State private var image: Image?
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
                    VStack(alignment: .leading) {
                        if let image = image {
                            image.resizable(resizingMode: .stretch)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: UIScreen.main.bounds.height / 2.0)
                                .background(Color.gray)
                                .shadow(radius: 2.0)
                                .padding([.horizontal, .top], 32)
                        } else {
                            Image("PlaceholderPhoto").resizable(resizingMode: .stretch)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: UIScreen.main.bounds.height / 2.0)
                                .background(Color.gray)
                                .shadow(radius: 2.0)
                                .padding([.horizontal, .top], 32)
                        }
                        
                        Spacer()
                        
                        Group {
                            Text("You had a \(dailySnapItem.mood_status!) moment")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding([.bottom], 8.0)
                            
                            Text("Test\(dailySnapItem.snap_moment!)")
                                .font(.body)
                        }.padding([.horizontal], 32.0)
                        
                        Spacer()
                    }
                }
            }
            .onAppear {
                Task {
                    loadImageFromDocumentDirectory()
                }
            }
            .rotationEffect(.degrees(-2))
            .frame(maxHeight: UIScreen.main.bounds.height / 1.5)
            .shadow(color: Color.gray, radius: 5, x: 0, y: 2)
            .padding([.horizontal], 16.0)
        }
    }
    
    private func loadImageFromDocumentDirectory() {
        // Provide the URL of the image file in the document directory
        let imageURL = getDocumentDirectoryURL().appendingPathComponent(dailySnapItem.image!)
        
        // Create a UIImage from the image file
        if let uiImage = UIImage(contentsOfFile: imageURL.path) {
            // Convert the UIImage to SwiftUI's Image
            image = Image(uiImage: uiImage)
        }
    }
    
    private func getDocumentDirectoryURL() -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory
    }
}

//struct DetailDailySnapItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailDailySnapItemView()
//    }
//}
