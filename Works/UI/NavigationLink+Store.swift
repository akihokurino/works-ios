//
//  NavigationLink+Store.swift
//  Works
//
//  Created by akiho on 2021/07/19.
//

import ComposableArchitecture
import SwiftUI

extension NavigationLink {
    static func store<State, Action, DestinationContent>(
        _ store: Store<State?, Action>,
        destination: @escaping (_ destinationStore: Store<State, Action>) -> DestinationContent,
        action: @escaping (_ isActive: Bool) -> Void,
        label: @escaping () -> Label
    ) -> some View
        where DestinationContent: View,
        Destination == IfLetStore<State, Action, DestinationContent?>
    {
        WithViewStore(store.scope(state: { $0 != nil })) { viewStore in
            NavigationLink(
                destination: IfLetStore(
                    store.scope(state: replayNonNil()),
                    then: destination
                ),
                isActive: Binding(
                    get: { viewStore.state },
                    set: action
                ),
                label: label
            )
        }
    }
}

extension View {
    func navigate<State, Action, DestinationContent>(
        using store: Store<State?, Action>,
        destination: @escaping (_ destinationStore: Store<State, Action>) -> DestinationContent,
        onDismiss: @escaping () -> Void
    ) -> some View
        where DestinationContent: View
    {
        background(
            NavigationLink.store(
                store,
                destination: destination,
                action: { isActive in
                    if isActive == false {
                        onDismiss()
                    }
                },
                label: EmptyView.init
            )
        )
    }
}
