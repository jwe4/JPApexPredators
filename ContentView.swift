//
//  ContentView.swift
//  JPApexPredators
//
//  Created by Jim Weaver on 8/25/25.
//

import SwiftUI

struct ContentView: View {
    let predators = Predators()
    @State var searchText = ""
    @State var alphabetical = false
    @State var currentSelection = APType.all

    var filteredDinos: [ApexPredator] {
        var result = predators.apexPredators
        // Apply type filter
        result = predators.filter(by: currentSelection)
        // Apply search filter
        result = predators.search(for: searchText)
        // Apply sorting
        result = predators.sort(by: alphabetical)
        return result
    }

    var body: some View {
        NavigationStack {
            listView
                .navigationTitle("Apex Predators")
                .searchable(text: $searchText)
                .autocorrectionDisabled()
                .animation(.default, value: searchText)
                .animation(.default, value: currentSelection)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        sortButton
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        filterMenu
                    }
                }
        }
        .preferredColorScheme(.dark)
    }

    // Extracted List View
    private var listView: some View {
        List(filteredDinos) { predator in
            NavigationLink {
                Image(predator.image)
                    .resizable()
                    .scaledToFit()
            } label: {
                PredatorRow(predator: predator)
            }
        }
    }

    // Extracted Predator Row View
    private struct PredatorRow: View {
        let predator: ApexPredator

        var body: some View {
            HStack {
                Image(predator.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .shadow(color: .white, radius: 1)

                VStack(alignment: .leading) {
                    Text(predator.name)
                        .fontWeight(.bold)
                    Text(predator.type.rawValue.capitalized)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.vertical, 5)
                        .background(predator.type.background)
                        .clipShape(.capsule)
                }
            }
        }
    }

    // Extracted Sort Button
    private var sortButton: some View {
        Button {
            withAnimation {
                alphabetical.toggle()
            }
        } label: {
            Image(systemName: alphabetical ? "film" : "textformat")
                .symbolEffect(.bounce, value: alphabetical)
        }
    }

    // Extracted Filter Menu
    private var filterMenu: some View {
        Menu {
            Picker("Filter", selection: $currentSelection) {
                ForEach(APType.allCases) { type in
                    Label(type.rawValue.capitalized, systemImage: type.icon)
                        .tag(type)
                }
            }
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
    }
}

#Preview {
    ContentView()
}
