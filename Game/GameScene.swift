//
//  GameScene.swift
//  Game
//
//  Created by 仔室宗亲 on 18/2/26.
//

import SpriteKit
import AVFoundation
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    let player = SKSpriteNode(imageNamed: "ship")
    var enemyTextures: [SKTexture] = [
        SKTexture(imageNamed: "star"),
        SKTexture(imageNamed: "meteor"),
        SKTexture(imageNamed: "satalite")
    ] // 敌人外形
    
    var background = SKSpriteNode(imageNamed: "space")
    var scoreLabel = SKLabelNode(fontNamed: "AevnirNext-Bold")
    var score = 0
    var gameOver = false
    var gameTimer: Timer? //敌人生成+移动时间管理
    var scoreTimer: Timer? //每秒
    
    override func didMove(to view: SKView) {
        backgroundColor = .black // 当图片未加载时显示黑色
        setupBackground()
        setupPlayer()
        setupUI()
        startGame()
        
        physicsWorld.contactDelegate = self // enableds collision dection
        
        SoundManager.shared.playBackgroundMusic(fileName: "game_music")
    }
    
    func setupBackground() {
        background.size = self.size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        addChild(background)
    }
    
    func setupPlayer(){
        player.position = CGPoint(x: size.width / 2, y: 120) // 玩家刷新于底部屏幕中间
        player.size = CGSize(width: 40, height: 40)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        player.physicsBody?.isDynamic = false //取消重力
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.contactTestBitMask = 2
        addChild(player)
    }
    
    func setupUI(){
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height - 80)
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .white
        addChild(scoreLabel)
        updateScoreLabel()
    }
    
    func startGame(){
        gameTimer?.invalidate()
        scoreTimer?.invalidate()
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            self.spawnEnemy()
            self.moveEnemies()
            self.checkCollision()
        }
        
        scoreTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
            if !self.gameOver {
                self.score += 1
                self.updateScoreLabel()
            }
        }
    }
    
    func spawnEnemy() {
        let randomX = CGFloat.random(in: 50...size.width - 50)
        let randomSize = CGFloat.random(in: 20...35)
        
        // 每轮50%的概率生成敌人
        if Bool.random() {
            let enemy = SKSpriteNode(texture: enemyTextures.randomElement())
            enemy.position = CGPoint(x: randomX, y: size.height)
            enemy.size = CGSize(width: randomSize, height: randomSize)
            
            // 创造 physics body
            enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 2)
            enemy.physicsBody?.isDynamic = true
            enemy.physicsBody?.categoryBitMask = 2
            enemy.physicsBody?.contactTestBitMask = 1
            enemy.physicsBody?.collisionBitMask = 0
            enemy.physicsBody?.usesPreciseCollisionDetection = true
            
            addChild(enemy)
            
            let moveAction = SKAction.moveTo(y: -enemy.size.height, duration: 3.0)
            let removeAction = SKAction.removeFromParent()
            enemy.run(SKAction.sequence([moveAction, removeAction]))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA.categoryBitMask
        let secondBody = contact.bodyB.categoryBitMask
        
        if (firstBody == 1 && secondBody == 2) || (firstBody == 2 && secondBody == 1){
            gameOver = true
            gameTimer?.invalidate()
            scoreTimer?.invalidate()
            showGameOver()
        }
    }
    
    func moveEnemies() {
        for node in children {
            if let sprite = node as? SKSpriteNode, sprite != player, sprite != background {
                sprite.position.y -= 30
                if sprite.position.y < 0 {
                    sprite.removeFromParent()
                }
                
            }
        }
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "Timer Survived: \(score) seconds"
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let clampedX = min(max(location.x, player.size.width / 2), size.width - player.size.width / 2)
        player.position.x = clampedX
    }
    
    func checkCollision() {
        for node in children {
            if node != player, let enemy = node as? SKSpriteNode {
                let distance = sqrt(pow(player.position.x - enemy.position.x, 2) + pow(player.position.y - enemy.position.y, 2))
                
                if distance < (enemy.size.width / 2 + 20) {
                    gameOver = true
                    gameTimer?.invalidate()
                    scoreTimer?.invalidate()
                    showGameOver()
                }
            }
        }
    }
    
    func showGameOver(){
        showExplosion(at: player.position)
        
        SoundManager.shared.playSoundEffect(fileName: "game_over")
        player.removeFromParent()
        
        run(SKAction.wait(forDuration: 2.0)) {
            self.restartGame()
        }
    }
    
    func showExplosion(at position: CGPoint){
        if let explosion = SKEmitterNode(fileNamed: "Explosion.sks"){
            explosion.position = position
            addChild(explosion)
            SoundManager.shared.playSoundEffect(fileName: "explosion")
            run(SKAction.wait(forDuration: 1.0)){
                explosion.removeFromParent()
            }
        }
    }
    
    func restartGame(){
        for node in children {
            if node != background && node != player{
                node.removeFromParent()
            }
        }
        gameOver = false
        score = 0
        updateScoreLabel()
        
        if !children.contains(player){
            setupPlayer()
            setupUI()
        }
        startGame()
    }
    
}




#Preview {
    GameView()
}
