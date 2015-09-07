//
//  GameScene.m
//  gierka
//
//  Created by Marek Tomaszewski on 27/10/2014.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "GameScene.h"
#import "GameScene2.h"
#import "Stickers.h"
#import "BellBody.h"
#import "GameViewController.h"
#import "SKTAudio.h"

@interface GameScene ()


#pragma mark PROPERTIES

@property SKSpriteNode *carillon;
@property SKSpriteNode *clock;
@property SKSpriteNode *clockHand1;
@property SKSpriteNode *clockHand2;
@property SKSpriteNode *bed;
@property SKEmitterNode *hintSpark;

@property SKSpriteNode *biedrona;
@property SKSpriteNode *biedrona1;
@property SKSpriteNode *textRect;
@property SKLabelNode *anyTextLabel;

@property SKSpriteNode *cupboard;
@property SKShapeNode *footer;
//Okno
@property SKSpriteNode *window;
@property SKSpriteNode *sky;
@property SKSpriteNode *sun;
@property SKSpriteNode *tree;
@property BellBody *bellBodyObject;
//Special Effects
@property SKEmitterNode *trail;
@property SKEmitterNode *behindTheWindowEmitter;
@property SKEmitterNode *sheepEmitter;
@property SKEmitterNode *explosionEmitter;
@property SKEmitterNode *littleSparkEmitter;

//Audio
@property SKAction *playText;

//Icons
@property SKSpriteNode *arrow;
@property SKSpriteNode *soundIcon;
@property SKSpriteNode *carillonSleepingText;
@property Stickers *stickerOne;
//Zabawki
@property SKSpriteNode *misiu;
@property SKSpriteNode *pilka;
@property SKSpriteNode *lokomotywa;
@property SKSpriteNode *bearFrame;
@property SKSpriteNode *ballFrame;
@property SKSpriteNode *trainFrame;

@property NSArray *characterWalkingFrames;

@property SKAction *wait;
#pragma mark BOOLs
@property BOOL touchingBear;
@property BOOL touchingTrain;

@property  BOOL touchingBall;
@property  BOOL touchingLadyBird;
@property  BOOL touchingCarillon;
@property  BOOL carillonIsStanding;
@property  BOOL musicOn;
@property  BOOL toysFramesActive;
@property BOOL trainStatusActive;
@property BOOL ballStatusActive;
@property BOOL bearStatusActive;
@property BOOL arrowActive;
@property BOOL clockHandsActive1;
@property BOOL clockHandsActive2;

@property CGPoint touchingPoint;
@property CGPoint touchingPoint2;
@property CGPoint sunPosition;
@property (assign) int clockCounter;
@property GameViewController *gameViewController;





@end

#define ARC4RANDOM_MAX 0x100000000
static inline CGFloat ScalarRandomRange(CGFloat min,
                                        CGFloat max)
{
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}
static const int TOY_OFFSET = 50;
static const int BODY_OFFSET = 100;
typedef NS_OPTIONS(uint32_t, LBPhysicsCategory) {
    LBPhysicsCategoryBear = 1 << 0, // 0001 = 1
    LBPhysicsCategoryTrain = 1 << 1, // 0010 = 2
    LBPhysicsCategoryBall = 1 << 2, //0100 = 4
    LBPhysicsCategoryWorld = 1 << 3, //1000 = 8?
};




@implementation GameScene



