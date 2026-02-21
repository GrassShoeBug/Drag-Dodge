//
//  GameView.swift
//  Game
//
//  Created by 仔室宗亲 on 18/2/26.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    var scene: SKScene{
        let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
        scene.scaleMode = .fill
        return scene
    } 
    
    var body: some View{
        SpriteView(scene: scene)
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
    }
    
}
#Preview {
    GameView()
}
