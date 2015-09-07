//
//  Stickers.m
//  gierka
//
//  Created by Marek Tomaszewski on 03/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "Stickers.h"
@interface Stickers ()
{
    SKTextureAtlas *_atlas;
    
}
@property (nonatomic)SKAction *moveToTheStickerForm;
@end
@implementation Stickers

-(instancetype)initStickerWithPosition:(CGPoint)position andStickerFormsPosition:(CGPoint)position2{
    
    if (self = [super init]){
        _atlas = [SKTextureAtlas atlasNamed:@"stickers"];
        
        self.stickerStarOne = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"naklejka1"]];
        self.stickerStarOne.position = position;
        self.stickerStarOne.zPosition = 302;
        [self.stickerStarOne setScale:0.5];
        self.stickerStarOne.alpha = 0;
        self.stickerStarOne.name = @"stickerOne";
        [self addChild:self.stickerStarOne];
        
        self.stickerStarTwo = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"naklejka2"]];
        self.stickerStarTwo.position = position;
        self.stickerStarTwo.zPosition = 302;
        [self.stickerStarTwo setScale:0.5];
        self.stickerStarTwo.alpha = 0;
        self.stickerStarTwo.name = @"stickerTwo";
        [self addChild:self.stickerStarTwo];
        
        self.stickerStarThree = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"naklejka3"]];
        self.stickerStarThree.position = position;
        self.stickerStarThree.zPosition = 302;
        [self.stickerStarThree setScale:0.5];
        self.stickerStarThree.alpha = 0;
        self.stickerStarThree.name = @"stickerThree";
        [self addChild:self.stickerStarThree];
        //foremki
        self.stickersForms = [SKSpriteNode spriteNodeWithImageNamed:@"stickersFormsEdited"];
        self.stickersForms.position = position2;
        self.stickersForms.zPosition = 299;
        [self addChild:self.stickersForms];
       
    }
    return self;
}

#define STICKER_OFFSET 75
-(void)runStickerAnimation:(SKSpriteNode *)sticker {
    CGPoint stickersFormsPosition = self.stickersForms.position;
    SKAction *rotate = [SKAction rotateByAngle:M_PI *2 duration:2];
    SKAction *scaling = [SKAction scaleTo:1 duration:4];
    SKAction *descale = [SKAction scaleTo:0.5 duration:3];
   SKAction *alphaUp = [SKAction fadeAlphaTo:1 duration:1];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 768);
    CGPathAddLineToPoint(path, NULL, 512, 400);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(512, 400, 100, 100) cornerRadius:100];
    SKAction *followThePath = [SKAction followPath:path asOffset:NO orientToPath:NO duration:2];
    //SKAction *followThePath = [SKAction moveTo:CGPointMake(500, 500) duration:2];
    SKAction *followTheCirclePath = [SKAction followPath:bezierPath.CGPath asOffset:NO orientToPath:NO duration:2];
    
    SKAction *group =  [SKAction group:@[rotate, alphaUp, scaling, followThePath]];
    SKAction *bounceSeq = [SKAction sequence:@[[SKAction scaleTo:0.8 duration:0.5], [SKAction scaleTo:1 duration:0.5]]];
    SKAction *bounceSeq2 = [SKAction sequence:@[[SKAction scaleTo:0.8 duration:0.5], [SKAction scaleTo:0.3 duration:0.5]]];
    
    
    
    if ([sticker.name isEqualToString:@"stickerOne"]) {
        self.moveToTheStickerForm = [SKAction moveTo:
                                CGPointMake(stickersFormsPosition.x, stickersFormsPosition.y) duration:2];
        self.stickerCounter++;
    }else if ([sticker.name isEqualToString:@"stickerTwo"]) {
        self.moveToTheStickerForm = [SKAction moveTo:
                                CGPointMake(stickersFormsPosition.x + STICKER_OFFSET, stickersFormsPosition.y) duration:2];
                self.stickerCounter++;
    }
    if ([sticker.name isEqualToString:@"stickerThree"]) {
        self.moveToTheStickerForm = [SKAction moveTo:
                                CGPointMake(stickersFormsPosition.x - STICKER_OFFSET, stickersFormsPosition.y) duration:2];
                self.stickerCounter++;
    }
//        [SKAction moveTo:[sticker.name isEqualToString:@"stickerOne"] ?
//         CGPointMake(stickersFormsPosition.x,stickersFormsPosition.y):
//         CGPointMake(stickersFormsPosition.x + STICKER_OFFSET, stickersFormsPosition.y) duration:2];
//    SKAction *moveToTheStickerForm = [SKAction moveTo:
//                                                                 CGPointMake(stickersFormsPosition.x, stickersFormsPosition.y) duration:2];
//    

   SKAction *group2 = [SKAction group:@[descale, self.moveToTheStickerForm]];
    
    [sticker runAction:[SKAction playSoundFileNamed:@"SFX Scena1 gwiazdka.mp3" waitForCompletion:NO]];
    [sticker runAction:[SKAction sequence:@[group, bounceSeq , followTheCirclePath, group2, bounceSeq2]]];
}
-(void)addStarsInPosition:(CGPoint)position{
    _atlas = [SKTextureAtlas atlasNamed:@"stickers"];
    
    self.stickerStarOne = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"naklejka1"]];
    self.stickerStarOne.position = position;
    self.stickerStarOne.zPosition = 302;
    [self.stickerStarOne setScale:0.5];
    self.stickerStarOne.alpha = 0;
    self.stickerStarOne.name = @"stickerOne";
    [self addChild:self.stickerStarOne];
    
    self.stickerStarTwo = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"naklejka2"]];
    self.stickerStarTwo.position = position;
    self.stickerStarTwo.zPosition = 302;
    [self.stickerStarTwo setScale:0.5];
    self.stickerStarTwo.alpha = 0;
    self.stickerStarTwo.name = @"stickerTwo";
    [self addChild:self.stickerStarTwo];
    
    self.stickerStarThree = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"naklejka3"]];
    self.stickerStarThree.position = position;
    self.stickerStarThree.zPosition = 302;
    [self.stickerStarThree setScale:0.5];
    self.stickerStarThree.alpha = 0;
    self.stickerStarThree.name = @"stickerThree";
    [self addChild:self.stickerStarThree];
}
@end