-(void)fadeOutTheMusic
{
    if (self.backgroundMusicPlayer.volume > 0.1) {
        self.backgroundMusicPlayer.volume = self.backgroundMusicPlayer.volume - 0.1;
        [self performSelector:@selector(fadeOutTheMusic) withObject:nil afterDelay:0.1];
        if (self.backgroundMusicPlayer == 0) {
        }
    } else {
        // Stop and get the sound ready for playing again
        [self.backgroundMusicPlayer stop];
        self.backgroundMusicPlayer.currentTime = 0;
        [self.backgroundMusicPlayer prepareToPlay];
        self.backgroundMusicPlayer.volume = 1.0;
        
    }
}
-(void)didMoveToView:(SKView *)view {
    self.touchingCarillon = NO;
   
   
    [[SKTAudio sharedInstance]playBackgroundMusic:@"BackgroundMusicScene1.mp3"];
    
    self.gameViewController.exitButton.enabled = YES;
    self.gameViewController.exitButton.hidden = NO;
    [self setupLevel1];
    [self addBottomEdge:self.size];
    
//    SKAction *wait = [SKAction waitForDuration:2];
//    [self runAction:wait completion:^{
//        
//       //[self setupTextLabel2:@"This is Bell. She is still sleeping.\n I think it's time to wake her up." withDuration:8];
//        //[self.carillon runAction:[SKAction playSoundFileNamed:@"NarratorScene1aEdited.mp3" waitForCompletion:YES]];
////        [self.carillon runAction:self.playText];
//    }];
    self.musicOn = YES;
    [self setupToysFrames];
    
     [self drawHintinLocation:self.carillon afterDelay:3];
    
    

}
-(void)setupCharacterHappyAnimation{
    
    SKAction *wiggleTailUp = [SKAction rotateByAngle:M_PI_4/16 duration:0.2];
    SKAction *wiggleTailDown = [SKAction rotateByAngle:-M_PI_4/16 duration:0.2];
    SKAction *wiggling = [SKAction repeatAction:[SKAction sequence:@[wiggleTailUp, wiggleTailDown]] count:7];
    SKAction *wiggleHeadUp = [SKAction rotateByAngle:M_PI_4/16 duration:0.3];
    SKAction *wiggleHeadDown = [SKAction rotateByAngle:-M_PI_4/16 duration:0.3];
    SKAction *wigglingHead = [SKAction repeatAction:[SKAction sequence:@[wiggleHeadDown, wiggleHeadUp]] count:5];
    SKAction *bounceUp = [SKAction moveByX:0 y:20 duration:0.3];
        SKAction *bounceDown = [SKAction moveByX:0 y:-20 duration:0.3];
    SKAction *bouncing = [SKAction repeatAction:[SKAction sequence:@[bounceUp, bounceDown]] count:5];

    [_bellBodyObject.bellsBody runAction:[SKAction group:@[wiggling, bouncing]]];
    [_bellBodyObject.bellsHead runAction:wigglingHead];
    
    
}
-(void)setupStickers{
   // SKNode *stickerOneNode = [SKNode node];
    self.stickerOne = [[Stickers alloc]initStickerWithPosition:CGPointMake(0, 768)andStickerFormsPosition:CGPointMake(130, 50)];
    
   // [stickerOneNode addChild:self.stickerOne];
    [self addChild:self.stickerOne];
}
-(void)addBottomEdge:(CGSize)size{
    
    SKNode *bottomEdge = [SKNode node];
    bottomEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 85) toPoint:CGPointMake(size.width, 85)];
    [self addChild:bottomEdge];
    
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
    self.toysFramesActive = NO;
    self.trainFrame.position = CGPointMake(self.size.width - self.trainFrame.size.width/2, 250);
    self.ballFrame.position = CGPointMake(self.ballFrame.size.width/2, 150);
    self.bearFrame.position = CGPointMake(self.bed.position.x+TOY_OFFSET+50, self.bed.position.y+TOY_OFFSET);
    [self addChild:self.trainFrame];
    [self addChild:self.ballFrame];
    [self addChild:self.bearFrame];
    
}
-(void)setupFooter{
    
    self.footer = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(1024, 70)];
    
    self.footer.fillColor = [SKColor whiteColor];
    
    self.footer.position = CGPointMake(512, 50);
  //  self.footer.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 120) toPoint:CGPointMake(size.width, 120)];
    
    [self addChild:self.footer];
    
    
}
- (void)playBackgroundMusic:(NSString *)filename
{
    
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    self.backgroundMusicPlayer.volume = 1;
    [self.backgroundMusicPlayer prepareToPlay];
}

-(void)setupLevel1{
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
     self.physicsWorld.gravity = CGVectorMake(0, -9.8);
    self.physicsBody.categoryBitMask = LBPhysicsCategoryWorld;
    // self.physicsWorld.contactDelegate = self;
    [self setupBackground];
    
    [self setupCharacter];
    
    [self setupBed];
    [self setupClockHands];
    [self setupLadyBird];
    
   // [self setupFooter];
    [self setupCupBoard];
    [self setupBear];
    
    //[self setupSun];
    
    [self setupSoundIcon];
    [self setupArrow];
    
    
    
    [self setupLokomotywa];
    
    [self setupPilka];
    [self emitterEffect];//liscie!
    //[self setupAnyText];
    [self setupStickers];
    
}
-(void)setupTextLabel:(SKLabelNode *)textNode text:(NSString *)string{
    
    //work on logic here!
   
   
        textNode = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
        textNode.text = string;
        textNode.position = CGPointMake(CGRectGetMidX(self.footer.frame), CGRectGetMidY(self.footer.frame));
        textNode.verticalAlignmentMode = 1;
        textNode.fontColor = [UIColor blackColor];
        textNode.fontSize = 25;
        textNode.alpha = 1;
        textNode.name = @"textChild";
    
    
              //[self removeFromParent];
        [self addChild:textNode];
    
    SKAction *wait = [SKAction waitForDuration:4];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:1];
    SKAction *removeTheNode = [SKAction removeFromParent];

    [textNode runAction:[SKAction sequence:@[wait, fadeOut, removeTheNode]]withKey:@"textAnimation"];
    
    
    
}
-(void)setupCupBoard{
    
    self.cupboard = [SKSpriteNode spriteNodeWithImageNamed:@"cupboard"];
    self.cupboard.position = CGPointMake(self.size.width - self.cupboard.size.width/2 - 80, 280);
    [self addChild:self.cupboard];
    
}
-(void)setupTextLabel2:(NSString *)string withDuration:(CGFloat)duration{
    
    [self.anyTextLabel removeFromParent];
    self.anyTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    self.anyTextLabel.text = string;
    self.anyTextLabel.position = CGPointMake(CGRectGetMidX(self.footer.frame), CGRectGetMidY(self.footer.frame));
    self.anyTextLabel.verticalAlignmentMode = 1;
    self.anyTextLabel.fontColor = [UIColor blackColor];
    self.anyTextLabel.fontSize = 25;
    self.anyTextLabel.alpha = 1;

    [self addChild:self.anyTextLabel];
    
    SKAction *wait = [SKAction waitForDuration:duration];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:1];
    SKAction *removeTheNode = [SKAction removeFromParent];
    
    [self.anyTextLabel runAction:[SKAction sequence:@[wait, fadeOut, removeTheNode]]withKey:@"textAnimation"];

}

    

