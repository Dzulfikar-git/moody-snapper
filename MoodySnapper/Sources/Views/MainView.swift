//
//  MainView.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 14/05/23.
//

import SwiftUI

struct MainView: View {
    @State var navigationPath: NavigationPath = .init()
    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView {
                HomeView(navigationPath: $navigationPath)
                    .tabItem {
                        Label("Me", systemImage: "person.circle.fill")
                    }
                    .tag(1)
                
                PlaceholderView()
                    .tabItem {
                        Label("Placeholder", systemImage: "calendar.circle.fill")
                    }
                    .tag(2)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
