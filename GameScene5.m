//
//  GameScene5.m
//  gierka
//
//  Created by Marek Tomaszewski on 04/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "GameScene5.h"
#import "Stickers.h"
#import "BellBody.h"
#import "SKTAudio.h"
#import "TheEndScene.h"

@import AVFoundation;

@interface GameScene5 ()
@property SKSpriteNode *soundIcon;
@property SKSpriteNode *arrow;
@property SKSpriteNode *clock;
@property SKSpriteNode *clockHand1;
@property SKSpriteNode *clockHand2;
@property BOOL clockHandsActive1;
@property BOOL clockHandsActive2;

@property SKSpriteNode *windowFrame;
@property SKSpriteNode *sky;
@property SKSpriteNode *carillon;

@property SKSpriteNode *starOne;
@property SKSpriteNode *starTwo;
@property SKSpriteNode *starThree;
@property BOOL starOneActive;
@property BOOL starTwoActive;
@property BOOL starThreeActive;


@property (assign) int starCounter;
@property SKEmitterNode *bigSparkEmitter;

@property SKSpriteNode *trainFrame;
@property SKSpriteNode *lokomotywa;
@property BOOL trainStatusActive;
@property BOOL touchingTrain;

@property SKSpriteNode *bearFrame;
@property SKSpriteNode *misiu;
@property BOOL bearStatusActive;
@property BOOL touchingBear;

@property SKSpriteNode *ballFrame;
@property SKSpriteNode *pilka;
@property BOOL ballStatusActive;
@property BOOL touchingBall;

@property SKSpriteNode *sheep;
@property BOOL sheepActive;
@property SKAction *fadeOut;
@property BellBody *bellBodyObject;

@property SKShapeNode *footer;
@property (nonatomic) Stickers *stickerOne;
@property (nonatomic) SKNode *stickerOneNode;
@property (nonatomic)AVAudioPlayer *backgroundMusicPlayer;
@property BOOL musicOn;
@property BOOL toysFramesActive;
@property BOOL arrowActive;
@property (assign) int sheepCounter;
@property (assign) int toysCounter;

@property CGPoint originalPosition;
@property CGPoint touchingPoint;
@property BOOL toysTouchesActive;
@end
static const int BODY_OFFSET = 100;
typedef NS_OPTIONS(u_int32_t, LBPhysicsCategory){
    LBPhysicsCategoryBear = 1 << 0,
    LBPhysicsCategoryTrain = 1 << 1,
    LBPhysicsCategoryBall = 1 << 2,
    LBPhysicsCategoryWorld = 1 << 3,
};
@implementation GameScene5