-(void)emitterEffect{
    self.sheepEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"Sheep" ofType:@"sks"]];
    
    self.sheepEmitter.position = CGPointMake(self.carillon.position.x-60, self.carillon.position.y+60);
    self.sheepEmitter.zPosition = 101;
    [self addChild:self.sheepEmitter];
    
}
-(void)explodeTheTrain{
    
    self.explosionEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"explosion" ofType:@"sks"]];
    
    self.explosionEmitter.position = CGPointMake(self.lokomotywa.position.x-40, self.lokomotywa.position.y+80);
    self.explosionEmitter.zPosition = 200;
    [self addChild:self.explosionEmitter];
    
    
}

-(void)setupSoundIcon{
    self.soundIcon = [SKSpriteNode spriteNodeWithImageNamed:@"glosnik"];
    self.soundIcon.position = CGPointMake(self.soundIcon.size.width+ 50, self.size.height-self.soundIcon.size.height);
    [self addChild:self.soundIcon];
    
}
-(void)setupArrow{
    self.arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrowRight"];
    self.arrow.position = CGPointMake(self.size.width-self.arrow.size.width/2, self.arrow.size.height);
    self.arrow.alpha = 0.5;
    self.arrowActive = NO;
    [self addChild:self.arrow];
    
}
#pragma mark TEXT



#pragma mark TLO

-(void)setupBackground{
    SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"NewBackground"];
    backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    backgroundImage.zPosition = -2;
    
    [self addChild:backgroundImage];
    [self setupFullWindow];
    
    
}
-(void)setupFullWindow{
    self.window = [SKSpriteNode spriteNodeWithImageNamed:@"fullWindowDay"];
    self.window.position = CGPointMake(self.size.width - self.window.size.width/2 -20, self.size.height - self.window.size.height/2 - 10);
//    self.sky = [SKSpriteNode spriteNodeWithImageNamed:@"szklo3edited"];
//    self.sky.zPosition = -1;
//    self.sky.position = CGPointMake(self.size.width - self.window.size.width/2, self.size.height/1.5+8);
//    
//    self.tree = [SKSpriteNode spriteNodeWithImageNamed:@"drzewo2"];
//    self.tree.position = CGPointMake(self.sky.position.x-30, self.sky.position.y);
//    
//    [self addChild:self.tree];
    [self addChild:self.window];
   // [self addChild:self.sky];
}
#pragma mark POSTAC
-(void)setupCharacter{

    self.carillon = [SKSpriteNode spriteNodeWithImageNamed:@"postac lezaca02"];
    self.carillon.position = CGPointMake(285, 280);
    
    self.carillon.zPosition = 100;
    [self addChild:self.carillon];
   
}

-(void)startMainCharacterAnimation{
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:2];
    for (int i = 1; i<3; i++) {
        NSString *textureName = [NSString stringWithFormat:@"postac lezaca0%i.png",i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    SKAction *blink = [SKAction animateWithTextures:textures timePerFrame:1];
   // SKAction *blinkStanding = [SKAction animateWithTextures:texturesStanding timePerFrame:0.2];
    
   // SKAction *wait = [SKAction waitForDuration:duration];
    SKAction *rotate = [SKAction rotateByAngle:-1.57 duration:0.2];
    SKAction *moveDown = [SKAction moveTo:CGPointMake(285, 270) duration:0.5];
    SKAction *mainCharacterAnimation = [SKAction sequence:@[blink, rotate]];
    
   // SKAction *standingCharacterBlinking = [SKAction sequence:@[blinkStanding,wait]];
    
    
    //removing TEXT
    
    SKAction *fadeOutEmitter = [SKAction fadeOutWithDuration:0.5];
    
    
    [self.trail runAction:fadeOutEmitter];
    [self.carillon runAction:mainCharacterAnimation completion:^{
        
        CGPoint location = self.carillon.position;
        
        [self.carillon removeFromParent];
        self.carillon = [SKSpriteNode spriteNodeWithImageNamed:@"postac stojaca01"];
        self.carillon.position = location;
        [self addChild:self.carillon];
        [self.carillon runAction:moveDown];
        [self.trail removeFromParent];
        self.carillonIsStanding = YES;
       // [self.carillon runAction:[SKAction repeatActionForever:standingCharacterBlinking]];
        [self.carillon removeFromParent];
        _bellBodyObject = [[BellBody alloc] initBellWithBodyandHeadInPosition:CGPointMake(location.x-50, location.y - 100)];
        SKNode *bellNode = [SKNode node];
        
        [bellNode addChild:_bellBodyObject];
        [self addChild:bellNode];

    }];
    
    
}

#pragma mark ZEGAR
-(void)setupClockHands{
   

    self.clock = [SKSpriteNode spriteNodeWithImageNamed:@"clock"];
    self.clock.position = CGPointMake(275, 570);
    [self addChild:self.clock];
    
    self.clockHand1 = [SKSpriteNode spriteNodeWithImageNamed:@"wskazowka"];
    self.clockHand1.position = CGPointMake(273, 565);

    self.clockHand1.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:self.clockHand1];
    self.clockHand2 = [SKSpriteNode spriteNodeWithImageNamed:@"wskazowka2"];
    self.clockHand2.position = CGPointMake(273, 565);
    self.clockHand2.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:self.clockHand2];
    
    
}

