//
//  ContentView.swift
//  Game
//
//  Created by 仔室宗亲 on 18/2/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack {
                Text("Bullet Storm Game")
                    .font(.title)
                    .bold()
                    .padding()
                
                NavigationLink(destination:GameView()){
                    Text("Start")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius:12))
                    
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
