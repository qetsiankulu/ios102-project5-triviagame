//
//  RoundedButton.swift
//  TriviaGame
//
//  Created by Qetsia Nkulu  on 3/28/24.
//

import SwiftUI

struct MessageButton: View {

    let buttonText: String
    let title: String
    let message: String
    
    // Define a property to hold the button text
    @State private var showingAlert = false

    var body: some View {
        Button(action: {
            // when the button is clicked, show the alert 
            self.showingAlert = true
        }) {
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
             .alert(isPresented: $showingAlert) {
                         Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
            }
    }
}



#Preview {
    MessageButton(buttonText: "Button Text", title: "Action",  message: "You pressed me")
}











































