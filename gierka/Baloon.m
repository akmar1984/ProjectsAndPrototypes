//
//  Baloon.m
//  gierka
//
//  Created by Marek Tomaszewski on 24/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "Baloon.h"
#import "SKTAudio.h"

@implementation Baloon
-(instancetype)initBaloonWithPosition:(CGPoint)position{
    
    if (self = [super init]){
        
        self.baloon = [SKSpriteNode spriteNodeWithImageNamed:@"baloon"];
        self.baloon.position = position;
        self.baloon.zPosition = 99;
        [self addChild:self.baloon];
    }
    return self;
}

-(void)setupBaloonAnimation{
    
    SKAction *moveLeft = [SKAction moveTo:CGPointMake(-self.baloon.size.width, self.baloon.position.y) duration:8];
    SKAction *wiggleUp = [SKAction scaleTo:1.2 duration:0.5];
    SKAction *wiggleDown = [SKAction scaleTo:1 duration:0.5];
    SKAction *seq = [SKAction repeatActionForever:[SKAction sequence:@[wiggleUp, wiggleDown]]];
    SKAction *baloonSeq = [SKAction group:@[moveLeft, seq]];
    [self.baloon runAction:baloonSeq completion:^{
        
        [self.baloon removeFromParent];
    }];
}
-(void)killTheBaloon{
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:2];
    SKAction *setTexture = [SKAction setTexture:[SKTexture textureWithImageNamed:@"baloonKilled"]];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *moveDown = [SKAction moveByX:-20 y:-50 duration:2];
    SKAction *seq = [SKAction group:@[setTexture, moveDown, fadeOut]];
    [self.baloon removeAllActions];
    [self.baloon runAction:[SKAction sequence:@[seq, remove]]];
    [[SKTAudio sharedInstance]playSoundEffect:@"SFXBalon.mp3"];
}
@end
