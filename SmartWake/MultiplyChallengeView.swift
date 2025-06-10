import Foundation
import SwiftUI

struct MultiplyChallengeView: View {
    @State private var question: String = ""
    @State private var correctAnswer: Int = 0
    @State private var userAnswer: String = ""
    @State private var score: Int = 0           // Counts correct answers
    @State private var finished: Bool = false   // Quiz completed?

    var body: some View {
        VStack(spacing: 30) {
            Text("📚 לוח הכפל")
                .font(.title)
                .bold()

            if finished {
                Text("✅ הצלחת! אפשר לחזור לישון 😉")
                    .font(.title2)
                    .foregroundColor(.green)
            } else {
                Text(question)
                    .font(.system(size: 50, weight: .bold, design: .rounded))

                TextField("התשובה שלך", text: $userAnswer)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)

                Button("בדוק תשובה") {
                    checkAnswer()
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)

                Text("נשארו לך \(5 - score) שאלות")
                    .foregroundColor(.gray)
            }
        }
        .onAppear(perform: generateQuestion)
        .padding()
    }
    
    /// Creates a random 1×12 multiplication question.
    func generateQuestion() {
        let a = Int.random(in: 1...12)
        let b = Int.random(in: 1...12)
        question = "\(a) × \(b)"
        correctAnswer = a * b
    }
    
    /// Verifies answer and moves on or ends quiz.
    func checkAnswer() {
        if Int(userAnswer) == correctAnswer {
            score += 1
            userAnswer = ""
            if score >= 5 {
                finished = true
            } else {
                generateQuestion()
            }
        } else {
            userAnswer = ""
            generateQuestion()
        }
    }
}
