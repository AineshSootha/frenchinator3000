//
//  TranslatedView.swift
//  frenchinator
//
//  Created by Ainesh Sootha on 7/11/21.
//

import SwiftUI

class Translated: Decodable, ObservableObject{
    var en: String = "Not found"
    var wordRefURL: String = "Not found"
}

struct TranslatedView: View {
    @State var untranslated: Untranslated
    @State private var translated: Translated = Translated()
    @State private var word: String = ""
    @State private var en_word = ""
    @State private var wordRefURL = ""
    @State private var headW = CGFloat(400.0)
    @State private var headH = CGFloat(250.0)
    let mainW = CGFloat(283.0)

    var body: some View {
        ZStack{
            Color(red: 9.0 / 255, green: 56.0 / 255, blue: 36.0 / 255)
            .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center){
                HStack{
                    Text("Frenchinator")
                        .font(Font.custom("Roboto-Black", size:40))
                        .foregroundColor(Color(red: 252.0 / 255, green: 208.0 / 255, blue: 161.0 / 255))
                        .position(x:headW / 2, y:headH / 2)
                        
                }.frame(width: headW, height: headH, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                HStack{
                    Text(word)
                        .frame(width: mainW, height: 159, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .fixedSize()
                        .background(Color(red: 9.0 / 255, green: 56.0 / 255, blue: 36.0 / 255))
                        
                    .foregroundColor(Color(red: 252.0 / 255, green: 208.0 / 255, blue: 161.0 / 255))
                    .font(Font.custom("Roboto-Black", size:20))
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color(red: 252.0 / 255, green: 208.0 / 255, blue: 161.0 / 255), lineWidth: 4.0))
                    
                    
                }.onAppear{self.translate()}
                Spacer()
            }
        }
    }
    func translate(){
        let en_word = untranslated
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
                self.word = decodedEn.en
                self.translated.wordRefURL = decodedEn.wordRefURL
            } else {
                print("Invalid response from server \(data)")
            }
        }.resume()
    }
}


