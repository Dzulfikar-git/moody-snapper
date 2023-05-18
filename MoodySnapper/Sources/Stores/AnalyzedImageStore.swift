//
//  AnalyzedImageStore.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 16/05/23.
//

import Foundation
import SwiftUI
import CoreData

class AnalyzedImageStore: ObservableObject {
    static let shared = AnalyzedImageStore()
    
    @Published var emotion: Emotion?
    @Published var adjustedEmotion: Emotion?
    @Published var isShowingEmotionActionSheet = false
    @Published var isPresentingAddImageSheet = false
    @Published var comment: String = ""
    
    public func analyzeEmotion(photo: UIImage) {
        let model = try? CNNEmotions(configuration: .init())
        guard let predictEmotion = try? model?.prediction(data: ImageUtil.buffer(from: photo)!) else {
            fatalError("Unexpected Runtime Error")
        }
        
        self.emotion = Emotion(rawValue: predictEmotion.classLabel)
    }
    
    public func getTodayDailySnap(managedContext: NSManagedObjectContext) -> DailySnaps? {
        let entityDescription = NSEntityDescription.entity(forEntityName: "DailySnaps", in: managedContext)
        let request: NSFetchRequest<DailySnaps> = DailySnaps.fetchRequest()
        request.entity = entityDescription
        let todayDate = Calendar.current.startOfDay(for: .now)
        let pred = NSPredicate(format: "(date = %@)", todayDate as NSDate)
        request.predicate = pred
        
        do {
            let results = try managedContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [DailySnaps]
            
            if results.isEmpty {
                return nil
            }
            
            return results[0] as DailySnaps
        } catch {
            print(String(describing: error.localizedDescription))
            fatalError(error.localizedDescription)
        }
    }
    
    
    public func createTodayDailySnap(managedContext: NSManagedObjectContext) -> DailySnaps {
        _ = NSEntityDescription.entity(forEntityName: "DailySnaps",
                                   in: managedContext)!
        
        let dailySnap = DailySnaps(context: managedContext)
        dailySnap.date = Date().formatted(date: .numeric, time: .omitted)
        dailySnap.id = UUID()
        
        do {
            try managedContext.save()
            return dailySnap
        } catch let error {
            print(String(describing: error.localizedDescription))
            fatalError(error.localizedDescription)
        }
    }
    
    public func createDailySnapItems(photo: UIImage, dailySnap: DailySnaps, moodStatus: Emotion, managedContext: NSManagedObjectContext) -> Bool {
        _ = NSEntityDescription.entity(forEntityName: "DailySnapItems", in: managedContext)!
        
        // savePhotoToDir
        let imageId = self.savePhotoToDirectory(photo: photo)
        
        let dailySnapItem = DailySnapItems(context: managedContext)
        dailySnapItem.id = UUID()
        dailySnapItem.dailysnaps = dailySnap
        dailySnapItem.created_at = Date()
        dailySnapItem.mood_status = moodStatus.rawValue
        dailySnapItem.image = imageId
        
        do {
            try managedContext.save()
            return true
        } catch {
            print(String(describing: error.localizedDescription))
            fatalError(error.localizedDescription)
            return false
        }
    }
    
    // this will return the full name and extension of the image.
    private func savePhotoToDirectory(photo: UIImage) -> String {
        let imageId: UUID = UUID()
        let data = photo.jpegData(compressionQuality: 1.0)
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileUrl = documentsDirectory!.appendingPathComponent("\(imageId).jpg")
        do {
            try data!.write(to: fileUrl)
            
            return "\(imageId).jpg"
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