-(void)didMoveToView:(SKView *)view{
    self.toysTouchesActive = YES;
    [self setupBackgroundWithButtons];
    [self addToysToTheScene];
    [self setupToysFrames];
    
}
-(void)animateStarOne{
    
    //    [self enumerateChildNodesWithName:@"stars" usingBlock:^(SKNode *node, BOOL *stop) {
    //        //blinking
    ////        SKAction *alphaUp = [SKAction fadeAlphaTo:1.0 duration:0.7];
    ////        SKAction *alphaDown = [SKAction fadeAlphaTo:0.2 duration:0.7];
    ////        SKAction *blinkSeq = [SKAction sequence:@[alphaDown, alphaUp]];
    ////
    ////        [node runAction:[SKAction repeatActionForever:blinkSeq]];
    //
    //
    //    }];
    
    SKAction *alphaUp = [SKAction fadeAlphaTo:1.0 duration:2];
    SKAction *moveLeft = [SKAction moveByX:-300 y:0 duration:3];
    SKAction *rotateLeft = [SKAction rotateByAngle:-M_PI_4/2 duration:1];
    SKAction *rotateRight = [SKAction rotateByAngle:M_PI_4/2 duration:1];
    SKAction *rotating = [SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[rotateLeft, rotateRight]] count:3]]];
    SKAction *alphaDown = [SKAction fadeAlphaTo:0 duration:0.7];
    SKAction *wholeMove = [SKAction group:@[alphaUp, moveLeft, rotating]];
    SKAction *wholeMoveSeq = [SKAction sequence:@[wholeMove, alphaDown]];
    
    [self.starOne runAction:wholeMoveSeq completion:^{
        
        [self.starOne removeFromParent];
        [self setupStarOne];
    }];

}
-(void)animateStarTwo{
    SKAction *alphaUp = [SKAction fadeAlphaTo:1.0 duration:2];
    SKAction *alphaDown = [SKAction fadeAlphaTo:0 duration:1];
    
    SKAction *moveRight = [SKAction moveByX:50 y:0 duration:2];
    SKAction *moveLeft = [SKAction moveByX:-50 y:0 duration:2];
    SKAction *groupAction = [SKAction group:@[alphaUp, moveRight]];
    SKAction *seq = [SKAction sequence:@[moveLeft, moveRight, moveLeft]];
    
    [self.starTwo runAction:[SKAction sequence:@[groupAction,[SKAction repeatAction:seq count:2]]]completion:^{
        [self.starTwo runAction:alphaDown];
        [self.starTwo removeFromParent];
        [self setupStarTwo];
    }];
}
-(void)animateStarThree{
    SKAction *alphaUp = [SKAction fadeAlphaTo:1.0 duration:2];
    SKAction *alphaDown = [SKAction fadeAlphaTo:0 duration:1];
    
    SKAction *moveDown = [SKAction moveByX:0 y:-50 duration:2];
    SKAction *moveUp = [SKAction moveByX:0 y:50 duration:2];
    SKAction *groupAction = [SKAction group:@[alphaUp, moveDown]];
    SKAction *seq = [SKAction sequence:@[moveUp, moveDown, moveUp]];
    
    [self.starThree runAction:[SKAction sequence:@[groupAction,[SKAction repeatAction:seq count:2]]]completion:^{
        [self.starThree runAction:alphaDown];
        [self.starThree removeFromParent];
        [self setupStarThree];
    }];
}
-(void)setupStarOne{
    self.starCounter = 0;
    if (self.starCounter == 0 || self.starCounter == 1) {
        self.starOne = [SKSpriteNode spriteNodeWithImageNamed:@"naklejka1"];
        self.starOne.position = CGPointMake(900, 440);
        self.starOne.alpha = 0;
        self.starOne.name = @"stars";
        [self.starOne setScale:0.3];
        SKAction *wait = [SKAction waitForDuration:3];
        [self runAction:wait completion:^{
            self.starOneActive = YES;
            [self addChild:self.starOne];
            [self animateStarOne];
        }];
        
    }
    
}

-(void)setupStarTwo{
    if (self.starCounter == 2) {
        self.starTwo = [SKSpriteNode spriteNodeWithImageNamed:@"naklejka2"];
        self.starTwo.position = CGPointMake(0, 300);
        self.starTwo.name = @"stars";
        [self.starTwo setScale:0.3];
        self.starTwoActive = YES;

        [self addChild:self.starTwo];
        [self animateStarTwo];
    }
    
}
-(void)setupStarThree{
    if (self.starCounter == 3) {
        self.starThree = [SKSpriteNode spriteNodeWithImageNamed:@"naklejka3"];
        self.starThree.position = CGPointMake(self.size.width/2, self.size.height);
        self.starThree.name = @"stars";
        self.starThreeActive = YES;

        [self.starThree setScale:0.3];
        [self addChild:self.starThree];
        [self animateStarThree];
    }
}

-(void)setupBackgroundWithButtons{
    
    self.physicsWorld.gravity = CGVectorMake(0, 0.2);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    [[SKTAudio sharedInstance]playBackgroundMusic:@"LittleBellRoomNightMastered.mp3"];
    SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"noc"];
    backgroundImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    backgroundImage.zPosition = -2;
    [self addChild:backgroundImage];
    self.soundIcon = [SKSpriteNode spriteNodeWithImageNamed:@"glosnik"];
    self.soundIcon.position = CGPointMake(self.soundIcon.size.width+50, self.size.height-self.soundIcon.size.height);
    [self addChild:self.soundIcon];
    
