//
//  ContentView.swift
//  TriviaGame
//
//  Created by Qetsia Nkulu  on 3/27/24.


import SwiftUI
import Combine

struct TriviaOptionsView: View {
   
    // Game Settings
    @State private var numOfQuestions : String = ""
    @State private var categoryNames : [String]  = []
    @State private var difficulty: Double = 0
    @State private var questionTypes : [String] = ["Any Type", "Multiple Choice", "True / False"]
    @State private var timerDuration : TimerCount = .thirty

    // User selections
    @State private var selectedCategory = "General Knowledge"               // <-- Default category: General Knowledge
    @State private var selectedDifficulty: String = ""
    @State private var selectedQuestionType: String = "Any"                 // <-- Default question type : Any

    // Trivia categories as key-value pairs
    @State private var categoryDictionary: [Int: String] = [:]
    @State private var questions: [TriviaQuestion] = []
    
    var body: some View {
        NavigationStack {
            // Header
            Text("Trivia Game")
                .font(.system(size: 35))
                .bold()
            
            // Question Settings
            Form {
                // Questions
                TextField("Number of Questions", text: $numOfQuestions) {
                }
                .onChange(of: numOfQuestions) {                     // <-- when the number of questions is changed, the onChange modifier makes sure the async call with fetchQuestions gets the updated value
                    Task {
                        await fetchQuestions()
                    }
                }
                
                // Categories
                Picker("Select Category", selection: $selectedCategory) {
                    ForEach(categoryNames, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: selectedCategory) {               // <-- when the selected category changes, the onChange modifier makes sure the async call with fetchQuestions gets the updated value
                    Task {
                        await fetchQuestions()
                    }
                }
                
                // Difficulty
                HStack {                                            // <-- container for the difficulty text and slider
                    // Display selected difficulty
                    Text("Difficulty: \(selectedDifficulty)")
                    
                    // Slider for selecting difficulty
                    Slider(value: $difficulty, in: 0...100)
                    
                }
                .onReceive(Just(difficulty)) { _ in
                    // Update the selectedDifficulty based on the value of difficulty
                    
                    if difficulty <= 50 {                   // <-- Easy: 0 - 50
                        selectedDifficulty = "Easy"
                    } else if difficulty <= 80 {            // <-- Medium: 51-80
                        selectedDifficulty = "Medium"
                    } else {                                // <-- Hard: 81-100
                        selectedDifficulty = "Hard"
                    }

                }
                .onChange(of: selectedDifficulty) {        // <-- when the selected difficulty changes, the onChange modifier makes sure the async call with fetchQuestions gets the updated value
                    Task {
                        await fetchQuestions()
                    }
                }
                
                
                // Type of Question
                Picker("Select Type", selection: $selectedQuestionType) {
                    ForEach(questionTypes, id:\.self) {
                        Text($0)
                    }
                }
                .onChange(of: selectedQuestionType) {               // <-- when the selected type changes, the onChange modifier makes sure the async call with fetchQuestions gets the updated value
                    Task {
                        await fetchQuestions()
                    }
                }
                
                // Timer Duration
                Picker("Timer Duration", selection: $timerDuration) {
                    ForEach(TimerCount.allCases, id: \.self) { duration in
                        Text(duration == .onehour ? "1 hour" : "\(duration.rawValue) seconds")
                    }
                }
            }
            
            // Start Game
            // Depending on whether or not the questions array is empty, a different type of button appear
            if questions.isEmpty {
                // The questions array is empty so show the user presses a MessageButton
                MessageButton(buttonText: "Start Trivia", title: "Error", message: "No results: The API doesn't have enough questions for your query")
            } else {
                // The questions array is not empty so the user presses a QuestionsView button
                QuestionsViewButton(buttonText: "Start Trivia", destination: QuestionsView(questions: questions, timerDuration: timerDuration))         // <-- passes the questions and timer duration to the QuestionsView
            }
           
        }
        .onAppear(perform: {
            // Create a TASK to fetch the categories once the view appears
            Task {
                await fetchCategories()
            }
        })
    }
    
    
    // fetches the question categories from the OpenDB API to populate the categories variables
    private func fetchCategories() async {
        // URL for API endpoint
        let url = URL(string: "https://opentdb.com/api_category.php")!

        // wrap in do-catch since URLSession can throw error s

        do {
            let (data, _ ) = try await URLSession.shared.data(from: url)

            // Decode JSON data into TriviaCategoriesResponse type
            let categoriesResponse = try
            JSONDecoder().decode(TriviaCategoriesResponse.self, from: data)

            // Category Names Array
            // get the array of trivia categories names from the response
            let categoryNames = categoriesResponse.trivia_categories.map {$0.name} // <-- use `map` to extract the names of each categories as Strings
            
            // set the categories state property
            self.categoryNames = categoryNames
            

//            // Print the name of each category in the array
//            for category in categoryNames {
//                print(category)
//            }

     
            // Category Dictionary
            // Extract category IDs and names into a dictionary
            let categoryDictionary = Dictionary(uniqueKeysWithValues: categoriesResponse.trivia_categories.map { ($0.id, $0.name) })
            
            // Set the categoryDictionary state property
            self.categoryDictionary = categoryDictionary
            
//             // Print key-value pairs
//               for (id, name) in categoryDictionary {
//                   print("Category ID: \(id), Category Name: \(name)")
//               }


        } catch {
            print(error.localizedDescription)
        }
    }
    
    // fetches the questions the OpenDB API to populate the categories variables
    private func fetchQuestions() async {
        // API endpoint parameters
        let amount = numOfQuestions
        let category = findCategoryId()
        let difficulty = selectedDifficulty.lowercased()
        let type = findQuestionType()
        
        // Print statements to check that we are passing the correct data to the API call
        print("API Parameters")
        print("Amount: \(amount)")
        print("Category: \(category) (\(selectedCategory))")
        print("Difficulty: \(difficulty)")
        print("Type: \(type)")
        print(" ")
        
         // URL for API endpoint
         let url = URL(string: "https://opentdb.com/api.php?amount=\(amount)&category=\(category)&difficulty=\(difficulty)&type=\(type)")!
        
        print("API URL")
        print("\(url)")
        print(" ")

         // wrap in do-catch block since URL Session can throw errors
        do {
            let (data, _ ) = try await URLSession.shared.data(from: url)
            
            
//            if let dataString = String(data: data, encoding: .utf8) {
//                     print("Response Data:")
//                     print(dataString, "\n")
//                 } else {
//                     print("Failed to convert data to string")
//                 }
            
            // Decode JSON data into TriviaQuestionResponse type
            let questionsResponse = try JSONDecoder().decode(TriviaAPIResponse.self, from: data)
            
            // get the array of trivia questions from the response and decode the HTML
            let questions = questionsResponse.results.map { question in
                
                var decodedQuestion = question
                decodedQuestion.question = question.question.htmlDecoded
                decodedQuestion.correct_answer = question.correct_answer.htmlDecoded
                decodedQuestion.incorrect_answers = question.incorrect_answers.map { answer in
                    return answer.htmlDecoded
                }
                return decodedQuestion
                
            }
            
            // Print each question in the array
            for question in questions {
                print(question)
            }
            
            // set the questions state property
            self.questions = questions
            

        } catch {
            print("Error fetching questions: \(error)")
//            print(error.localizedDescription)
        }
        
        // Print each question in the array
        if questions.isEmpty {
            print("The questions array is empty")
        }
    }
    
    // finds the categoryId for the selected category
    private func findCategoryId() -> Int {
        // Find the ID of the selected user category in the category dictionary
        if let categoryId = categoryDictionary.first(where: { $0.value == selectedCategory })?.key {
            return categoryId
        } else {
            return 9 // default category ID is 9, for General Knowledge
        }
    }
    
    // finds the type of question for the API call
    private func findQuestionType() -> String {
        switch selectedQuestionType {
        case questionTypes[0]:
            return "any"
        
        case questionTypes[1]:
            return "multiple"
            
        case questionTypes[2]:
            return "boolean"
            
        default:
            return "any"
        }
    }
}

enum TimerCount: Int, CaseIterable {
    case thirty = 30
    case sixty = 60
    case hundredtwenty = 120
    case threehundred = 300
    case onehour = 3600
}

// Facilitates removing the HTML-encoding from some of the values in the JSON response from the API call from OpenDB API
extension String {
    var htmlDecoded: String {
        guard let data = data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        }
        return self
    }
    
}


#Preview {
    TriviaOptionsView()
}
