//
//  MainView.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 14/05/23.
//

import SwiftUI

struct MainView: View {
    @State private var navigationPath: NavigationPath = .init()
    private let dailySnapsPersistenceController: DailySnapsPersistenceController = .shared
    var body: some View {
        NavigationStack(path: $navigationPath) {
            HomeView(navigationPath: $navigationPath)
                .environment(\.managedObjectContext, dailySnapsPersistenceController.container.viewContext)
                .environmentObject(HomeStore(managedContext: dailySnapsPersistenceController.container.viewContext))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
