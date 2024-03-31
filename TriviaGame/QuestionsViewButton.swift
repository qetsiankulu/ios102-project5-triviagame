//
//  NavigationButton.swift
//  TriviaGame
//
//  Created by Qetsia Nkulu  on 3/30/24.
//

import SwiftUI

struct QuestionsViewButton: View {
    
    let buttonText: String
    let destination: QuestionsView
   

    var body: some View {
        NavigationLink(destination: destination) {        // <-- call the action closure when the button is tapped
                 Text(buttonText)
                     .bold()
                     .foregroundColor(.white)
                     .padding()
                     .frame(maxWidth: .infinity)
                     .background(Color.green)
                     .clipShape(Capsule())
                     .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
             }
             .padding(.horizontal)// Add padding to adjust button position if needed
        
        }
}


#Preview {
    
    QuestionsViewButton(
        buttonText: "Button Text",
        destination: QuestionsView(questions: [
                        TriviaQuestion(type: "multiple", difficulty: "medium", category: "General Knowledge", question: "What is the capital of France?", correct_answer: "Paris", incorrect_answers: ["London", "Berlin", "Rome"])
        ], 
                    timerDuration: .sixty)
        )
}
    











