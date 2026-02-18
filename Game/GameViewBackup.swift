//
//  GameView.swift
//  Game
//
//  Created by 仔室宗亲 on 18/2/26.
//

import SwiftUI

struct GameView_Backup: View {
    @State private var playerPosition: CGPoint = CGPoint(x: 200, y: 600)
    @State private var score = 0
    @State private var gameOver = false
    @State private var enemies: [Enemy] = []
    @State private var gameTimer: Timer?
    @State private var scoreTimer: Timer?
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all) //最底下那层
            Text("Bullet Storm Game")
                .font(.largeTitle)
                .foregroundStyle(.white)
                .offset(y:-350)
            
            //玩家操纵的小球
            Circle()
                .fill(Color.blue)
                .frame(width:40, height:40)
                .position(playerPosition)
                .gesture(dragGesture)
                .gesture(tapGesture)
                .gesture(longPressGesture)
            
            ForEach(enemies) { enemy in
                Circle()
                    .fill(Color.purple)
                    .frame(width: enemy.size, height: enemy.size)
                    .position(enemy.position)
            }
            
            //分数显示
            Text("Time Survived: \(score) sec")
                .font(.title)
                .foregroundStyle(.white)
                .offset(y:-300)
            
            if gameOver {
                VStack{
                    Text("You Died!")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                    Button(action: resetGame){
                        Text("Restart Gmae")
                            .font(.title2)
                            .padding()
                            .frame(width:200)
                            .backgroundStyle(.green)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .offset(y:-200)
            }
        }
        .onAppear{
            startGame()
        }
    }
    //处理方程
    
    //tapping
    var tapGesture: some Gesture{
        TapGesture()
            .onEnded{
                if playerPosition.y > 100{
                    withAnimation(.spring()){
                        playerPosition.y -= 50
                    }
                }
            }
    }
    
    var longPressGesture: some Gesture{
        LongPressGesture(minimumDuration: 0.5)
            .onEnded{ _ in
                if playerPosition.y < 700 {
                    withAnimation(.spring()){
                        playerPosition.y += 50
                    }
                }
            }
    }
    
    var dragGesture: some Gesture{
        DragGesture()
            .onChanged{
                value in
                withAnimation(.easeIn(duration: 0.1)){
                    playerPosition.x = value.location.x
                    //只允许左右拖动
                }
            }
    }
    
    //开始
    func startGame(){
        gameTimer?.invalidate()
        scoreTimer?.invalidate()
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true){ _ in
            spawnEnemy()
            moveEnemies()
            checkCollision()
        }
        
        scoreTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
            if !gameOver{
                score += 1
            }
        }
    }
    
    func spawnEnemy(){
        let randomX = CGFloat.random(in: 50...350)
        let randomSize = CGFloat.random(in: 20...35)
        
        if Bool.random() && Bool.random(){
            let newEnemy = Enemy(position: CGPoint(x:randomX, y:0), size: randomSize)
            enemies.append(newEnemy)
        }
    }
    
    func moveEnemies(){
        for index in enemies.indices{
            withAnimation(.linear(duration: 0.3)){
                enemies[index].position.y += 30
            }
        }
        enemies.removeAll(){ $0.position.y > 750 }
    }
    
    func checkCollision(){
        for enemy in enemies {
            let distance = sqrt(pow(playerPosition.x - enemy.position.x, 2) + pow(playerPosition.y - enemy.position.y, 2))
            
            if distance < (enemy.size / 2 + 25){
                gameOver = true
                gameTimer?.invalidate()
                scoreTimer?.invalidate()
            }
        }
    }
    
    func resetGame() {
        playerPosition = CGPoint(x: 200, y: 600)
        score = 0
        enemies.removeAll()
        gameOver = false
        startGame()
    }
}

struct Enemy: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
}

#Preview {
    GameView()
}
