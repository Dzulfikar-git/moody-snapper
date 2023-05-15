//
//  HomeView.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 14/05/23.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @Binding var navigationPath: NavigationPath
    
    @State var selectedPhoto: PhotosPickerItem?
    
    @State var isProcessingImage: Bool = false
    @State var isShowingImageAlert: Bool = false
    
    @State private var selectedOriginalPhoto: UIImage?
    @State private var croppedOriginalPhoto: UIImage?
    
    var body: some View {
        VStack {
            PhotosPicker("Select Your Photo", selection: $selectedPhoto, matching: .images)
            
            if isProcessingImage {
                Text("Image is loading, please wait...")
            }
        }
        .onChange(of: selectedPhoto, perform: { _ in
            Task {
                await processPickerPhoto()
            }
        })
        .alert("Photo Error", isPresented: $isShowingImageAlert, actions: {
            Button("Ok", role: .cancel) {  }
        }, message: {
            Text("Face not found, please use another one")
        })
        .navigationDestination(for: AnalyzedImageViewRoutingPath.self, destination: { _ in
            if (selectedOriginalPhoto != nil) && (croppedOriginalPhoto != nil) {
                AnalyzedImageView(originalPhoto: selectedOriginalPhoto!, croppedPhoto: croppedOriginalPhoto!)
            }
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
