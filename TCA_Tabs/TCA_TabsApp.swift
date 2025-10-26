//
//  TCA_TabsApp.swift
//  TCA_Tabs
//
//  Created by Dima on 23/10/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCA_TabsApp: App {
    static let store = Store(initialState: MainFeature.State()) {
        MainFeature()
            ._printChanges()
    }

    var body: some Scene {
        WindowGroup {
            MainView(store: Self.store)
        }
    }
}
