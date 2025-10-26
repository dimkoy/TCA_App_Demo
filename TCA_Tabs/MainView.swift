//
//  MainView.swift
//  TCA_Tabs
//
//  Created by Dima on 23/10/25.
//

import SwiftUI
import ComposableArchitecture

enum TabType: Hashable, Equatable, Identifiable {
    var id: Self { self }

    case first
    case second
    case search
}

@Reducer
struct MainFeature {
    @ObservableState
    struct State {
        var first = FirstFeature.State()
        var second = SecondFeature.State()
        var search = SearchFeature.State()

        var selectedTab: TabType = .first

        var query: String = ""

        var firstPath = StackState<Path.State>()
        var secondPath = StackState<Path.State>()
        var searchPath = StackState<Path.State>()
    }

    enum Action: BindableAction {
        case first(FirstFeature.Action)
        case second(SecondFeature.Action)
        case search(SearchFeature.Action)

        case navPush(Path.State)
        case navPop(StackElementID)
        case navPopAll

        case binding(BindingAction<State>)
        case firstPath(StackActionOf<Path>)
        case secondPath(StackActionOf<Path>)
        case searchPath(StackActionOf<Path>)
    }

    @Reducer enum Path {
        case featureA(FeatureA)
        case featureB(FeatureB)
        case featureC(FeatureC)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Scope(state: \.first, action: \.first) {
            FirstFeature()
        }

        Scope(state: \.second, action: \.second) {
            SecondFeature()
        }

        Scope(state: \.search, action: \.search) {
            SearchFeature()
        }

        Reduce { state, action in
            switch action {
            case .navPopAll:
                switch state.selectedTab {
                case .first:
                    if let firstScreen = state.firstPath.ids.first {
                        state.firstPath.pop(from: firstScreen)
                    }
                case .second:
                    if let firstScreen = state.secondPath.ids.first {
                        state.secondPath.pop(from: firstScreen)
                    }
                case .search:
                    if let firstScreen = state.searchPath.ids.first {
                        state.searchPath.pop(from: firstScreen)
                    }
                }
                return .none
            case .navPush(let path):
                switch state.selectedTab {
                case .first: state.firstPath.append(path)
                case .second: state.secondPath.append(path)
                case .search: state.searchPath.append(path)
                }
                return .none
            case .navPop(let id):
                switch state.selectedTab {
                case .first:
                    if state.firstPath.ids.contains(id) {
                        state.firstPath.pop(from: id)
                    }
                case .second:
                    if state.secondPath.ids.contains(id) {
                        state.secondPath.pop(from: id)
                    }
                case .search:
                    if state.searchPath.ids.contains(id) {
                        state.searchPath.pop(from: id)
                    }
                }
                return .none
            case .first(.openFeatureA), .second(.openFeatureA), .search(.openFeatureA),
                    .firstPath(.element(id: _, action: .featureB(.openFeatureA))),
                    .firstPath(.element(id: _, action: .featureC(.openFeatureA))),
                    .secondPath(.element(id: _, action: .featureB(.openFeatureA))),
                    .secondPath(.element(id: _, action: .featureC(.openFeatureA))),
                    .searchPath(.element(id: _, action: .featureB(.openFeatureA))),
                    .searchPath(.element(id: _, action: .featureC(.openFeatureA))):
                return .send(.navPush(.featureA(FeatureA.State())))

            case .first(.openFeatureB), .second(.openFeatureB), .search(.openFeatureB),
                    .firstPath(.element(id: _, action: .featureA(.openFeatureB))),
                    .firstPath(.element(id: _, action: .featureC(.openFeatureB))),
                    .secondPath(.element(id: _, action: .featureA(.openFeatureB))),
                    .secondPath(.element(id: _, action: .featureC(.openFeatureB))),
                    .searchPath(.element(id: _, action: .featureA(.openFeatureB))),
                    .searchPath(.element(id: _, action: .featureC(.openFeatureB))):
                return .send(.navPush(.featureB(FeatureB.State())))

            case .first(.openFeatureC), .second(.openFeatureC), .search(.openFeatureC),
                    .firstPath(.element(id: _, action: .featureA(.openFeatureC))),
                    .firstPath(.element(id: _, action: .featureB(.openFeatureC))),
                    .secondPath(.element(id: _, action: .featureA(.openFeatureC))),
                    .secondPath(.element(id: _, action: .featureB(.openFeatureC))),
                    .searchPath(.element(id: _, action: .featureA(.openFeatureC))),
                    .searchPath(.element(id: _, action: .featureB(.openFeatureC))):
                return .send(.navPush(.featureC(FeatureC.State())))

            case .firstPath(.popFrom(let id)):
                state.firstPath.pop(from: id)
                return .none
            case .secondPath(.popFrom(let id)):
                state.secondPath.pop(from: id)
                return .none
            case .searchPath(.popFrom(let id)):
                state.searchPath.pop(from: id)
                return .none

            case .first, .second, .search, .binding, .firstPath, .secondPath, .searchPath:
                return .none
            }
        }
        .forEach(\.firstPath, action: \.firstPath)
        .forEach(\.secondPath, action: \.secondPath)
        .forEach(\.searchPath, action: \.searchPath)
    }
}