//    self.footer = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(1024, 70)];
//    
//    self.footer.fillColor = [SKColor whiteColor];
//    self.footer.zPosition = 101;
//    self.footer.position = CGPointMake(512, 50);
    
   // [self addChild:self.footer];
    
    self.arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrowRight"];
    self.arrow.position = CGPointMake(self.size.width-self.arrow.size.width/2, self.arrow.size.height);
    self.arrow.zPosition = 102;
    self.arrow.alpha = 0.5;
    self.arrowActive = NO;
    [self addChild:self.arrow];
    
    self.stickerOneNode = [SKNode node];
    self.stickerOne = [[Stickers alloc]initStickerWithPosition:CGPointMake(0, 768)andStickerFormsPosition:CGPointMake(130, 50)];
    [self.stickerOneNode addChild:self.stickerOne];
    [self addChild:self.stickerOneNode];
    
    self.clock = [SKSpriteNode spriteNodeWithImageNamed:@"clock2"];
    self.clock.position = CGPointMake(275, 570);
    [self addChild:self.clock];
    
    self.clockHand1 = [SKSpriteNode spriteNodeWithImageNamed:@"wskazowka"];
    self.clockHand1.position = CGPointMake(273, 565);
    self.clockHand1.zPosition = 3;
    self.clockHand1.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:self.clockHand1];
    self.clockHand2 = [SKSpriteNode spriteNodeWithImageNamed:@"wskazowka2"];
    self.clockHand2.position = CGPointMake(273, 565);
    self.clockHand2.zPosition = 3;
    self.clockHand2.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:self.clockHand2];
    
    self.windowFrame = [SKSpriteNode spriteNodeWithImageNamed:@"ramaNoc"];
    self.windowFrame.position = CGPointMake(self.size.width - self.windowFrame.size.width/2 -20, self.size.height - 210);
    self.sky = [SKSpriteNode spriteNodeWithImageNamed:@"zaOknem"];
    self.sky.zPosition = -1;
    self.sky.position = CGPointMake(self.size.width - self.windowFrame.size.width/2-20, self.size.height/1.5+47);
    
    [self addChild:self.windowFrame];
    [self addChild:self.sky];
    
    self.carillon = [SKSpriteNode spriteNodeWithImageNamed:@"postac lezaca02"];
    self.carillon.position = CGPointMake(260, 340);
    
    self.carillon.zPosition = 100;
    [self addChild:self.carillon];
    [self addSheep];
    //    self.bellBodyObject = [[BellBody alloc]initBellWithBodyandHeadInPosition:CGPointMake(270, 200)];
    //    SKNode *bellNode = [SKNode node];
    //
    //    [bellNode addChild:_bellBodyObject];
    //    bellNode.zPosition = 0;
    //    [self addChild:bellNode];
}
-(void)setupToysFrames{
    
    
    self.trainFrame = [SKSpriteNode spriteNodeWithImageNamed:@"obwodka lokomotywa"];
    self.ballFrame = [SKSpriteNode spriteNodeWithImageNamed:@"obwodka pilka"];
    self.bearFrame = [SKSpriteNode spriteNodeWithImageNamed:@"obwodka mis"];
    self.trainFrame.name = @"toys";
    self.ballFrame.name = @"toys";
    self.bearFrame.name = @"toys";
    
    self.trainFrame.alpha = 0;
    self.ballFrame.alpha = 0;
    self.bearFrame.alpha = 0;
    //set the positions
   // self.trainFrame.position = CGPointMake(self.size.width - self.trainFrame.size.width/2, 250);
    self.trainFrame.position = CGPointMake(900, 250);

    self.ballFrame.position = CGPointMake(800, 450);
    self.bearFrame.position = CGPointMake(600, 450);
    [self addChild:self.trainFrame];
    [self addChild:self.ballFrame];
    [self addChild:self.bearFrame];
    
}
-(void)setToysAlpha{
    SKAction *alphaUp = [SKAction fadeAlphaTo:1.0 duration:2];
    [self enumerateChildNodesWithName:@"toys" usingBlock:^(SKNode *node, BOOL *stop) {
        
        [node runAction:alphaUp];
        node.zPosition =2;
        self.toysFramesActive = YES;
    }];
}
-(void)addToysToTheScene{
    
    self.bearStatusActive = YES;
    self.misiu = [SKSpriteNode spriteNodeWithImageNamed:@"bear"];
    self.misiu.zPosition = 102;
    self.misiu.position = CGPointMake(850, 150);
    self.misiu.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: self.misiu.frame.size];
    self.misiu.physicsBody.categoryBitMask = LBPhysicsCategoryBear;
    self.misiu.physicsBody.collisionBitMask = LBPhysicsCategoryWorld;
    self.misiu.physicsBody.restitution = 0.5;
    self.misiu.physicsBody.affectedByGravity = NO;
    [self addChild:self.misiu];
    
    self.trainStatusActive = YES;
    self.lokomotywa = [SKSpriteNode spriteNodeWithImageNamed:@"train"];
    self.lokomotywa.position = CGPointMake(140, 150);
    self.lokomotywa.zPosition = 102; //same like the bear
    self.lokomotywa.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.lokomotywa.frame.size];
    self.lokomotywa.physicsBody.categoryBitMask = LBPhysicsCategoryTrain;
    self.lokomotywa.physicsBody.collisionBitMask = LBPhysicsCategoryWorld;
    self.lokomotywa.physicsBody.restitution = 0.5;
    self.lokomotywa.physicsBody.affectedByGravity = NO;
    [self addChild:self.lokomotywa];
    
    self.ballStatusActive = YES;
    self.pilka = [SKSpriteNode spriteNodeWithImageNamed:@"ballCorrect"];
    self.pilka.name = @"ball";
    self.pilka.position = CGPointMake(500, 160);
    self.pilka.zPosition = 1;
    self.pilka.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.pilka.frame.size.width/2];
    self.pilka.physicsBody.affectedByGravity = NO;
    self.pilka.physicsBody.restitution = 0.5;
    self.pilka.physicsBody.density = 0.4;
    self.pilka.physicsBody.categoryBitMask = LBPhysicsCategoryBall;
    self.pilka.physicsBody.collisionBitMask = LBPhysicsCategoryWorld;
    self.pilka.zPosition = 102;
    [self addChild:self.pilka];
    
}
-(void)addSheep{
    self.sheepActive = YES;
    if (self.sheepCounter < 3) {
        self.sheep = [SKSpriteNode spriteNodeWithImageNamed:@"baranSizeSmall"];
        self.sheep.position = CGPointMake(self.carillon.position.x-40, self.carillon.position.y+10);
        self.sheep.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sheep.frame.size];
        self.sheep.physicsBody.restitution = 0.2;
        self.sheep.physicsBody.friction = 0;
        self.sheep.physicsBody.density = 10.0;
        self.sheep.zPosition = 101;
        
        
        SKAction *rotate = [SKAction rotateByAngle:-M_PI duration:5];
        self.fadeOut = [SKAction fadeOutWithDuration:5];
        SKAction *fadeIn = [SKAction fadeInWithDuration:1];
        
        [self addChild:self.sheep];
        [self.sheep runAction:[SKAction repeatAction:rotate count:2]];
        [self.sheep runAction:fadeIn];
        [self.sheep runAction:self.fadeOut completion:^{
            
            [self.sheep removeFromParent];
            [self addSheep];
        }];
    }
    
}
-(void)rotateTheClockHands{
    SKAction *rotation = [SKAction rotateByAngle:-M_PI duration:2];
    SKAction *rotation1 = [SKAction rotateByAngle:-M_PI duration:3];
   // self.clockCounter++;
    [self.clockHand2 runAction:rotation completion:^{
        
        self.clockHandsActive1 = NO;
    }];
    
    [self.clockHand1 runAction:rotation1 completion:^{
        
        self.clockHandsActive2 = NO;
    }];
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ([self.sheep containsPoint:location] && self.sheepActive) {
            self.sheepActive = NO;
            [self.sheep setTexture:[SKTexture textureWithImageNamed:@"touchedSheep"]];
            [[SKTAudio sharedInstance]playSoundEffect:@"SFXBarany.mp3"];
            SKAction *touchedSheepAction = [SKAction fadeOutWithDuration:0.2];
            SKAction *wait = [SKAction waitForDuration:2];
            [self.sheep runAction:touchedSheepAction completion:^{
                
                [self.sheep removeFromParent];
                self.sheepCounter++;
                [self runAction:wait completion:^{
                    [self addSheep];
                    
                    
                }];
            }];
        }
        if ([self.clock containsPoint:location] && !self.clockHandsActive1 && !self.clockHandsActive2){
            self.clockHandsActive1 = YES;
            self.clockHandsActive2 = YES;
            [self.clockHand1 runAction:[SKAction playSoundFileNamed:@"ClockSFX.mp3" waitForCompletion:NO]];
            if (self.clockHand1) {
                [self rotateTheClockHands];
            }
        }
        if ([self.arrow containsPoint:location]&& self.arrowActive){
            
            SKView * skView = (SKView *)self.view;
            skView.showsFPS = NO;
            skView.showsNodeCount = NO;
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = YES;

            // Create and configure the scene.
            SKScene *theEndScene = [[TheEndScene alloc]initWithSize:self.size];
            theEndScene.scaleMode = SKSceneScaleModeAspectFill;
            // [self fadeOutTheMusic];
            [[SKTAudio sharedInstance]pauseSoundEffect];
            [[SKTAudio sharedInstance]pauseSoundEffectInaLoop];
            [[SKTAudio sharedInstance]pauseBackgroundMusic];
            SKTransition *transition = [SKTransition fadeWithColor:[UIColor blackColor] duration:5];
            // Present the scene.
            [self.view presentScene:theEndScene transition:transition];
        }
        if ([self.misiu containsPoint:location] && self.bearStatusActive && self.toysFramesActive &&self.toysTouchesActive ) {
            self.touchingBear = YES;
            self.originalPosition = self.misiu.position;
            self.touchingPoint = location;
            self.misiu.zPosition = 400;
            self.misiu.xScale = 1.4;
            self.misiu.yScale = 1.4;
        }
        if ([self.starOne containsPoint:location] && self.starOneActive){
            self.starOneActive = NO;
            SKAction *wait = [SKAction waitForDuration:2];
            self.starCounter = 2;
            [self setupSparkEmiter:location forSticker:self.starOne];
            [self runAction:wait completion:^{
                //[self.starOne removeFromParent];
                
                [self setupStarTwo];
            }];
            
            
        }
        if ([self.starTwo containsPoint:location]&& self.starTwoActive){
            self.starTwoActive = NO;
            SKAction *wait = [SKAction waitForDuration:2];
            self.starCounter = 3;
            [self setupSparkEmiter:location forSticker:self.starTwo];
            [self runAction:wait completion:^{
                [self.starTwo removeFromParent];
                [self setupStarThree];
            }];
            
            
        }
        if ([self.starThree containsPoint:location]&& self.starThreeActive){
            self.starThreeActive = NO;
            self.starCounter = 4;
            [self setupSparkEmiter:location forSticker:self.starThree];
            [self.starThree removeFromParent];
            
        }
        if ([self.lokomotywa containsPoint:location] && self.trainStatusActive && self.toysFramesActive && self.toysTouchesActive) {
            self.touchingTrain = YES;
            self.originalPosition = self.lokomotywa.position;
            self.touchingPoint = location;
            self.lokomotywa.zPosition = 400;
            self.lokomotywa.xScale = 1.4;
            self.lokomotywa.yScale = 1.4;
        }
        if ([self.pilka containsPoint:location] && self.ballStatusActive && self.toysFramesActive && self.toysFramesActive) {
            self.touchingBall = YES;
            self.originalPosition = self.pilka.position;
            self.touchingPoint = location;
            self.pilka.zPosition = 400;
            self.pilka.xScale = 1.4;
            self.pilka.yScale = 1.4;
        }
    }
    
}
-(void)setupSparkEmiter:(CGPoint)coordinates forSticker:(SKSpriteNode *)sprite{
    
    
    self.bigSparkEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"Spark" ofType:@"sks"]];
    self.bigSparkEmitter.zPosition = 500;
    self.bigSparkEmitter.position = coordinates;
    
    [self addChild:self.bigSparkEmitter];
    [[SKTAudio sharedInstance]playSoundEffect:@"SFXZbicieGwiazdki.mp3"];
    [sprite removeFromParent];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    self.touchingPoint = [[touches anyObject]locationInNode:self];
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    self.touchingBall = NO;
    self.touchingBear = NO;
    self.touchingTrain = NO;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint currentPoint = [[touches anyObject]locationInNode:self];
    
    if (self.touchingBear && self.toysFramesActive) {
        CGPoint bearFramePos = self.bearFrame.position;
        if ( [self isWithinToyFrame:self.bearFrame inPosition:currentPoint] )
        {
            self.touchingBear = NO;
            self.misiu.position = bearFramePos;
            self.bearStatusActive = NO;
            SKAction *scaleDown = [SKAction scaleTo:1 duration:1];
            self.misiu.zPosition = 1;
            [self.misiu runAction:scaleDown];
            
            
            
        }else{
            self.touchingBear = NO;
            [self animatePuttingThingsBack:self.misiu];
        }
    }
    
    if (self.touchingTrain && self.toysFramesActive) {
        CGPoint trainFramePos = self.trainFrame.position;
        if ( [self isWithinToyFrame:self.trainFrame inPosition:currentPoint] )
        {
            self.touchingTrain = NO;
            self.lokomotywa.position = trainFramePos;
            self.trainStatusActive = NO;
            SKAction *scaleDown = [SKAction scaleTo:1 duration:1];
            self.lokomotywa.zPosition = 1;
            [self.lokomotywa runAction:scaleDown];
            
            
            
        }else{
            self.touchingTrain = NO;
            [self animatePuttingThingsBack:self.lokomotywa];
        }
        
    }
    if (self.touchingBall && self.toysFramesActive) {
        CGPoint ballFramePos = self.ballFrame.position;
        if ( [self isWithinToyFrame:self.ballFrame inPosition:currentPoint] )
        {
            self.touchingBall = NO;
            self.pilka.position = ballFramePos;
            self.ballStatusActive = NO;
            SKAction *scaleDown = [SKAction scaleTo:1 duration:1];
            self.pilka.zPosition = 1;
            [self.pilka runAction:scaleDown];
            
            
            
        }else{
            self.touchingBall = NO;
            [self animatePuttingThingsBack:self.pilka];
        }
        
    }
    
}
-(void)update:(NSTimeInterval)currentTime{
    
    if (self.touchingBear) {
        self.misiu.position = self.touchingPoint;
    }
    if (self.touchingBall) {
        self.pilka.position = self.touchingPoint;
    }
    if (self.touchingTrain) {
        self.lokomotywa.position = self.touchingPoint;
    }
    if (self.toysCounter == 3) {
        self.toysCounter = 0;
        [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarThree];
        [self setupStarOne];

    }
    
    if (self.sheepCounter == 3){
        self.sheepCounter = 4;
        [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarOne];
        [self setToysAlpha];
    }
    if (self.starCounter == 4) {
        self.starCounter = 0;
        [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarTwo];
    }
    
    if (self.stickerOne.stickerCounter == 3 && self.arrowActive == NO) {
        [self blinking];
    }
    
}
-(void)blinking{
    SKAction *alphaUp = [SKAction fadeAlphaTo:1.0 duration:0.7];
    SKAction *alphaDown = [SKAction fadeAlphaTo:0.2 duration:0.7];
    SKAction *blinkSeq = [SKAction sequence:@[alphaDown, alphaUp]];
    self.arrowActive = YES;
    [self.arrow runAction:[SKAction repeatActionForever:blinkSeq]];
    
}

