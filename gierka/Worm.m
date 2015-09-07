//
//  Worm.m
//  gierka
//
//  Created by Marek Tomaszewski on 20/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "Worm.h"
@interface Worm()

@end
@implementation Worm
-(instancetype)initWormWithPosition:(CGPoint)position{
    
    if (self = [super init]){
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"worm"];
        
        self.worm = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"robaczek1"]];
        self.worm.alpha = 0;
        self.worm.position = position;

        [self addChild:self.worm];
        
    }
    
    return self;
}

-(void)hideTheWorm{
    [self.worm removeActionForKey:@"wormAnimation"];
    
    SKAction *deAlpha = [SKAction fadeOutWithDuration:0.5];
    SKAction *remove = [SKAction removeFromParent];
//    SKAction *wiggleLeft = [SKAction scaleTo:1.0 duration:0.3];
//    SKAction *wiggleRight = [SKAction scaleTo:0.2 duration:0.3];
//    SKAction *seq = [SKAction sequence:@[wiggleLeft, wiggleRight]];
    [self.worm runAction:[SKAction sequence:@[ deAlpha, remove]]];
    
}
-(void)setupWormAnimation{
    
 //   SKAction *wait = [SKAction waitForDuration:2];
    SKAction *setTexture = [SKAction setTexture:[SKTexture textureWithImageNamed:@"robaczek2"]resize:YES];
    SKAction *fadeIn = [SKAction fadeInWithDuration:2];
    SKAction *wiggleLeft = [SKAction scaleTo:1.0 duration:0.5];
    SKAction *wiggleRight = [SKAction scaleTo:0.8 duration:0.5];
    SKAction *seq = [SKAction repeatActionForever:[SKAction sequence:@[wiggleLeft, wiggleRight]]];
    [self.worm
     runAction:[SKAction sequence:@[fadeIn, setTexture, seq]]withKey:@"wormAnimation"];
//    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:4];
//    // NSMutableArray *texturesStanding = [NSMutableArray arrayWithCapacity:3];
//    
//    for (int i = 1; i<3; i++) {
//        NSString *textureName = [NSString stringWithFormat:@"robaczek%i.png",i];
//        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
//        [textures addObject:texture];
//    }
//    
//    
//    SKAction *wormAnimation = [SKAction animateWithTextures:textures timePerFrame:1];
//    SKAction *wait = [SKAction waitForDuration:2];
//    SKAction *wormAnimSequence = [SKAction sequence:@[wormAnimation, ]];
//    
//    [self.worm runAction:wormAnimSequence completion:^{
//       
//        self.worm.size = self.worm.texture.size;
//    }];
//    
    
}

@end
