//
//  HomeView.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 14/05/23.
//

import SwiftUI
import PhotosUI
import CoreData
import SceneKit

struct HomeView: View {
    @EnvironmentObject var homeStore: HomeStore
    @StateObject var analyzedImageStore: AnalyzedImageStore = .shared
    @Environment(\.managedObjectContext) var dailySnapsContext
    
    @Binding var navigationPath: NavigationPath
    @State var selectedPhoto: PhotosPickerItem?
    @State var isProcessingImage: Bool = false
    @State var isShowingImageAlert: Bool = false
    @State private var selectedOriginalPhoto: UIImage?
    @State private var croppedOriginalPhoto: UIImage?
    @State private var currentMood: Emotion = Emotion.NEUTRAL
    @State private var pickedDate: Date = .now
    @State private var dailySnapItems: [DailySnapItems] = []
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                
                DatePicker(selection: $pickedDate, displayedComponents: .date, label: {
                })
                .frame(maxWidth: 100)
                
                Spacer()
                
                PhotosPicker(selection: $selectedPhoto, matching: .images, label: {
                    Image(systemName: "photo.circle.fill")
                })
            }
            if homeStore.todayDailySnap == nil {
                Text("Go Snap Your Mood!")
                SceneView(scene: SCNScene(named: "Fox_Sit2_Idle.scn"), options: [.autoenablesDefaultLighting])
                    .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height / 2)
            } else {
                Text("Your Mood is \(currentMood.rawValue)")
                let todayDailySnap = homeStore.todayDailySnap!
                SceneView(scene: SCNScene(named: EmotionScene.animation(emotion: currentMood)), options: [.autoenablesDefaultLighting])
                    .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height / 2)
                
                ScrollView {
                    ForEach(dailySnapItems, id: \.id) { snapItem in
                        DailySnapItemRowView(dailySnapItem: snapItem)
                            .onTapGesture {
                                navigationPath.append(DetailDailySnapItemRoutingPath(snapItem: snapItem))
                            }
                    }
                }
            }
            if isProcessingImage {
                Text("Image is loading, please wait...")
            }
        }
        .onAppear {
            Task {
                
                homeStore.todayDailySnap = homeStore.getTodayDailySnap()
                if homeStore.todayDailySnap != nil {
                    self.dailySnapItems = homeStore.getDailySnapItemsByDailySnap(dailySnap: homeStore.todayDailySnap!)
                    self.currentMood = Emotion.init(rawValue: homeStore.todayDailySnap!.latest_mood!).unsafelyUnwrapped
                }
            }
        }
        .onChange(of: selectedPhoto, perform: { _ in
            Task {
                await processPickerPhoto()
            }
        })
        .onChange(of: pickedDate, perform: { _ in
            Task {
                homeStore.todayDailySnap = homeStore.getDailySnapByDate(filterDate: pickedDate.formatted(date: .numeric, time: .omitted))
                if homeStore.todayDailySnap != nil {
                    self.dailySnapItems = homeStore.getDailySnapItemsByDailySnap(dailySnap: homeStore.todayDailySnap!)
                    self.currentMood = Emotion.init(rawValue: homeStore.todayDailySnap!.latest_mood!).unsafelyUnwrapped
                }
            }
        })
        .alert("Photo Error", isPresented: $isShowingImageAlert, actions: {
            Button("Ok", role: .cancel) {  }
        }, message: {
            Text("Face not found, please use another one")
        })
        .navigationDestination(for: AnalyzedImageViewRoutingPath.self, destination: { _ in
            if (selectedOriginalPhoto != nil) && (croppedOriginalPhoto != nil) {
                AnalyzedImageView(navigationPath: $navigationPath, originalPhoto: selectedOriginalPhoto!, croppedPhoto: croppedOriginalPhoto!)
                    .environmentObject(analyzedImageStore)
                    .environment(\.managedObjectContext, dailySnapsContext)
                    .onAppear {
                        isProcessingImage = false
                    }
            }
        })
        .navigationDestination(for: DetailDailySnapItemRoutingPath.self, destination: { snapItem in
            DetailDailySnapItemView(dailySnapItem: snapItem.dailySnapItem)
        })
    }
    
    func processPickerPhoto() async {
        isProcessingImage = true
        if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
            
            if let selectedPhoto = UIImage(data: data) {
                print("Image Loaded")
                
                FaceDetectionUtil.detectFace(image: selectedPhoto) { croppedFacePhoto in
                    if let croppedFacePhoto = croppedFacePhoto {
                        selectedOriginalPhoto = selectedPhoto
                        croppedOriginalPhoto = croppedFacePhoto
                        navigationPath.append(AnalyzedImageViewRoutingPath())
                    } else {
                        isShowingImageAlert = true
                    }
                }
            }
            print("Finish Detecting Image")
            isProcessingImage = false
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    struct HomeViewPreviewer: View {
        @State var navigationPath: NavigationPath = .init()
        
        var body: some View {
            HomeView(navigationPath: $navigationPath)
        }
    }
    
    static var previews: some View {
        HomeViewPreviewer()
    }
}
