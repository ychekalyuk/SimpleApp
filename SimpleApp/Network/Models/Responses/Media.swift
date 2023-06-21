//
//  Media.swift
//  SimpleApp
//
//  Created by Юрий Альт on 21.06.2023.
//

struct Results: Decodable {
    let results: [Media]
}

struct Media: Decodable {
    let artistName: String?
    let trackName: String?
    let artworkUrl100: String?
}
