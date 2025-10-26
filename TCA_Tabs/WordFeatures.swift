//
//  FeatureA.swift
//  TCA_Tabs
//
//  Created by Dima on 23/10/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct FeatureA {
    @ObservableState
    struct State {
    }

    enum Action {
        case openFeatureB
        case openFeatureC
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .openFeatureB, .openFeatureC:
                return .none
            }
        }
    }
}

struct FeatureAView: View {
    @Perception.Bindable var store: StoreOf<FeatureA>

    var body: some View {
        WithPerceptionTracking {
            Form {
                Section {
                    Button("open feature B") { store.send(.openFeatureB) }
                    Button("open feature C") { store.send(.openFeatureC) }
                }
                .navigationTitle("Feature A")
            }
        }
    }
}

@Reducer
struct FeatureB {
    @ObservableState
    struct State {
    }

    enum Action {
        case openFeatureA
        case openFeatureC
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .openFeatureA, .openFeatureC:
                return .none
            }
        }
    }
}

struct FeatureBView: View {
    @Perception.Bindable var store: StoreOf<FeatureB>

    var body: some View {
        WithPerceptionTracking {
            Form {
                Section {
                    Button("open feature A") { store.send(.openFeatureA) }
                    Button("open feature C") { store.send(.openFeatureC) }
                }
                .navigationTitle("Feature B")
            }
        }
    }
}

@Reducer
struct FeatureC {
    @ObservableState
    struct State {
    }

    enum Action {
        case openFeatureA
        case openFeatureB
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .openFeatureA, .openFeatureB:
                return .none
            }
        }
    }
}

struct FeatureCView: View {
    @Perception.Bindable var store: StoreOf<FeatureC>

    var body: some View {
        WithPerceptionTracking {
            Form {
                Section {
                    Button("open feature A") { store.send(.openFeatureA) }
                    Button("open feature B") { store.send(.openFeatureB) }
                }
                .navigationTitle("Feature C")
            }
        }
    }
}
