//
//  ContentView.swift
//  Math-Tutor
//
//  Created by Bob Witmer on 2023-07-14.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var mathOperator = "+"
    @State private var messsage = ""
    @State private var emoji = ""
    @State private var firstNumberEmoji = ""
    @State private var secondNumberEmoji = ""
    @State private var emojiArray = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"
    ]
    @State private var answer = ""
    @State private var audioPlayer: AVAudioPlayer!
    @State private var textFieldIsDisabled = false
    @State private var guessButtonIsDisabled = false
    @State private var againButtonIsDissbled = true
    @FocusState private var textFieldIsFocused: Bool
    
    
    var body: some View {
        VStack {
            
            Group {
                Text(firstNumberEmoji)
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.5)
                Text(mathOperator)
                Text(secondNumberEmoji)
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.5)
            }

            .multilineTextAlignment(.center)
            
            Spacer()
            
            Text("\(firstNumber) \(mathOperator) \(secondNumber) =")
                .font(.largeTitle)
            
            // Answer
            TextField("", text: $answer)
                .textFieldStyle(.roundedBorder)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .frame(width: 60)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2 )
                }
                .keyboardType(.numberPad)
                .focused($textFieldIsFocused)
                .disabled(textFieldIsDisabled)
            
            Button("Guess") {
                textFieldIsFocused = false
                checkAnswer()
            }
            .buttonStyle(.borderedProminent)
            .font(.largeTitle)
            .disabled(answer.isEmpty || guessButtonIsDisabled)
            
            Spacer()
            
            // Feedback Message
            Text(messsage)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .foregroundColor(messsage == "Correct!" ? .green : .red)
                
            if guessButtonIsDisabled {
                Button("Try Again?") {
                    messsage = ""
                    newQuestion()
                    textFieldIsDisabled = false
                    guessButtonIsDisabled = false
                }
                .font(.largeTitle)
                .accentColor(.accentColor)
            }
            
        }
        .onAppear {
            newQuestion()
        }
        .padding()
    }
    // Initialize New Question
    func newQuestion() {
        firstNumber = Int.random(in: 1...10)
        secondNumber = Int.random(in: 1...10)
        emoji = emojiArray[Int.random(in: 0...emojiArray.count-1)]
        let emojiFirst = emoji
        firstNumberEmoji = String(repeating: emoji, count: firstNumber)
        // Make sure the Emojis are unique
        repeat {
            emoji = emojiArray[Int.random(in: 0...emojiArray.count-1)]
        } while emoji == emojiFirst
        secondNumberEmoji = String(repeating: emoji, count: secondNumber)
    }
    // Check If the Answer is correct
    func checkAnswer() {
        let result = firstNumber + secondNumber
        if let answerValue = Int(answer) {
            if result == answerValue {  // Play correct sound
                playSound(soundName: "correct")
                messsage = "Correct!"
            } else {    // Play incorrect sound
                playSound(soundName: "wrong")
                messsage = "Sorry, the correct answer is: \(result)"
            }
        } else {    // Not an Integer
            playSound(soundName: "wrong")
            messsage = "Sorry, you must enter an integer number!"
        }
        answer = ""
        textFieldIsDisabled = true
        guessButtonIsDisabled = true
    }
    // Function to Play a sound
    // Requires:    import AVFAudio
    //              @State private var audioPlayer: AVAudioPlayer!
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName).")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
