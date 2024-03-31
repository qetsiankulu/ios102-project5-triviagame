//
//  CategoriesResponse.swift
//  TriviaGame
//
//  Created by Qetsia Nkulu  on 3/27/24.
//

import Foundation

struct TriviaCategoriesResponse : Codable {
    let trivia_categories: [TriviaCategory]
}

struct TriviaCategory : Codable, Hashable, Identifiable {
    let id: Int
    let name: String 
}
