import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var predators = Predators()
    @State var searchText = ""
    @State var alphabetical = false
    @State var currentSelection = APType.all
    @State private var selectedMovie: MovieSelection = .all
    
    // llm link describing adding filter by movie https://chatgpt.com/share/68c2552e-db6c-800a-846e-520910b52a7d

    // Unique, sorted movie titles pulled from your data
    private var allMovieTitles: [String] {
        Array(
            Set(predators.apexPredators.flatMap { $0.movies })
        ).sorted()
    }

    var filteredDinos: [ApexPredator] {
        // Exclude deleted first
        let notDeleted = predators.apexPredators.filter { !$0.deleted }

        // 1) filter by type
        let byType = predators.filter(notDeleted, by: currentSelection)

        // 2) filter by selected movie
        let byMovie: [ApexPredator]
        switch selectedMovie {
        case .all:
            byMovie = byType
        case .title(let m):
            byMovie = byType.filter { $0.movies.contains(m) }
        }

        // 3) search
        let bySearch = predators.search(byMovie, for: searchText)

        // 4) sort
        return predators.sort(bySearch, by: alphabetical)
    }
    
    var body: some View {
        NavigationStack {
            listView
                .navigationTitle("Apex Predators")
                .searchable(text: $searchText)
                .autocorrectionDisabled()
                .animation(.default, value: searchText)
                .animation(.default, value: currentSelection)
                .animation(.default, value: selectedMovie)
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
            HStack(spacing: 12) {
                // Only the content navigates
                NavigationLink {
                    PredatorDetail(
                        predator: predator,
                        position: .camera(MapCamera(centerCoordinate: predator.location, distance: 30000))
                    )
                } label: {
                    PredatorRowContent(predator: predator) // <= content only
                }

                Spacer(minLength: 0)

                // Trash is outside the NavigationLink
                Button(role: .destructive) {
                    predators.markDeleted(id: predator.id)
                } label: {
                    Image(systemName: "trash")
                        .imageScale(.large)
                        .padding(8)
                }
                .buttonStyle(.borderless) // prevents row-wide tap from triggering nav
                .accessibilityLabel("Delete \(predator.name)")
            }
        }
    }
    
    private struct PredatorRowContent: View {
        let predator: ApexPredator

        var body: some View {
            HStack {
                Image(predator.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .shadow(color: .white, radius: 1)

                VStack(alignment: .leading) {
                    Text(predator.name).fontWeight(.bold)
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


    // Extracted Predator Row View
    private struct PredatorRow: View {
        let predator: ApexPredator
        let onDelete: () -> Void

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
                Spacer()

                // DELETE BUTTON (in-row)
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                        .imageScale(.large)
                        .padding(8)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Delete \(predator.name)")
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
            // Type filter
            Picker("Type", selection: $currentSelection.animation()) {
                ForEach(APType.allCases) { type in
                    Label(type.rawValue.capitalized, systemImage: type.icon)
                        .tag(type)
                }
            }

            // Movie filter
            Picker("Movie", selection: $selectedMovie.animation()) {
                Text("All Movies").tag(MovieSelection.all)
                ForEach(allMovieTitles, id: \.self) { title in
                    Text(title).tag(MovieSelection.title(title))
                }
            }

            // Optional convenience action:
            Button("Clear Filters") {
                withAnimation {
                    currentSelection = .all
                    selectedMovie = .all
                    searchText = ""
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