-(void)rotateTheClockHands{
    SKAction *rotation = [SKAction rotateByAngle:-M_PI duration:2];
    SKAction *rotation1 = [SKAction rotateByAngle:-M_PI duration:3];
    self.clockCounter++;
    [self.clockHand2 runAction:rotation completion:^{
        
        self.clockHandsActive1 = NO;
    }];
    
    [self.clockHand1 runAction:rotation1 completion:^{
        
        self.clockHandsActive2 = NO;
    }];
    
    
}
#pragma mark BIEDRONKA

-(void)setupLadyBird{
    
    self.biedrona = [SKSpriteNode spriteNodeWithImageNamed:@"biedrona3.png"];
    //   self.biedrona.position = CGPointMake(700, 400);
    self.biedrona.position = CGPointMake(self.size.width - self.biedrona.size.width, self.size.height/2-35);
   

    [self addChild:self.biedrona];
}
-(void)drawArrowHint:(SKSpriteNode *)node{
    
    
    SKAction *alphaUp = [SKAction fadeAlphaTo:1.0 duration:1.2];
    SKAction *alphaDown = [SKAction fadeAlphaTo:0.5 duration:1.2];
    SKAction *blinkSeq = [SKAction sequence:@[alphaDown, alphaUp]];

    SKSpriteNode *hintBubble = [SKSpriteNode spriteNodeWithImageNamed:@"strzalka"];
    hintBubble.anchorPoint = CGPointMake(0, 1);
    
    hintBubble.position = CGPointMake(node.position.x, node.position.y + node.size.height/2);
    hintBubble.zRotation = M_PI_4/8;
      [self addChild:hintBubble];
        SKAction *slantMoveForwards = [SKAction moveByX:0 y:+20 duration:1.2];
        SKAction *slantMoveBackwards = [SKAction moveByX:0 y:-20 duration:1.2];
        SKAction *slantMovementSeq = [SKAction sequence:@[slantMoveForwards, slantMoveBackwards]];
        [hintBubble runAction:[SKAction repeatAction:[SKAction group:@[blinkSeq, slantMovementSeq]]count:4]completion:^{
    
            [hintBubble removeFromParent];
        }];

}
-(void)removeActionWithAlpha:(SKSpriteNode *)node{
    
    [node removeActionForKey:@"hintAction"];
    node.alpha = 1;
   // SKAction *removeAction = [SKAction colo]
    
}
-(void)setupHintsparkEmitterEffectinLocation:(CGPoint)location{
    
    self.hintSpark = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"HintSpark" ofType: @"sks"]];
    self.hintSpark.position = CGPointMake(location.x,location.y);
    self.hintSpark.zPosition = 400;
    [self addChild:self.hintSpark];
    
    
    
}

