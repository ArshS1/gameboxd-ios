//
//  Data.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 3/5/25.
//

import SwiftData
import Foundation

@available(iOS 17, *)
@Model
class FavoriteGame: Identifiable {
    @Attribute(.unique) var id: Int
    var name: String
    var cover: String
    var release_date: String?
    var summary: String?
    var genres: [String]?
    var platformsJSON: String?

    init(id: Int, name: String, cover: String, release_date: String?, summary: String?, genres: [String]?, platforms: [Platform]) {
        self.id = id
        self.name = name
        self.cover = cover
        self.release_date = release_date
        self.summary = summary
        self.genres = genres
        self.platformsJSON = try? encodePlatforms(platforms)
    }

    var platforms: [Platform] {
        get {
            decodePlatforms(platformsJSON) ?? []
        }
        set {
            platformsJSON = try? encodePlatforms(newValue)
        }
    }

    private func encodePlatforms(_ platforms: [Platform]) throws -> String {
        let data = try JSONEncoder().encode(platforms)
        return String(data: data, encoding: .utf8) ?? "[]"
    }

    private func decodePlatforms(_ json: String?) -> [Platform]? {
        guard let jsonData = json?.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode([Platform].self, from: jsonData)
    }
}

@available(iOS 17, *)
@Model
class SavedGame: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var cover: String
    var rating: Int
    var feedback: String
    var genresJSON: String?  // Store genres as a JSON string

    init(name: String, cover: String, rating: Int, feedback: String, genres: [String]? = nil) {
        self.id = UUID()
        self.name = name
        self.cover = cover
        self.rating = rating
        self.feedback = feedback
        self.genresJSON = try? encodeGenres(genres)
    }

    // Computed property to get genres as [String] when needed
    var genres: [String]? {
        get {
            decodeGenres(genresJSON)
        }
        set {
            genresJSON = try? encodeGenres(newValue)
        }
    }

    private func encodeGenres(_ genres: [String]?) throws -> String? {
        guard let genres = genres else { return nil }
        let data = try JSONEncoder().encode(genres)
        return String(data: data, encoding: .utf8)
    }

    private func decodeGenres(_ json: String?) -> [String]? {
        guard let jsonData = json?.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode([String].self, from: jsonData)
    }
}
