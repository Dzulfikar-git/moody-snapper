//
//  DailySnapItemView.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 21/05/23.
//

import SwiftUI

//struct DailySnapItemPreviewModel {
//    let id: UUID
//    let image: String
//    let mood_status: String
//    let snap_moment: String
//    let created_at: Date = Date.now
//}

struct DailySnapItemRowView: View {
    var dailySnapItem: DailySnapItems
    //    var dailySnapItem: DailySnapItems
    @State private var image: Image?
    
    var body: some View {
        HStack(spacing: 16) {
            if let image = image {
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                    .clipped()
            }
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Mood: \(dailySnapItem.mood_status!)")
                    .font(.headline)
                
                Text("Snap Moment: \(dailySnapItem.snap_moment!)")
                    .font(.subheadline)
                
                Text("Created At: \(dailySnapItem.created_at!)")
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 8)
        .onAppear {
            loadImageFromDocumentDirectory()
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

//struct DailySnapItemRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        DailySnapItemRowView(dailySnapItem: .init(id: UUID(), image: "asdasd", mood_status: "Happy", snap_moment: ""))
//    }
//}
