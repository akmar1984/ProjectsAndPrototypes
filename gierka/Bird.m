//
//  Bird.m
//  gierka
//
//  Created by Marek Tomaszewski on 03/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "Bird.h"

@implementation Bird

-(instancetype)initBirdWithPosition:(CGPoint)position{
    
    if (self = [super init]){
        
        self.birdBody = [SKSpriteNode spriteNodeWithImageNamed:@"birdBody"];
        self.birdBody.position = position;
        self.birdBody.zPosition = 200;
        [self addChild:self.birdBody];
        self.birdHead = [SKSpriteNode spriteNodeWithImageNamed:@"birdHead3"];
        self.birdHead.position = CGPointMake(-65, 30);
        self.birdHead.zPosition = 201;
        self.birdHead.zRotation = M_PI_4;
        [self.birdBody addChild:self.birdHead];
        
    }
    
    return self;
}

-(void)setupBirdAnimation{
    
//    [self.birdHead setTexture:[SKTexture textureWithImageNamed:@"birdHead2"]];
    
    SKAction *wait = [SKAction waitForDuration:2];
    SKAction *setTexture = [SKAction setTexture:[SKTexture textureWithImageNamed:@"birdHead4"]resize:YES];
    SKAction *setTexture2 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"birdHead3"]resize:YES];

    SKAction *block = [SKAction runBlock:^{
        self.birdHead.size = self.birdHead.texture.size;
    }];
    [self.birdHead runAction:[SKAction sequence:@[setTexture, wait, setTexture2, block]]];
  }

@end