-(void)animatePuttingThingsBack:(SKSpriteNode *)node
{
    
    self.toysTouchesActive = NO;
    SKAction *scaleDown = [SKAction scaleTo:1 duration:1];
    SKAction *moveLeft = [SKAction moveByX:-10 y:0 duration:0.2];
    SKAction *moveRight = [SKAction moveByX:10 y:0 duration:0.2];
    
    SKAction *fastMovementSeq = [SKAction repeatAction:[SKAction sequence:@[moveLeft, moveRight]] count:4];
    SKAction *moveBack = [SKAction moveTo:self.originalPosition duration: 1];
    SKAction *rotateBack = [SKAction rotateByAngle:M_PI *2 duration:0.5];
    SKAction *group = [SKAction group:@[moveBack, rotateBack]];
    ;
    
    SKAction *seq =[SKAction group: @[scaleDown, fastMovementSeq, group]];
    [node runAction:seq completion:^{
        
        self.toysTouchesActive = YES;
    }];
    
}
-(BOOL)isWithinToyFrame:(SKSpriteNode *)toyFrame inPosition:(CGPoint)currentLocation{
    if (currentLocation.x >= toyFrame.position.x - BODY_OFFSET && currentLocation.x <= toyFrame.position.x + BODY_OFFSET && currentLocation.y >= toyFrame.position.y - BODY_OFFSET && currentLocation.y <= toyFrame.position.y + BODY_OFFSET){
        self.toysCounter++;
        [[SKTAudio sharedInstance]playSoundEffect:@"SFX Scena1 zabawka w formie.mp3"];

        return YES;
    }else
        return NO;
}
- (void)showSoundButtonForTogglePosition:(BOOL)togglePosition
{
    if (togglePosition)
    {
        self.soundIcon.texture = [SKTexture textureWithImageNamed:@"glosnik2"];
        self.musicOn = NO;
        [_backgroundMusicPlayer stop];
    }
    else
    {
        self.soundIcon.texture = [SKTexture textureWithImageNamed:@"glosnik"];
        self.musicOn = YES;
        [_backgroundMusicPlayer play];
    }
}
@end
