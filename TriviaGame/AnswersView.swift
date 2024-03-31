//
//  AnswersView.swift
//  TriviaGame
//
//  Created by Qetsia Nkulu  on 3/30/24.
//

import SwiftUI

struct AnswersView: View {
    
    let answers: [String]
    let correctAnswer: String
    @State private var selectedAnswer: String?
    
    var body: some View {
        VStack {
            ForEach(0..<answers.count, id: \.self) { index in
                AnswerLabel(answerText: "\(letter(for: index)). \(answers[index])")
            }
        }
    }
    
    // Helps with formatting the letters for the answers
    func letter(for index: Int) -> String {
         let letters = ["A", "B", "C", "D"]
         return letters[index]
     }
}

#Preview {
    AnswersView(answers: ["Eagle", "Birdie", "Bogey", "Albatross"], correctAnswer: "Birdie" )
}
