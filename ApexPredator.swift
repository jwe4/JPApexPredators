//
//  ApexPredator.swift
//  JPApexPredators
//
//  Created by Jim Weaver on 8/25/25.
//
import SwiftUI
import MapKit

struct ApexPredator: Decodable, Identifiable {
    let id: Int
    let name: String
    let type: APType
    let latitude: Double
    let longitude: Double
    let movies: [String]
    let movieScenes: [MovieScene]
    let link: String
    
    var image:String {
        name.lowercased().replacingOccurrences(of: " ", with: "")
    }
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
    struct MovieScene : Decodable, Identifiable {
        let id: Int
        let movie: String
        let sceneDescription: String
    }
}

enum APType: String, Decodable, CaseIterable, Identifiable {
    case all
    case land
    case air
    case sea
    
    var id: APType {
        self
    }
    
    var background : Color {
        switch self {
        case .land:
            .brown
        case .air:
            .teal
        case .sea:
            .blue
        case .all:
            .black
        }
    }
    
    var icon: String {
        switch self {
        case .all:
            "square.stack.3d.up.fill"
        case .land:
            "leaf.fill"
        case .air:
             "wind"
        case .sea:
            "drop.fill"
        }
    }
}

enum MovieSelection: Hashable, Identifiable {
    case all
    case title(String)

    var id: String {
        switch self {
        case .all: return "ALL_MOVIES"
        case .title(let t): return "MOVIE_\(t)"
        }
    }

    var label: String {
        switch self {
        case .all: return "All Movies"
        case .title(let t): return t
        }
    }
}
