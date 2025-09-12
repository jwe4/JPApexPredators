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
    var deleted: Bool = false
    
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
    // Safe default for `deleted` even if JSON lacks the key
    private enum CodingKeys: String, CodingKey {
        case id, name, type, latitude, longitude, movies, movieScenes, link, deleted
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id          = try c.decode(Int.self, forKey: .id)
        name        = try c.decode(String.self, forKey: .name)
        type        = try c.decode(APType.self, forKey: .type)
        latitude    = try c.decode(Double.self, forKey: .latitude)
        longitude   = try c.decode(Double.self, forKey: .longitude)
        movies      = try c.decode([String].self, forKey: .movies)
        movieScenes = try c.decode([MovieScene].self, forKey: .movieScenes)
        link        = try c.decode(String.self, forKey: .link)
        deleted     = try c.decodeIfPresent(Bool.self, forKey: .deleted) ?? false
    }

    // Convenience init for previews or programmatic construction
    init(id: Int, name: String, type: APType, latitude: Double, longitude: Double, movies: [String], movieScenes: [MovieScene], link: String, deleted: Bool = false) {
        self.id = id
        self.name = name
        self.type = type
        self.latitude = latitude
        self.longitude = longitude
        self.movies = movies
        self.movieScenes = movieScenes
        self.link = link
        self.deleted = deleted
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
