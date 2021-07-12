//
//  ContentView.swift
//  frenchinator
//
//  Created by Ainesh Sootha on 7/3/21.
//

import SwiftUI

class Untranslated: Encodable, ObservableObject{
    var word: String
    init(worden:String){
        word = worden
    }
}




struct ContentView: View {
    @State var untranslated: Untranslated = Untranslated(worden:"")
    @State private var word: String = ""
    @State private var en_word = ""
    @State private var wordRefURL = ""
    @State private var showingTranslated = false
    @State private var headW = CGFloat(400.0)
    @State private var headH = CGFloat(250.0)
    
    let mainW = CGFloat(283.0)
    init() {
            UITextView.appearance().backgroundColor = .clear
        }
    var body: some View {
        ZStack{
            Color(red: 127.0 / 255, green: 198.0 / 255, blue: 164.0 / 255)
            .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center){
                HStack{
                    Text("Frenchinator")
                        .font(Font.custom("Roboto-Black", size:40))
                        .foregroundColor(Color(red: 9.0 / 255, green: 56.0 / 255, blue: 36.0 / 255))
                        .position(x:headW / 2, y:headH / 2)
                        
                }.frame(width: headW, height: headH, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                HStack{
                    TextEditor(text: $word)
                        .background(Color(red: 127.0 / 255, green: 198.0 / 255, blue: 164.0 / 255))
                    .foregroundColor(Color(red: 9.0 / 255, green: 56.0 / 255, blue: 36.0 / 255))
                    .font(Font.custom("Roboto-Black", size:20))
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color(red: 9.0 / 255, green: 56.0 / 255, blue: 36.0 / 255), lineWidth: 4.0))
                    .frame(width: mainW, height: 159, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                }
                HStack{
                    Button(action: {
                        untranslated = Untranslated(worden: self.word)
                        self.showingTranslated = true
                    }){
                        VStack{
                        Text("Translate")
                            .font(Font.custom("Roboto-Black", size:20))
                            .foregroundColor(Color(red: 252.0 / 255, green: 208.0 / 255, blue: 161.0 / 255))
                        
                        }
                        .frame(width: mainW, height: 57)
                        .background(Color(red: 9.0 / 255, green: 56.0 / 255, blue: 36.0 / 255))
                        .cornerRadius(60)
                    }.position(x: headW / 2, y: headH / 2)
                }.frame(width: headW, height: headH, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Spacer()
                
                Spacer()
            }
        }.sheet(isPresented: $showingTranslated, content: {
            //Show translated
            TranslatedView(untranslated: self.untranslated)
        })
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