struct MainView: View {
    @Perception.Bindable var store: StoreOf<MainFeature>

    var body: some View {
        WithPerceptionTracking {
            Group {
                if #available(iOS 18.0, *) {
                    TabView(selection: $store.selectedTab) {
                        Tab("first", systemImage: "house.fill", value: TabType.first) {
                            NavigationStack(path: $store.scope(state: \.firstPath, action: \.firstPath)) {
                                FeatureFirstView(store: store.scope(state: \.first, action: \.first))
                            } destination: { store in
                                destination(store: store)
                            }
                        }

                        Tab("second", systemImage: "star", value: TabType.second) {
                            NavigationStack(path: $store.scope(state: \.secondPath, action: \.secondPath)) {
                                FeatureSecondView(store: store.scope(state: \.second, action: \.second))
                            } destination: { store in
                                destination(store: store)
                            }
                        }

                        Tab(value: TabType.search, role: .search) {
                            NavigationStack(path: $store.scope(state: \.searchPath, action: \.searchPath)) {
                                FeatureSearchView(store: store.scope(state: \.search, action: \.search))
                            } destination: { store in
                                destination(store: store)
                            }
                        }
                    }
                } else {
                    TabView(selection: $store.selectedTab) {
                        NavigationStack(path: $store.scope(state: \.firstPath, action: \.firstPath)) {
                            FeatureFirstView(store: store.scope(state: \.first, action: \.first))
                        } destination: { store in
                            destination(store: store)
                        }
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("first")
                        }
                        .tag(TabType.first)

                        NavigationStack(path: $store.scope(state: \.secondPath, action: \.secondPath)) {
                            FeatureSecondView(store: store.scope(state: \.second, action: \.second))
                        } destination: { store in
                            destination(store: store)
                        }
                        .tabItem {
                            Image(systemName: "star")
                            Text("second")
                        }
                        .tag(TabType.second)

                        NavigationStack(path: $store.scope(state: \.searchPath, action: \.searchPath)) {
                            FeatureSearchView(store: store.scope(state: \.search, action: \.search))
                        } destination: { store in
                            destination(store: store)
                        }
                        .tabItem {
                            Image(systemName: "search")
                        }
                        .tag(TabType.search)
                    }
                }
            }
            .searchable(text: $store.query)
        }
    }

    @ViewBuilder
    private func destination(store: StoreOf<MainFeature.Path>) -> some View {
        switch store.case {
        case .featureA(let store):
            FeatureAView(store: store)
        case .featureB(let store):
            FeatureBView(store: store)
        case .featureC(let store):
            FeatureCView(store: store)
        }
    }
}
