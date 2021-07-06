//
//  ContentView.swift
//  frenchinator
//
//  Created by Ainesh Sootha on 7/3/21.
//

import SwiftUI

struct Untranslated: Encodable{
    var word: String
}

struct Translated: Decodable{
    var en: String
    var wordRefURL: String
}

struct ContentView: View {
    @State private var word: String = ""
    @State private var en_word = ""
    @State private var wordRefURL = ""
    
    var body: some View {
        ZStack{
            Color(red: 3.0 / 255, green: 29.0 / 255, blue: 68.0 / 255)
            .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center){
                HStack{
                    Text("Frenchinator")
                        .font(Font.custom("Roboto-Black", size:40))
                        .foregroundColor(Color(red: 216.0 / 255, green: 17.0 / 255, blue: 89.0 / 255))
                }
                Spacer()
                HStack{
                    Text("Bounjour!")
                        .font(Font.custom("Roboto-Black", size:30))
                        .foregroundColor(Color(red: 216.0 / 255, green: 17.0 / 255, blue: 89.0 / 255))
                }
                .padding()
                HStack{
                    TextField("Le mot",
                              text: $word
                    ).textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                }
                HStack{
                    Button(
                        action: {self.translate()},
                        label: { Text("Click Me") }
                    )
                }
                Spacer()
                HStack{
                    Text(self.en_word)
                    Text(self.wordRefURL)
                }
                Spacer()
            }
        }
    }
    func translate(){
        let en_word = Untranslated(word: word)
        guard let encoded = try? JSONEncoder().encode(en_word)
            else{
                print("Failed to encode")
                return
                }
        let url = URL(string: "http://192.168.4.21:5000/translate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decodedEn = try? JSONDecoder().decode(Translated.self, from: data) {
                self.en_word = decodedEn.en
                self.wordRefURL = decodedEn.wordRefURL
            } else {
                print("Invalid response from server \(data)")
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