-(void)drawHintinLocation:(SKSpriteNode *)node afterDelay:(CGFloat)duration{
    
    /* emitter hintEffect
    SKAction *wait = [SKAction waitForDuration:duration];
    SKAction *hintSparkBlock = [SKAction runBlock:^{
        
        [self setupHintsparkEmitterEffectinLocation:node.position];
    }];
        SKAction *hintSeq = [SKAction sequence:@[wait, [SKAction repeatAction:hintSparkBlock count:1]]];
        [self runAction:wait completion:^{
            [node runAction:[SKAction repeatActionForever:hintSeq] withKey:@"hintAction"];
            ;
        }];
     */
    SKAction *alphaUp = [SKAction fadeAlphaTo:1.0 duration:0.2];
    SKAction *alphaDown = [SKAction fadeAlphaTo:0.2 duration:0.2];
    SKAction *blinkSeq = [SKAction sequence:@[alphaDown, alphaUp]];
    
  //  SKAction *colorize = [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:0.4 duration:0.5];
  //  SKAction *groupBlinkingAndColorizing = [SKAction group:@[blinkSeq, colorize]];
    
    SKAction *wait = [SKAction waitForDuration:duration];
    SKAction *hintSeq = [SKAction sequence:@[wait, [SKAction repeatAction:blinkSeq count:2]]];
    [self runAction:wait completion:^{
        [node runAction:[SKAction repeatActionForever:hintSeq] withKey:@"hintAction"];
        ;
    }];
    

    
//    SKSpriteNode *hintBubble = [SKSpriteNode spriteNodeWithImageNamed:@"strzalka"];
//    hintBubble.anchorPoint = CGPointMake(0, 1);
//
//    hintBubble.position = CGPointMake(node.position.x, node.position.y + node.size.height/2);
//    hintBubble.zRotation = M_PI_4/8;
//    [self addChild:hintBubble];
//        SKAction *slantMoveForwards = [SKAction moveByX:0 y:+20 duration:1.2];
//    SKAction *slantMoveBackwards = [SKAction moveByX:0 y:-20 duration:1.2];
//    SKAction *slantMovementSeq = [SKAction sequence:@[slantMoveForwards, slantMoveBackwards]];
//    [hintBubble runAction:[SKAction repeatAction:[SKAction group:@[blinkSeq, slantMovementSeq]]count:4]completion:^{
//        
//        [hintBubble removeFromParent];
//    }];
//    
}
#pragma mark ZABAWKI
#pragma mark MISIO
-(void)setupBear{
    self.bearStatusActive = YES;
    self.misiu = [SKSpriteNode spriteNodeWithImageNamed:@"bear"];
    self.misiu.zPosition = 300;
    self.misiu.position = CGPointMake(550, 150);
    //self.misiu.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: self.misiu.frame.size];
    self.misiu.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.misiu.frame.size.width/3];
    self.misiu.physicsBody.categoryBitMask = LBPhysicsCategoryBear;
    self.misiu.physicsBody.collisionBitMask = LBPhysicsCategoryWorld;
    self.misiu.physicsBody.restitution = 0.5;
    //self.touchingCarillon = YES;
    
    [self addChild:self.misiu];
    
}
-(void)setupBed{
    
    self.bed = [SKSpriteNode spriteNodeWithImageNamed:@"bed"];
    self.bed.position = CGPointMake(285, 200);
    self.bed.zPosition = -1;
    [self addChild:self.bed];
    
}
#pragma mark PILKA

-(void)setupPilka{
    self.ballStatusActive = YES;
    self.pilka = [SKSpriteNode spriteNodeWithImageNamed:@"ballCorrect"];
    self.pilka.name = @"ball";
    self.pilka.position = CGPointMake(self.size.width - 70, 160);
    self.pilka.zPosition = 300;
    self.pilka.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.pilka.frame.size.width/2];
   
    self.pilka.physicsBody.restitution = 0.5;
    self.pilka.physicsBody.density = 0.4;
    self.pilka.physicsBody.categoryBitMask = LBPhysicsCategoryBall;
    self.pilka.physicsBody.collisionBitMask = LBPhysicsCategoryWorld;
   // self.pilka.physicsBody.dynamic = NO;
   
    [self addChild:self.pilka];
    
}
#pragma mark LOKOMOTYWA

-(void)setupLokomotywa{
    self.lokomotywa = [SKSpriteNode spriteNodeWithImageNamed:@"train"];
    self.lokomotywa.position = CGPointMake(740, 150);
    self.lokomotywa.zPosition = 300; //same like the bear
    self.lokomotywa.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.lokomotywa.frame.size];
    self.lokomotywa.physicsBody.categoryBitMask = LBPhysicsCategoryTrain;
    self.lokomotywa.physicsBody.collisionBitMask = LBPhysicsCategoryWorld;
    self.lokomotywa.physicsBody.restitution = 0.5;
    self.trainStatusActive = YES;
    [self addChild:self.lokomotywa];
}

- (void)showSoundButtonForTogglePosition:(BOOL)togglePosition
{
    if (togglePosition)
    {
        self.soundIcon.texture = [SKTexture textureWithImageNamed:@"glosnik2"];
        self.musicOn = NO;
         [[SKTAudio sharedInstance] pauseBackgroundMusic];
    }
    else
    {
        self.soundIcon.texture = [SKTexture textureWithImageNamed:@"glosnik"];
        self.musicOn = YES;
         [[SKTAudio sharedInstance]playBackgroundMusic:@"BackgroundMusicScene1.mp3"];


    }
}
-(void)setToysAlpha{
    SKAction *alphaUp = [SKAction fadeAlphaTo:1.0 duration:2];
    [self enumerateChildNodesWithName:@"toys" usingBlock:^(SKNode *node, BOOL *stop) {
        
        [node runAction:alphaUp];
        self.toysFramesActive = YES;
        [self runAction:[SKAction playSoundFileNamed:@"SFXkontury.mp3" waitForCompletion:NO]];
    }];
    [self randomFrameHints];
    
    
}

