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
    @State private var scnScene: SCNScene = SCNScene(named: "Fox_Sit2_Idle.scn")!
    @State private var capturedImage: UIImage?
    @State private var isShowingCamera = false
    
    var body: some View {
        VStack(spacing: 0) {
            if isProcessingImage == true {
                ProgressView()
            } else {
                HStack(alignment: .center) {
                    DatePicker(selection: $pickedDate, displayedComponents: .date, label: {
                    })
                    .frame(maxWidth: 100)
                }.padding([.bottom], 16.0)
                
                if homeStore.todayDailySnap == nil {
                    SceneView(scene: scnScene, options: [.autoenablesDefaultLighting])
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .padding([.horizontal], 15)
                    
                    Text("You Don't Have Snap Moments!")
                        .font(.sfMonoBold(fontSize: 24.0))
                        .padding([.bottom], 4.0)
                    
                    if pickedDate == Date.now {
                        Text("Go Snap Your Mood!")
                            .font(.sfMonoBold(fontSize: 18.0))
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                } else {
                    Text("Your Mood is \(currentMood.rawValue)")
                        .font(.sfMonoBold(fontSize: 18.0))
                        .fontWeight(.bold)
                    SceneView(scene: scnScene, options: [.autoenablesDefaultLighting])
                        .frame(maxWidth: .infinity, maxHeight: 500)
                        .padding([.horizontal], 15)
                    
                    ScrollView {
                        ForEach(dailySnapItems, id: \.id) { snapItem in
                            DailySnapItemRowView(dailySnapItem: snapItem)
                                .onTapGesture {
                                    navigationPath.append(DetailDailySnapItemRoutingPath(snapItem: snapItem))
                                }
                        }
                    }.padding([.horizontal], 16.0)
                }
            }
        }
        .safeAreaInset(edge: VerticalEdge.bottom, alignment: .center) {
            if isProcessingImage == true {
                EmptyView()
            } else {
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    PhotosPicker(selection: $selectedPhoto, matching: .images, label: {
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                    })
                    Button {
                        isShowingCamera = true
                    } label: {
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.primaryColor)
                            .padding([.horizontal], 32.0)
                    }
                    Spacer()
                }
                .background(Color.whiteIvory)
            }
        }
        .sheet(isPresented: $isShowingCamera, content: {
            CameraView(capturedImage: $capturedImage)
        })
        .onChange(of: capturedImage, perform: { _ in
            Task {
                await processCapturedPhoto()
            }
        })
        .onAppear {
            handleDailySnapData()
        }
        .onChange(of: selectedPhoto, perform: { _ in
            Task {
                await processPickerPhoto()
            }
        })
        .onChange(of: pickedDate, perform: { _ in
            handleDailySnapData()
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
    
    func handleDailySnapData() {
        if pickedDate == Date.now {
            self.scnScene = SCNScene(named: "Fox_Sit2_Idle.scn")!
            homeStore.todayDailySnap = homeStore.getTodayDailySnap()
            if homeStore.todayDailySnap != nil {
                self.dailySnapItems = homeStore.getDailySnapItemsByDailySnap(dailySnap: homeStore.todayDailySnap!)
                self.currentMood = Emotion.init(rawValue: homeStore.todayDailySnap!.latest_mood!).unsafelyUnwrapped
                self.scnScene = SCNScene(named: EmotionScene.animation(emotion: currentMood))!
            }
        } else {
            homeStore.todayDailySnap = homeStore.getDailySnapByDate(filterDate: pickedDate.formatted(date: .numeric, time: .omitted))
            if homeStore.todayDailySnap != nil {
                self.dailySnapItems = homeStore.getDailySnapItemsByDailySnap(dailySnap: homeStore.todayDailySnap!)
                self.currentMood = Emotion.init(rawValue: homeStore.todayDailySnap!.latest_mood!).unsafelyUnwrapped
                self.scnScene = SCNScene(named: EmotionScene.animation(emotion: currentMood))!
            } else {
                self.scnScene = SCNScene(named: "Fox_Sit2_Idle.scn")!
            }
        }
    }
    
    func processPickerPhoto() async {
        print("START PROCESSING IMAGE")
        isProcessingImage = true
        if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
            if let selectedPhoto = UIImage(data: data) {
                FaceDetectionUtil.detectFace(image: selectedPhoto) { croppedFacePhoto in
                    if let croppedFacePhoto = croppedFacePhoto {
                        selectedOriginalPhoto = selectedPhoto
                        croppedOriginalPhoto = croppedFacePhoto
                        navigationPath.append(AnalyzedImageViewRoutingPath())
                    } else {
                        isShowingImageAlert = true
                        isProcessingImage = false
                    }
                }
            }
        }
    }
    
    func processCapturedPhoto() async {
        isProcessingImage = true
        if let capturedImage = capturedImage {
            FaceDetectionUtil.detectFace(image: capturedImage) { croppedFacePhoto in
                if let croppedFacePhoto = croppedFacePhoto {
                    selectedOriginalPhoto = capturedImage
                    croppedOriginalPhoto = croppedFacePhoto
                    navigationPath.append(AnalyzedImageViewRoutingPath())
                } else {
                    isShowingImageAlert = true
                    isProcessingImage = false
                }
            }
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
