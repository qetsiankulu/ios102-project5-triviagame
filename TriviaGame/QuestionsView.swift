//
//  GameViewQuestions.swift
//  TriviaGame
//
//  Created by Qetsia Nkulu  on 3/29/24.
//

import SwiftUI

struct QuestionsView: View {
    
    var questions: [TriviaQuestion] = []
    
    // Timer variables
    var timerDuration: TimerCount
    @State private var timeRemaining: Int
    
    // Score message variables
    let totalQuestions: Int
    @State private var score: Int
  
    // Initialize the view with questions and timer duration passed from TrviaOptionsView
    init(questions: [TriviaQuestion], timerDuration: TimerCount) {
        self.questions = questions
        self.timerDuration = timerDuration
        
        timeRemaining = timerDuration.rawValue
        
        totalQuestions = questions.count
        score = 0
     }
    

    var body: some View {
          VStack {
              Text("Time Remaining: \(timeRemaining)s")
                  .font(.system(size: 25))
                  .padding()
              
              
              // Display questions here
              List(questions, id: \.self) { question in
                  
                  VStack(alignment: .leading) {                     // <-- contains the question and the answers
                      Text(question.question)
                          .bold()
                      
                      // Display the answers in an AnswersView 
                      AnswersView(answers: question.answers, correctAnswer: question.correct_answer)
                  }
                  .frame(maxWidth: .infinity) // Expand VStack to full width
              }
              
              
          }
          .onAppear {
              startTimer()
          }
        
        MessageButton(buttonText: "Submit", title: "Score", message: "You scored \(score) out of \(totalQuestions)")
      }
    
    
    private func startTimer() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
            }
        }
        
        RunLoop.main.add(timer, forMode: .common)
    }
}

#Preview {
    QuestionsView(questions: [
        TriviaQuestion(type: "multiple", difficulty: "medium", category: "General Knowledge", question: "What is the capital of France?", correct_answer: "Paris", incorrect_answers: ["London", "Berlin", "Rome"]),
        TriviaQuestion(type: "multiple", difficulty: "medium", category: "General Knowledge", question: "What is the capital of Germany?", correct_answer: "Berlin", incorrect_answers: ["London", "Paris", "Rome"])
    ], timerDuration: .sixty)
}



// check mark image for the right answer
//Image(systemName: "checkmark.circle.fill")
//             .foregroundColor(.green)
