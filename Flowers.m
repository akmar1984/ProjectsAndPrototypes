//
//  Flowers.m
//  gierka
//
//  Created by Marek Tomaszewski on 26/01/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "Flowers.h"
#import "SKTAudio.h"
@interface Flowers ()
@property (nonatomic) SKTextureAtlas *atlas;
@end
@implementation Flowers
{
    
    NSMutableString *_string;
    SKAction *_group;
    NSMutableArray *_flowerArray;
}
#define FLOWER_OFFSET 70

static const CGFloat FirstRow = 300;
static const CGFloat SecondRow = 200;
static const CGFloat RightSideCupBoard = FirstRow +FLOWER_OFFSET;
static const CGFloat MiddleSideCupBoard = 300;
static const CGFloat LeftSideCupBoard = 300 - FLOWER_OFFSET;


-(instancetype)initWithPosition:(CGPoint)position{
    
    if (self = [super init]) {
        int flowerzPos = 3;
        self.atlas = [SKTextureAtlas atlasNamed:@"flowers"];
        
        
        self.flowerOne = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"001"]];
        self.flowerOne.position = CGPointMake(position.x+200, position.y+30); //300, 300
        [self.flowerOne setScale:0.5];
        self.flowerOne.zPosition = 4;
        self.flowerOne.name = @"flowerOne";
        self.flowerOne.alpha = 0;
        [self addChild:self.flowerOne];
        
        self.flowerTwo = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"kwiatfaza1"]];
        self.flowerTwo.position = CGPointMake(900, 500);
        [self.flowerTwo setScale:0.5];
        self.flowerTwo.name = @"flowerTwo";
        self.flowerTwo.alpha = 0;
        self.flowerTwo.zPosition = flowerzPos;
        [self addChild:self.flowerTwo];
        
        self.flowerThree = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"kwiat2c"]];
        self.flowerThree.position = CGPointMake(100, 200);
        [self.flowerThree setScale:0.5];
        self.flowerThree.name = @"flowerThree";
        self.flowerThree.alpha = 0;
        self.flowerThree.zPosition = flowerzPos;
        [self addChild:self.flowerThree];
        
        self.flowerFour = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"kwiatfaza1"]];
        self.flowerFour.position = CGPointMake(950, 300);
        [self.flowerFour setScale:0.5];
        self.flowerFour.name = @"flowerFour";
        self.flowerFour.alpha = 0;
        self.flowerFour.zPosition = flowerzPos;
        [self addChild:self.flowerFour];
        
        self.flowerFive = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"kwiat2c"]];
        self.flowerFive.position = CGPointMake(450, 150);
        [self.flowerFive setScale:0.5];
        self.flowerFive.name = @"flowerFive";
        self.flowerFive.alpha = 0;
        self.flowerFive.zPosition = flowerzPos;
        [self addChild:self.flowerFive];
        
        self.flowerSix = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"kwiatfaza1"]];
        self.flowerSix.position = CGPointMake(50, 450);
        [self.flowerSix setScale:0.5];
        self.flowerSix.name = @"flowerSix";
        self.flowerSix.alpha = 0;
        self.flowerSix.zPosition = flowerzPos;
        [self addChild:self.flowerSix];
        [self flowersQuePoints];
    }
    
    return self;
}
-(void)unhideTheFlowers{
    SKAction *fadeIn = [SKAction fadeAlphaTo:1 duration:2];
    [[SKTAudio sharedInstance]playSoundEffect:@"SFXKwiaty.mp3"];
    [self.flowerOne runAction:fadeIn];
        [self.flowerTwo runAction:fadeIn];
        [self.flowerThree runAction:fadeIn];
        [self.flowerFour runAction:fadeIn];
        [self.flowerFive runAction:fadeIn];
        [self.flowerSix runAction:fadeIn];

}
-(void)flowersQuePoints{
    
    self.flowerOneDestinationLocation = CGPointMake(300, 330); //300, 300
    self.flowerTwoDestinationLocation = CGPointMake(LeftSideCupBoard, FirstRow-10);
    self.flowerThreeDestinationLocation = CGPointMake(LeftSideCupBoard, SecondRow+10);
    self.flowerFourDestinationLocation = CGPointMake(MiddleSideCupBoard, SecondRow-30);
    self.flowerFiveDestinationLocation = CGPointMake(RightSideCupBoard, SecondRow+10);
    self.flowerSixDestinationLocation = CGPointMake(RightSideCupBoard, FirstRow-10);
    
    
}

