//
//  powerUpModel.swift
//  Game
//
//  Created by qingze zhu on 24/2/26.
//

import SpriteKit

enum PowerUpType {
    case speedBoost // speed up enemy movement and score block
    case slowEnemies // slow down enemy movement
    case shield // absorb one hit for the player
}

class PowerUp: SKSpriteNode {
    var type: PowerUpType
    
    init(type: PowerUpType) {
        self.type = type
        let texture: SKTexture
        
        switch type {
        case .speedBoost:
            texture = SKTexture(imageNamed: "powerup_speed")
        case .slowEnemies:
            texture = SKTexture(imageNamed: "powerup_slow")
        case .shield:
            texture = SKTexture(imageNamed: "powerup_shield")
        }
        super.init(texture: texture, color: .clear, size: CGSize(width: 30, height: 30))
        
        //set up the physics body for the collision detection
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.powerUp
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        self.physicsBody?.collisionBitMask = 0
        self.zPosition = 1
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