-(void)randomFrameHints{
    SKAction *alphaUp = [SKAction fadeAlphaTo:1.0 duration:0.2];
    SKAction *alphaDown = [SKAction fadeAlphaTo:0.2 duration:0.2];
    SKAction *blinkSeq = [SKAction sequence:@[alphaDown, alphaUp]];
    
    SKAction *wait = [SKAction waitForDuration:2];
    SKAction *hintSeq = [SKAction sequence:@[wait, [SKAction repeatAction:blinkSeq count:2]]];
    CGFloat randomNumber = ScalarRandomRange(1, 3);
    NSInteger randomNInt = (int)randomNumber;
    
    if (self.toysFramesActive) {
        [self runAction:wait completion:^{
            switch (randomNInt){
                case 1:
                {
                    if (self.bearStatusActive) {
                        [self.misiu runAction:[SKAction repeatAction:hintSeq count:2]];
                        [self.bearFrame runAction:[SKAction repeatAction:hintSeq count:2]completion:^{
                            
                            [self runAction:wait completion:^{
                                
                                 [self randomFrameHints];
                            }];
                           
                        }];
                    }
                   
                }
                    break;
                case 2:
                {
                    if (self.trainStatusActive){
                    [self.lokomotywa runAction:[SKAction repeatAction:hintSeq count:2]];
                    [self.trainFrame runAction:[SKAction repeatAction:hintSeq count:2]completion:^{
                        
                        [self runAction:wait completion:^{
                            
                            [self randomFrameHints];
                            
                        }];

                        
                        
                    }];
                    }
                }
                    break;
                case 3:
                {
                    if (self.ballStatusActive) {
                        [self.pilka runAction:[SKAction repeatAction:hintSeq count:2]];
                        [self.ballFrame runAction:[SKAction repeatAction:hintSeq count:2]completion:^{
                            [self runAction:wait completion:^{
                            [self randomFrameHints];
                                
                            }];
                        }];
                    }
                    
                }
                    break;
                    
                default:
                    break;
    
            }}];
 
    }
    
}

