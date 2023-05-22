//
//  ScreenRouting.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 14/05/23.
//

import Foundation

struct AnalyzedImageViewRoutingPath: Hashable {
    var id: UUID = UUID()
}

struct DetailDailySnapItemRoutingPath: Hashable {
    var id: UUID = UUID()
    var dailySnapItem: DailySnapItems
    
    init(snapItem: DailySnapItems) {
        dailySnapItem = snapItem
    }
}
