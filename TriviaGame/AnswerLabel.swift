//
//  AnswerLabel.swift
//  TriviaGame
//
//  Created by Qetsia Nkulu  on 3/30/24.
//

import SwiftUI

struct AnswerLabel: View {
    let answerText : String
    
    @State private var isSelected = false
  
    var body: some View {
        
        HStack {                            // <-- contains the text and the check
            Text(answerText)
                .foregroundColor(isSelected ? .white : .black)
        
            Spacer()

        }
        .padding()
        .font(.system(size: 20))
        .frame(width: 290)
        .background(isSelected ? Color.blue : Color.gray.opacity(0.15))
        .cornerRadius(10)
        .onTapGesture {
            isSelected.toggle()
        }
    }
}



/* WORKING BUILD 
 struct AnswerLabel: View {
     let answerText : String
     
     @State private var isSelected = false
   
     var body: some View {
         
         HStack {                            // <-- contains the text and the check
             Text(answerText)
                 .foregroundColor(isSelected ? .white : .black)
         
             Spacer()

         }
         .padding()
         .font(.system(size: 20))
         .frame(width: 290)
         .background(isSelected ? Color.blue : Color.gray.opacity(0.15))
         .cornerRadius(10)
         .onTapGesture {
             isSelected.toggle()
         }
     }
 }

 #Preview {
     AnswerLabel(answerText: "Eagle")
 }
 
 
 
 
 */





















//            if isSelected {                                   // <--- if the label has been clicked, show the checkmark
//                Image(systemName: "checkmark.circle.fill")
//                .foregroundColor(.green)
//            }
