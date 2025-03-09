//
//  Game.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/17/25.
//

import Foundation


struct Platform: Codable {
    let name: String
    let logo_url: String?
}

struct Genre: Decodable {
    let name: String
}

struct Game: Identifiable, Decodable {
    let id: Int
    let name: String
    let cover: String
    let release_date: String?
    let summary: String?
    let genres: [String]?
    let platforms: [Platform]

    enum CodingKeys: String, CodingKey {
        case id, name, cover, release_date, summary, genres, platforms
    }

    init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    cover = try container.decode(String.self, forKey: .cover)
    release_date = try? container.decode(String.self, forKey: .release_date)
    summary = try? container.decode(String.self, forKey: .summary)
    genres = try container.decodeIfPresent([String].self, forKey: .genres)
    platforms = try container.decodeIfPresent([Platform].self, forKey: .platforms) ?? []
}

}
