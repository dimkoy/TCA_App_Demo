//
//  NumberFeatures.swift
//  TCA_Tabs
//
//  Created by Dima on 23/10/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct FirstFeature {
    @ObservableState
    struct State: Equatable {
        let title = "Feature First"
    }

    enum Action {
        case openFeatureA
        case openFeatureB
        case openFeatureC
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .openFeatureA, .openFeatureB, .openFeatureC:
                return .none
            }
        }
    }
}

struct FeatureFirstView: View {
    let store: StoreOf<FirstFeature>

    var body: some View {
        WithPerceptionTracking {
            Form {
                Section {
                    Button("open feature A") { store.send(.openFeatureA) }
                    Button("open feature B") { store.send(.openFeatureB) }
                    Button("open feature C") { store.send(.openFeatureC) }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(store.title)
            }
        }
    }
}

@Reducer
struct SecondFeature {
    @ObservableState
    struct State: Equatable {
        let title = "Feature Second"
    }

    enum Action {
        case openFeatureA
        case openFeatureB
        case openFeatureC
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .openFeatureA, .openFeatureB, .openFeatureC:
                return .none
            }
        }
    }
}

struct FeatureSecondView: View {
    @Perception.Bindable var store: StoreOf<SecondFeature>

    var body: some View {
        WithPerceptionTracking {
            Form {
                Section {
                    Button("open feature A") { store.send(.openFeatureA) }
                    Button("open feature B") { store.send(.openFeatureB) }
                    Button("open feature C") { store.send(.openFeatureC) }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(store.title)
            }
        }
    }
}

@Reducer
struct SearchFeature {
    @ObservableState
    struct State: Equatable {
        let title = "Feature Search"
    }

    enum Action {
        case openFeatureA
        case openFeatureB
        case openFeatureC
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .openFeatureC, .openFeatureA, .openFeatureB:
                return .none
            }
        }
    }
}

struct FeatureSearchView: View {
    @Perception.Bindable var store: StoreOf<SearchFeature>

    var body: some View {
        WithPerceptionTracking {
            Form {
                Section {
                    Button("open feature A") { store.send(.openFeatureA) }
                    Button("open feature B") { store.send(.openFeatureB) }
                    Button("open feature C") { store.send(.openFeatureC) }
                }
                .navigationTitle(store.title)
            }
        }
    }
}

