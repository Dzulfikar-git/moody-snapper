//
//  HomeStore.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 14/05/23.
//

import Foundation
import CoreData

class HomeStore: ObservableObject {
    @Published var todayDailySnap: DailySnaps?
    private var managedObjectContext: NSManagedObjectContext
    
    init(managedContext: NSManagedObjectContext) {
        managedObjectContext = managedContext
        
        todayDailySnap = getTodayDailySnap()
    }
    
    public func getTodayDailySnap() -> DailySnaps? {
        let fetchRequest: NSFetchRequest<DailySnaps> = DailySnaps.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(date = %@)", Date().formatted(date: .numeric, time: .omitted))
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return result.first
        } catch {
            print("Failed to fetch today daily snap data: \(error)")
            return nil
        }
    }
    
    public func getDailySnapItemsByDailySnap(dailySnap: DailySnaps) -> [DailySnapItems] {
        let fetchRequest: NSFetchRequest<DailySnapItems> = DailySnapItems.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dailysnaps == %@", dailySnap)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: false)]
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return result
        } catch {
            print("Failed to fetch today daily snap items data: \(error)")
            return []
        }
    }
    
    public func getDailySnapByDate(filterDate: String) -> DailySnaps? {
        let fetchRequest: NSFetchRequest<DailySnaps> = DailySnaps.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(date = %@)", filterDate)
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return result.first
        } catch {
            print("Failed to fetch today daily snap data: \(error)")
            return nil
        }
    }
    
    
}