-(void)bellRandomNoises{
    
    switch (arc4random()%3+1) {
        case 1:
        {
            [[SKTAudio sharedInstance]playSoundEffect:@"SFXBellHi.mp3"];
            SKAction *wiggleHeadUp = [SKAction rotateByAngle:M_PI_4/8 duration:0.2];
            SKAction *wiggleHeadDown = [SKAction rotateByAngle:-M_PI_4/8 duration:0.2];
            SKAction *wigglingHead = [SKAction repeatAction:[SKAction sequence:@[wiggleHeadDown, wiggleHeadUp]] count:5];
            
            [_bellBodyObject.bellsHead runAction:[SKAction group:@[wigglingHead]]];
        }
            break;
        case 2:{
            [[SKTAudio sharedInstance]playSoundEffect:@"SFXBellMm.mp3"];
            SKAction *wiggleHeadUp = [SKAction rotateByAngle:M_PI_4/8 duration:0.2];
            SKAction *wiggleHeadDown = [SKAction rotateByAngle:-M_PI_4/8 duration:0.2];
            SKAction *wigglingHead = [SKAction repeatAction:[SKAction sequence:@[wiggleHeadDown, wiggleHeadUp]] count:5];
            
            [_bellBodyObject.bellsHead runAction:[SKAction group:@[wigglingHead]]];
        }
            break;
        case 3:{
            [[SKTAudio sharedInstance]playSoundEffect:@"SFXOoBell.mp3"];
            SKAction *wiggleHeadUp = [SKAction rotateByAngle:M_PI_4/8 duration:0.2];
            SKAction *wiggleHeadDown = [SKAction rotateByAngle:-M_PI_4/8 duration:0.2];
            SKAction *wigglingHead = [SKAction repeatAction:[SKAction sequence:@[wiggleHeadDown, wiggleHeadUp]] count:5];
            
            [_bellBodyObject.bellsHead runAction:[SKAction group:@[wigglingHead]]];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark TOUCH


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches){
        
        CGPoint location = [touch locationInNode:self];
        [_bellBodyObject moveHeadTowards:location];
        
        self.littleSparkEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"LittleSpark" ofType:@"sks"]];
        self.littleSparkEmitter.zPosition = 100;
        self.littleSparkEmitter.position = location;
        
        [self addChild:self.littleSparkEmitter];
        
        if   ([self.soundIcon containsPoint:location]){
            
            [self showSoundButtonForTogglePosition:self.musicOn];
        }
        
        
           
        if (self.touchingCarillon && [self.clock containsPoint:location] && !self.clockHandsActive1 && !self.clockHandsActive2) {
            self.clockHandsActive1 = YES;
            self.clockHandsActive2 = YES;
            
            if (self.clockCounter >1) {
               [self removeActionWithAlpha:self.clock];
            }
            if (self.clockCounter < 2) {
            [self drawHintinLocation:self.biedrona afterDelay:3];

            }
            
                [self.clockHand1 runAction:[SKAction playSoundFileNamed:@"ClockSFX.mp3" waitForCompletion:NO]];
            [self rotateTheClockHands];
           
           
            
        }
    
    


        if ([self.lokomotywa containsPoint:location] && self.touchingCarillon && self.toysFramesActive == NO){
            
            [self.lokomotywa runAction:[SKAction playSoundFileNamed:@"Pociag SFX.mp3" waitForCompletion:NO]];
            [self explodeTheTrain];
            [self removeActionWithAlpha:self.lokomotywa];

            
            [self drawHintinLocation:self.misiu afterDelay:3];
            
            
        }else
            if([self.lokomotywa containsPoint:location] && self.touchingCarillon && self.toysFramesActive == YES && self.trainStatusActive == YES){
            self.touchingTrain = YES;
            self.touchingPoint = location;
            
            self.lokomotywa.physicsBody.velocity = CGVectorMake(0, 0);
            self.lokomotywa.physicsBody.angularVelocity = 0;
            self.lokomotywa.physicsBody.affectedByGravity = NO;
        }
        
        
        if ([self.pilka containsPoint:location] && self.touchingCarillon && self.toysFramesActive == NO) {
            [self useBall];
            [self removeActionWithAlpha:self.pilka];
            [self drawHintinLocation:self.clock afterDelay:3];

            
        }else if ([self.pilka containsPoint:location] && self.touchingCarillon && self.toysFramesActive == YES && self.ballStatusActive == YES){
            [self.pilka removeAllActions];
            self.touchingBall = YES;
            self.touchingPoint = location;
            
            self.pilka.physicsBody.velocity = CGVectorMake(0, 0);
            self.pilka.physicsBody.angularVelocity = 0;
            self.pilka.physicsBody.affectedByGravity = NO;
        }

        
        
        
        if ([self.arrow containsPoint:location] && self.arrowActive) {
            
            SKView * skView = (SKView *)self.view;
            skView.showsFPS = NO;
            skView.showsNodeCount = NO;
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = YES;
            skView.showsPhysics = NO;
                
            // Create and configure the scene.
            GameScene2 *gameScene2 = [[GameScene2 alloc]initWithSize:self.size];
            gameScene2.scaleMode = SKSceneScaleModeAspectFill;
            [[SKTAudio sharedInstance]pauseBackgroundMusic];

            
            SKTransition *transition = [SKTransition fadeWithColor:[UIColor blackColor] duration:3];
            // Present the scene.
            [self.view presentScene:gameScene2 transition:transition];
            
            
            
        }
        
        
        
        if ([self.carillon containsPoint:location]) {
            if (self.touchingCarillon == NO) {
                //animacja postaci
                
                [self.carillon runAction:[SKAction playSoundFileNamed:@"SFXBellObudzenie.mp3" waitForCompletion:NO]];
                [self.sheepEmitter removeFromParent];
                [self startMainCharacterAnimation];
                
                
                self.wait = [SKAction waitForDuration:3];
                self.touchingCarillon = YES;
                
                [self removeActionWithAlpha:self.carillon];
                [self drawHintinLocation:self.lokomotywa afterDelay:3];

                
                
            }
            
            [self bellRandomNoises];
            
            
            
        }
        
        if([self.misiu containsPoint:location] && self.touchingCarillon && self.bearStatusActive){
            [self.misiu runAction:[SKAction playSoundFileNamed:@"bear.mp3" waitForCompletion:NO]];
            self.touchingBear = YES;
            self.touchingPoint = location;
            [self removeActionWithAlpha:self.misiu];
            [self drawHintinLocation:self.pilka afterDelay:3];
            self.misiu.physicsBody.velocity = CGVectorMake(0, 0);
            self.misiu.physicsBody.angularVelocity = 0;
            
            self.misiu.physicsBody.affectedByGravity = NO;
            
            
            
        }
        
        if([self.biedrona containsPoint:location] && (self.touchingCarillon == YES) && !self.touchingLadyBird){
            [self.biedrona runAction:[SKAction playSoundFileNamed:@"SFX Scena1 Biedronka.mp3" waitForCompletion:NO]];
            [self removeActionWithAlpha:self.biedrona];
            self.touchingLadyBird = YES;
            CGPoint biedronkowaPozycja = self.biedrona.position;
            
            SKAction *walkingLadyBirdLeft = [SKAction moveToX:600 duration:4];
            SKAction *walkingLadyBirdRight = [SKAction moveToX:biedronkowaPozycja.x duration:4];

            
            [self.biedrona runAction:walkingLadyBirdLeft completion:^{
                [self.biedrona setTexture:[SKTexture textureWithImageNamed:@"biedrona red2.png"]];
                
                
                [self.biedrona runAction:walkingLadyBirdRight completion:^{
                    [self.biedrona setTexture:[SKTexture textureWithImageNamed:@"biedrona red.png"]];
                    
                                      self.touchingLadyBird = NO;
                        }];
                
                }];
                
              
            
        }
    }
}