-(void)loadTexturesWithActionForFlower{
    
    _flowerArray = [NSMutableArray arrayWithCapacity:3];
    for (int i = 1; i<4; i++) {
        NSString *textureName = [NSString stringWithFormat:@"00%i.png",i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [_flowerArray addObject:texture];
    }
    
    SKAction *rotate = [SKAction rotateByAngle:M_PI *2 duration:4];
    SKAction *scaling = [SKAction scaleTo:2 duration:4];
    SKAction *scalingDown = [SKAction scaleTo:1 duration:4];
    SKAction *flowerAnimation = [SKAction animateWithTextures: _flowerArray timePerFrame:1];
    _group = [SKAction group:@[scaling,flowerAnimation, rotate, scalingDown]];
    [self.flowerOne runAction:_group];
}

-(void)loadTexturesWithActionForFlowerTwo{
    NSMutableArray *flowerArray2 = [NSMutableArray arrayWithCapacity:3];
    for (int i = 1; i<4; i++) {
        
        NSString *textureName = [NSString stringWithFormat:@"kwiatfaza%i.png",i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [flowerArray2 addObject:texture];
        
    }
    SKAction *flowerAnimation2 = [SKAction animateWithTextures: flowerArray2 timePerFrame:1];
    SKAction *rotate = [SKAction rotateByAngle:M_PI *2 duration:4];
    SKAction *scaling = [SKAction scaleTo:2 duration:4];
    SKAction *scalingDown = [SKAction scaleTo:1 duration:4];
    _group = [SKAction group:@[scaling,flowerAnimation2, rotate, scalingDown]];
    [self.flowerTwo runAction:_group];
    
    
}
-(void)loadTexturesWithActionForFlowerThree{
    NSMutableArray *flowerArray3 = [NSMutableArray arrayWithCapacity:3];
    for (char i = 'c'; i<'f'; i++) {
        NSString *textureName = [NSString stringWithFormat:@"kwiat2%c.png",i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [flowerArray3 addObject:texture];
    }
    SKAction *flowerAnimation3 = [SKAction animateWithTextures: flowerArray3 timePerFrame:1];
    SKAction *rotate = [SKAction rotateByAngle:M_PI *2 duration:4];
    SKAction *scaling = [SKAction scaleTo:2 duration:4];
    SKAction *scalingDown = [SKAction scaleTo:1 duration:4];
    _group = [SKAction group:@[scaling,flowerAnimation3, rotate, scalingDown]];
    [self.flowerThree runAction:_group];
}
-(void)loadTexturesWithActionForFlowerFour{
    NSMutableArray *flowerArray4 = [NSMutableArray arrayWithCapacity:3];
    for (int i = 1; i<4; i++) {
        NSString *textureName = [NSString stringWithFormat:@"kwiatfaza%i.png",i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [flowerArray4 addObject:texture];
    }
    SKAction *flowerAnimation3 = [SKAction animateWithTextures: flowerArray4 timePerFrame:1];
    SKAction *rotate = [SKAction rotateByAngle:M_PI *2 duration:4];
    SKAction *scaling = [SKAction scaleTo:2 duration:4];
    SKAction *scalingDown = [SKAction scaleTo:1 duration:4];
    _group = [SKAction group:@[scaling,flowerAnimation3, rotate, scalingDown]];
    [self.flowerFour runAction:_group];
}
-(void)loadTexturesWithActionForFlowerFive{
    NSMutableArray *flowerArray5 = [NSMutableArray arrayWithCapacity:3];
    for (char i = 'c'; i<'f'; i++) {
        NSString *textureName = [NSString stringWithFormat:@"kwiat2%c.png",i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [flowerArray5 addObject:texture];
    }
    SKAction *flowerAnimation3 = [SKAction animateWithTextures: flowerArray5 timePerFrame:1];
    SKAction *rotate = [SKAction rotateByAngle:M_PI *2 duration:4];
    SKAction *scaling = [SKAction scaleTo:2 duration:4];
    SKAction *scalingDown = [SKAction scaleTo:1 duration:4];
    _group = [SKAction group:@[scaling,flowerAnimation3, rotate, scalingDown]];
    [self.flowerFive runAction:_group];
}
-(void)loadTexturesWithActionForFlowerSix{
    NSMutableArray *flowerArray6 = [NSMutableArray arrayWithCapacity:3];
    for (int i = 1; i<4; i++) {
        NSString *textureName = [NSString stringWithFormat:@"kwiatfaza%i.png",i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [flowerArray6 addObject:texture];
    }
    SKAction *flowerAnimation3 = [SKAction animateWithTextures: flowerArray6 timePerFrame:1];
    SKAction *rotate = [SKAction rotateByAngle:M_PI *2 duration:4];
    SKAction *scaling = [SKAction scaleTo:2 duration:4];
    SKAction *scalingDown = [SKAction scaleTo:1 duration:4];
    _group = [SKAction group:@[scaling,flowerAnimation3, rotate, scalingDown]];
    [self.flowerSix runAction:_group];
}
-(void)loadAllFlowersAnimations{
    SKAction *wait = [SKAction waitForDuration:1];
    
    SKAction *wait2 = [SKAction waitForDuration:7];

    SKAction *wait3 = [SKAction waitForDuration:8];

  
    int flowerOffset = arc4random() %10;
    SKAction *moveToHandOnRightSide = [SKAction moveTo: CGPointMake(520+flowerOffset, 200) duration:3];
    SKAction *moveToHandOnLeftSide = [SKAction moveTo: CGPointMake(520-flowerOffset, 200) duration:3];
   
    [self runAction:wait completion:^{
        
        [self loadTexturesWithActionForFlower];
        [self loadTexturesWithActionForFlowerTwo];
        [self loadTexturesWithActionForFlowerThree];
        [self loadTexturesWithActionForFlowerFour];
        [self loadTexturesWithActionForFlowerFive];
        [self loadTexturesWithActionForFlowerSix];
    }];

    [self runAction:wait2 completion:^{
        
        [self.flowerOne runAction:moveToHandOnRightSide];
        [self.flowerTwo runAction:moveToHandOnRightSide];
        [self.flowerThree runAction:moveToHandOnRightSide];
        [self.flowerFour runAction:moveToHandOnLeftSide];
        [self.flowerFive runAction:moveToHandOnLeftSide];
        [self.flowerSix runAction:moveToHandOnLeftSide];
    }];
   [self runAction:wait3 completion:^{
       [self descaleFlowersAndPutThemIntoHand];
      // [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarOne];
   }];
   
  
}
-(void)descaleFlowersAndPutThemIntoHand{
    SKAction *scalingDown = [SKAction scaleTo:0.3 duration:4];
    
    
    [self.flowerOne runAction:scalingDown];
    [self.flowerTwo runAction:scalingDown];
    [self.flowerThree runAction:scalingDown];
    [self.flowerFour runAction:scalingDown];
    [self.flowerFive runAction:scalingDown];
    [self.flowerSix runAction:scalingDown];

}
-(void)bounceFlowers{
    
    SKAction *bounceUp = [SKAction moveByX:0 y:20 duration:0.3];
    SKAction *bounceDown = [SKAction moveByX:0 y:-20 duration:0.3];
    SKAction *bouncing = [SKAction repeatAction:[SKAction sequence:@[bounceUp, bounceDown]] count:5];
    
    [self.flowerOne runAction:bouncing];
    [self.flowerTwo runAction:bouncing];
    [self.flowerThree runAction:bouncing];
    [self.flowerFour runAction:bouncing];
    [self.flowerFive runAction:bouncing];
    [self.flowerSix runAction:bouncing];
}
@end
