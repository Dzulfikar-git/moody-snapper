//
//  AnalyzedImageView.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 14/05/23.
//

import SwiftUI
import CoreData

struct AnalyzedImageView: View {
    @EnvironmentObject var analyzedImageStore: AnalyzedImageStore
    @Environment(\.managedObjectContext) var dailySnapsContext
    @Binding var navigationPath: NavigationPath
    var originalPhoto: UIImage
    var croppedPhoto: UIImage
    
    var body: some View {
        VStack {
            if analyzedImageStore.emotion == nil {
                ProgressView()
            } else {
                PhotoFrameView(photo: originalPhoto, emotion: analyzedImageStore.emotion!, adjustedEmotion: $analyzedImageStore.adjustedEmotion)
                    .padding(16.0)
                Spacer()
                
                HStack {
                    Button {
                        // handle change emotion value.
                        analyzedImageStore.isShowingEmotionActionSheet = true
                    } label: {
                        Text("Not \(analyzedImageStore.adjustedEmotion != nil ? analyzedImageStore.adjustedEmotion!.rawValue : analyzedImageStore.emotion!.rawValue)  ?")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    .clipped()
                    .confirmationDialog("Select Your Emotion!", isPresented: $analyzedImageStore.isShowingEmotionActionSheet, titleVisibility: .visible) {
                        ForEach(Emotion.allCases, id: \.self) { emotionData in
                            Button(emotionData.rawValue) {
                                analyzedImageStore.adjustedEmotion = emotionData
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        analyzedImageStore.isPresentingAddImageSheet = true
                    } label: {
                        Text("Add")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    .clipped()
                    .sheet(isPresented: $analyzedImageStore.isPresentingAddImageSheet, content: {
                        AnalyzedImageSheetView(isPresentingSheet: $analyzedImageStore.isPresentingAddImageSheet, comment: $analyzedImageStore.comment, onSaveClicked: {
                            // handle save.
                            // 1. check if today DailySnaps has been created
                            var todayDailySnap: DailySnaps? = analyzedImageStore.getTodayDailySnap(managedContext: dailySnapsContext)
                            
                            if todayDailySnap == nil {
                                todayDailySnap = analyzedImageStore.createTodayDailySnap(managedContext: dailySnapsContext)
                            }
                            
                            // 2. then create the daily snap items.
                            
                            analyzedImageStore.createDailySnapItems(photo: originalPhoto, snapMoment: analyzedImageStore.comment, moodStatus: analyzedImageStore.adjustedEmotion == nil ? analyzedImageStore.emotion! : analyzedImageStore.adjustedEmotion!, dailySnap: todayDailySnap!, managedContext: dailySnapsContext)
                            
                            analyzedImageStore.isPresentingAddImageSheet = false
                            analyzedImageStore.comment = ""
                            navigationPath.removeLast()
                        }, onCancelClicked: {
                            analyzedImageStore.isPresentingAddImageSheet = false
                            // reset the comment
                            analyzedImageStore.comment = ""
                        })
                    })
                }.padding([.horizontal], 16.0)
            }
        }
        .background(Color.whiteIvory)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            Task {
                analyzedImageStore.analyzeEmotion(photo: croppedPhoto)
            }
        }
        .onDisappear {
            Task {
                analyzedImageStore.adjustedEmotion = nil
            }
        }
    }
}

struct AnalyzedImageView_Previews: PreviewProvider {
    struct AnalyzedImageViewPreviewer: View {
        @State var navigationPath: NavigationPath = .init()
        var body: some View {
            AnalyzedImageView(navigationPath: $navigationPath, originalPhoto: UIImage(named: "PlaceholderPhoto")!, croppedPhoto:  UIImage(named: "PlaceholderPhoto")! ).environmentObject(AnalyzedImageStore.shared)
        }
    }
    
    static var previews: some View {
        AnalyzedImageViewPreviewer()
    }
}