-(void)useBall{
    
    
    [self enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode *node, BOOL *stop) {
        
        [node runAction:[SKAction playSoundFileNamed:@"BallSFX.mp3" waitForCompletion:NO]];

        
        [node.physicsBody applyImpulse:CGVectorMake(0, 60)];
    }];
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touchingPoint = [[touches anyObject] locationInNode:self];
    
}
-(BOOL)isBelowTheFooter:(SKShapeNode *)footer inPosition:(CGPoint)currentLocation{
    if (currentLocation.y <= footer.position.y){
        return YES;
    }else
        return NO;
}

-(BOOL)isWithinToyFrame:(SKSpriteNode *)toyFrame inPosition:(CGPoint)currentLocation{
    if (currentLocation.x >= toyFrame.position.x - BODY_OFFSET && currentLocation.x <= toyFrame.position.x + BODY_OFFSET && currentLocation.y >= toyFrame.position.y - BODY_OFFSET && currentLocation.y <= toyFrame.position.y + BODY_OFFSET){
        [[SKTAudio sharedInstance]playSoundEffect:@"SFX Scena1 zabawka w formie.mp3"];
        return YES;
    }else
        return NO;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
     [self.explosionEmitter removeFromParent];

    if (self.touchingTrain && self.touchingCarillon && self.toysFramesActive == YES) {
        CGPoint currentPoint = [[touches anyObject] locationInNode:self];
        CGPoint trainFramePos = self.trainFrame.position;
        
        
        if ( [self isWithinToyFrame:self.trainFrame inPosition:currentPoint] )
        {
            self.touchingTrain = NO;
            self.lokomotywa.position = trainFramePos;
            self.trainStatusActive = NO;
            [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarOne];
            [self setupCharacterHappyAnimation];
            
    }else{
        self.touchingTrain = NO;
        self.lokomotywa.physicsBody.affectedByGravity = YES;
       
        
     }
 }
        if (self.touchingBall && self.touchingCarillon && self.toysFramesActive == YES) {
            CGPoint currentPoint = [[touches anyObject] locationInNode:self];
            CGPoint ballFramePos = self.ballFrame.position;
            
            
            if ( [self isWithinToyFrame:self.ballFrame inPosition:currentPoint] )
            {
                self.touchingBall = NO;
                self.pilka.position = ballFramePos;
                self.ballStatusActive = NO;
                 [self.pilka removeActionForKey:@"hintAction"];
                [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarTwo];
                [self setupCharacterHappyAnimation];
            }else{
                self.touchingBall = NO;
                self.pilka.physicsBody.affectedByGravity = YES;
 
            }
    
        }
    if (self.touchingBear && self.touchingCarillon && self.toysFramesActive == YES && self.bearStatusActive == YES) {
        CGPoint currentPoint = [[touches anyObject] locationInNode:self];
        CGPoint bearFramePos = self.bearFrame.position;
        
        
        if ( [self isWithinToyFrame:self.bearFrame inPosition:currentPoint] )
        {
            self.touchingBear = NO;
            self.misiu.position = bearFramePos;
            self.bearStatusActive = NO;
            [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarThree];
            
        }else{
            
            self.touchingBear = NO;
            self.misiu.physicsBody.affectedByGravity = YES;
            
            if ([self isBelowTheFooter:self.footer inPosition:currentPoint]) {
                self.misiu.position = CGPointMake(currentPoint.x, self.misiu.position.y);
                
            }
            
        }
        
    }else if(self.bearStatusActive == YES){
        self.touchingBear = NO;
        self.misiu.physicsBody.affectedByGravity = YES;
    }
    
    
}


    ////CHARACTER WALKING ANIMATION/////
//    if (self.carillonIsStanding) {
//        [self walkingCarillon:endLocation];
//
//    }
    

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    self.touchingBear = NO;
    self.misiu.physicsBody.affectedByGravity = YES;
    self.touchingBall = NO;
    self.pilka.physicsBody.affectedByGravity = YES;
    [self.explosionEmitter removeFromParent];
    self.touchingTrain = NO;
    self.lokomotywa.physicsBody.affectedByGravity = YES;
}

-(void)update:(CFTimeInterval)currentTime {
    
    if (self.touchingBear) {
        self.misiu.position = self.touchingPoint;
    }
    if (self.touchingTrain) {
        self.lokomotywa.position = self.touchingPoint;
    }
    
    if (self.touchingBall) {
        self.pilka.position = self.touchingPoint;
    }
    if (self.clockCounter == 2) {
        if (self.toysFramesActive == NO) {
            [self setToysAlpha];
            [self setupCharacterHappyAnimation];
   
        }
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
@end
