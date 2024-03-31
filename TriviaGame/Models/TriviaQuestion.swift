//
//  TriviaQuestionRespone.swift
//  TriviaGame
//
//  Created by Qetsia Nkulu  on 3/28/24.
//

import Foundation

struct TriviaAPIResponse : Decodable {
    let results: [TriviaQuestion]
}


struct TriviaQuestion: Decodable, Hashable {
    let type: String
    let difficulty: String
    let category: String
    var question: String
    var correct_answer: String
    var incorrect_answers : [String]
    
    // new property to store all the answers (facilitates mappings of answers to answerButtons)
    var answers: [String] {
        var allAnswers = incorrect_answers
        allAnswers.append(correct_answer)
        // Return answers in a predefined order (incorrect answers first, then correct answer)
        return allAnswers
        
    }
    
}


