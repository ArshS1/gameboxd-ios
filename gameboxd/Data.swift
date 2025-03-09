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
