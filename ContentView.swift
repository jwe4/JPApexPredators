import SwiftUI

struct ContentView: View {
    let predators = Predators()
    @State var searchText = ""
    @State var alphabetical = false
    @State var currentSelection = APType.all

    var filteredDinos: [ApexPredator] {
        let filteredByType = predators.filter(predators.apexPredators, by: currentSelection)
        let filteredBySearch = predators.search(filteredByType, for: searchText)
        let sortedResult = predators.sort(filteredBySearch, by: alphabetical)
        return sortedResult
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
    let predators = Predators()
    predators.apexPredators = [
        ApexPredator(id: 1, name: "Tyrannosaurus Rex", type: .land, latitude: 0, longitude: 0, movies: [], movieScenes: [], link: ""),
        ApexPredator(id: 2, name: "Velociraptor", type: .land, latitude: 0, longitude: 0, movies: [], movieScenes: [], link: ""),
        ApexPredator(id: 3, name: "Pteranodon", type: .air, latitude: 0, longitude: 0, movies: [], movieScenes: [], link: ""),
        ApexPredator(id: 4, name: "Mosasaurus", type: .sea, latitude: 0, longitude: 0, movies: [], movieScenes: [], link: "")
    ]
    return ContentView()
}
