//
//  GameScene2.m
//  gierka
//
//  Created by Marek Tomaszewski on 20/11/2014.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "GameScene2.h"
#import "GameScene3.h"
#import "Stickers.h"
#import "BellBody.h"
#import "SKTAudio.h"

@interface GameScene2 ()

@property SKSpriteNode *bathTub;
@property SKSpriteNode *curtain;
@property SKSpriteNode *sink;
@property SKSpriteNode *toothPaste;
@property SKSpriteNode *mug;
@property SKSpriteNode *mirror;
@property SKSpriteNode *carillon;
@property SKSpriteNode *shower;
@property SKSpriteNode *rope;
@property SKSpriteNode *lightSwitch;
@property SKSpriteNode *backgroundImage;
@property SKSpriteNode *preBackgroundImage;
@property SKSpriteNode *soundIcon;
@property SKSpriteNode *arrow;
@property SKSpriteNode *drops;
@property SKSpriteNode *duck;
@property SKSpriteNode *duckTwo;

@property (assign) int duckCounter;

@property SKSpriteNode *bubble1;
@property SKSpriteNode *bubble2;
@property SKSpriteNode *bubble3;
@property SKSpriteNode *bubble4;
@property SKSpriteNode *bubble5;
@property SKSpriteNode *bubble6;
@property SKSpriteNode *bubble7;
@property SKSpriteNode *bubble8;
@property BOOL bubblesActive;

@property SKShapeNode *footer;
@property SKAction *moveUp;
@property SKAction *bubbleSound;
@property NSArray *characterWalkingFrames;
@property SKSpriteNode *tap;
@property SKPhysicsJointPin *pinJoint;
@property SKPhysicsJointPin *pinJointTwo;

@property SKEmitterNode *showerDrops;
@property SKEmitterNode *bubbles;
@property SKEmitterNode *oneBubble;
@property SKEmitterNode *secondBubble;
@property SKEmitterNode *thirdBubble;
@property SKEmitterNode *fourthBubble;
@property SKEmitterNode *fifthBubble;
@property SKEmitterNode *littleSparkEmitter;
@property SKEmitterNode *cutEffect;
@property SKEmitterNode *bigSparkEmitter;
@property SKEmitterNode *duckExplosionEmitter;
@property SKSpriteNode *spiderRope;
@property SKSpriteNode *spiderRopeTwo;

#pragma mark BOOLs

@property BOOL lightSwitchStatus;
@property BOOL touchingShower;
@property BOOL touchingCurtain;
@property BOOL musicOn;
@property BOOL touchingToothPaste;
@property BOOL touchingMug;
@property BOOL toothPasteActive;
@property BOOL mugActive;
@property BOOL bubbleStickerActive;
@property BOOL teethToolsActive;
@property BOOL arrowActive;
@property BOOL duckActive;
@property BOOL bathtoolsTouchesActive;

@property (assign) int teethToolsCounter;

@property CGPoint touchingPoint;
@property CGPoint originalPosition;

@property CGPoint lightSwitchYOriginalPosition;
@property CGPoint lightTouchingPoint;
@property CGPoint touchStartPoint;
@property CGPoint touchEndPoint;
@property CGFloat bubblesCounter;
@property CGFloat bubbleRestitution;

@property Stickers *stickerOne;
@property SKNode *stickerOneNode;
@property BellBody *bellBodyObject;
@property SKNode *bellNode;
@property NSArray *showerDropsFrames;

@end

static const int BODY_OFFSET = 100;

typedef NS_OPTIONS(uint32_t, LBPhysicsCategory) {
    LBPhysicsCategoryDuckOne = 1 << 0, // 0001 = 1
    LBPhysicsCategoryDuckTwo = 1 << 1, // 0010 = 2
    LBPhysicsCategoryWorld = 1 << 2, //0100 = 4
};
#define ARC4RANDOM_MAX 0x100000000
static inline CGFloat ScalarRandomRange(CGFloat min,
                                        CGFloat max)
{
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}

@implementation GameScene2


-(void)didMoveToView:(SKView *)view {
    // [self setupLevel2];
    self.bubblesActive = YES;
    self.lightSwitchStatus = NO;
    // self.touchingCurtain = NO;
    [self preSetup];
    self.bubbleRestitution = 0.2;
}


-(void)preSetup{
    
    
    
    
    self.lightSwitchYOriginalPosition = CGPointMake(7.25, 578);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = LBPhysicsCategoryWorld;
    //  self.physicsWorld.gravity = CGVectorMake(0, 0.5);
    self.physicsWorld.gravity = CGVectorMake(0, -5.8);
    
    self.preBackgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"tlo 2048 lazienka swiatlo zgaszone"];
    self.preBackgroundImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    
    
    [self setupLightSwitch];
    [self addChild:self.preBackgroundImage];
    
    
}

-(void)setupFooter{
    
    self.footer = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(1024, 70)];
    
    // self.footer.fillColor = [SKColor whiteColor];
    
    self.footer.position = CGPointMake(512, 50);
    //  self.footer.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 120) toPoint:CGPointMake(size.width, 120)];
    
    [self addChild:self.footer];
    
    
}

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
-(void)setupLevel2{
    
    
    
    [self.preBackgroundImage removeFromParent];
    [self setupCharacter];
    //    [self playBackgroundMusic:@"BathroomWaterMusic.mp3"];
    //    [self.backgroundMusicPlayer play];
    [[SKTAudio sharedInstance]playBackgroundMusic:@"BathroomWaterMusic.mp3"];
    self.bubbleSound = [SKAction playSoundFileNamed:@"Bell Bubbles SFX.mp3" waitForCompletion:NO];
    self.musicOn = YES;
    
    [self setupBackground];
    [self setupBathTubWithShower];
    
    //[self setupLightSwitch];
    [self setupFullSink];
    [self setupMirror];
    
    // [self setupFooter];
    [self setupSoundIcon];
    [self setupArrow];
    
    self.stickerOneNode = [SKNode node];
    self.stickerOne = [[Stickers alloc]initStickerWithPosition:CGPointMake(0, 768)andStickerFormsPosition:CGPointMake(130, 50)];
    
    [self.stickerOneNode addChild:self.stickerOne];
    [self addChild:self.stickerOneNode];
    
    [self drawHintinLocation:self.curtain afterDelay:2];
    //start with curtain then shower and mug and paste! not bubles and duck as its too obvious
}
-(void)setupSoundIcon{
    self.soundIcon = [SKSpriteNode spriteNodeWithImageNamed:@"glosnik"];
    self.soundIcon.position = CGPointMake(self.soundIcon.size.width+50, self.size.height-self.soundIcon.size.height);
    [self addChild:self.soundIcon];
    
}
-(void)setupArrow{
    self.arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrowRight"];
    self.arrow.position = CGPointMake(self.size.width-self.arrow.size.width/2, self.arrow.size.height);
    self.arrow.alpha = 0.5;
    self.arrowActive = NO;
    [self addChild:self.arrow];
    
}
-(void)setupBubble1{
    
    self.bubble1 = [SKSpriteNode spriteNodeWithImageNamed:@"bankaSmallEdited"];
    self.bubble1.position = CGPointMake(700 - arc4random()%10, self.size.height/2);
    self.bubble1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bubble1.size.width/2];
    self.bubble1.physicsBody.restitution = self.bubbleRestitution;
    self.bubble1.physicsBody.friction = 0;
    self.bubble1.physicsBody.density = 10.0;
    self.bubble1.name = @"bubble";
    
    
    
    SKAction *rotate = [SKAction rotateByAngle:M_PI_4 duration:3];
    [self addChild:self.bubble1];
    [self.bubble1 runAction:rotate];
    
}
-(void)setupBubble2{
    self.bubble2 = [SKSpriteNode spriteNodeWithImageNamed:@"bankaEdited"];
    self.bubble2.position = CGPointMake(600 - arc4random()%50, self.size.height/2);
    self.bubble2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bubble1.size.width/2];
    self.bubble2.physicsBody.restitution = self.bubbleRestitution;
    self.bubble2.physicsBody.friction = 0;
    self.bubble2.physicsBody.density = 10.0;
    self.bubble2.name = @"bubble";
    
    SKAction *rotate = [SKAction rotateByAngle:-M_PI duration:3];
    [self addChild:self.bubble2];
    [self.bubble2 runAction:rotate];
}
-(void)setupBubble3{
    self.bubble3 = [SKSpriteNode spriteNodeWithImageNamed:@"bankaEdited"];
    self.bubble3.position = CGPointMake(600 - arc4random()%50, self.size.height/2);
    self.bubble3.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bubble3.size.width/2];
    self.bubble3.physicsBody.restitution = self.bubbleRestitution;
    self.bubble3.physicsBody.friction = 0;
    self.bubble3.physicsBody.density = 10.0;
    self.bubble3.name = @"bubble";
    
    SKAction *rotate = [SKAction rotateByAngle:-M_PI duration:3];
    [self addChild:self.bubble3];
    [self.bubble3 runAction:rotate];
}
-(void)setupBubble4{
    
    self.bubble4 = [SKSpriteNode spriteNodeWithImageNamed:@"bankaSmallEdited"];
    self.bubble4.position = CGPointMake(600 - arc4random()%50, self.size.height/2);
    self.bubble4.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bubble4.size.width/2];
    self.bubble4.physicsBody.restitution = self.bubbleRestitution;
    self.bubble4.physicsBody.friction = 0;
    self.bubble4.physicsBody.density = 10.0;
    self.bubble4.name = @"bubble";
    
    SKAction *rotate = [SKAction rotateByAngle:-M_PI duration:3];
    [self addChild:self.bubble4];
    [self.bubble4 runAction:rotate];
}
-(void)setupBubble5{
    self.bubble5 = [SKSpriteNode spriteNodeWithImageNamed:@"bankaSmallEdited"];
    self.bubble5.position = CGPointMake(600 - arc4random()%50, self.size.height/2);
    self.bubble5.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bubble5.size.width/2];
    self.bubble5.physicsBody.restitution = self.bubbleRestitution;
    self.bubble5.physicsBody.friction = 0;
    self.bubble5.physicsBody.density = 10.0;
    self.bubble5.name = @"bubble";
    
    SKAction *rotate = [SKAction rotateByAngle:M_PI_2 duration:3];
    [self addChild:self.bubble5];
    [self.bubble5 runAction:rotate];
}

-(void)setupBubble6{
    self.bubble6 = [SKSpriteNode spriteNodeWithImageNamed:@"bankaEdited"];
    self.bubble6.position = CGPointMake(600 - arc4random()%50, self.size.height/2);
    self.bubble6.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bubble6.size.width/2];
    self.bubble6.physicsBody.restitution = self.bubbleRestitution;
    self.bubble6.physicsBody.friction = 0;
    self.bubble6.physicsBody.density = 10.0;
    self.bubble6.name = @"bubble";
    
    SKAction *rotate = [SKAction rotateByAngle:-M_PI_4 duration:3];
    [self addChild:self.bubble6];
    [self.bubble6 runAction:rotate];
    
}

-(void)setupBubble7{
    self.bubble7 = [SKSpriteNode spriteNodeWithImageNamed:@"bankaTinyEdited"];
    self.bubble7.position = CGPointMake(800 - arc4random()%50, self.size.height/2);
    self.bubble7.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bubble7.size.width/2];
    self.bubble7.physicsBody.restitution = self.bubbleRestitution;
    self.bubble7.physicsBody.friction = 0;
    self.bubble7.physicsBody.density = 10.0;
    self.bubble7.name = @"bubble";
    
    SKAction *rotate = [SKAction rotateByAngle:M_PI duration:3];
    [self addChild:self.bubble7];
    [self.bubble7 runAction:rotate];
}

-(void)setupBubble8{
    self.bubble8 = [SKSpriteNode spriteNodeWithImageNamed:@"bankaTinyEdited"];
    self.bubble8.position = CGPointMake(800 - arc4random()%50, self.size.height/2);
    self.bubble8.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bubble8.size.width/2];
    self.bubble8.physicsBody.restitution = self.bubbleRestitution;
    self.bubble8.physicsBody.friction = 0;
    self.bubble8.physicsBody.density = 10.0;
    self.bubble8.name = @"bubble";
    
    SKAction *rotate = [SKAction rotateByAngle:-M_PI duration:3];
    [self addChild:self.bubble8];
    [self.bubble8 runAction:rotate];
}
/*
 -(void)createBubbles{
 
 [self runAction: [SKAction repeatAction:[SKAction sequence:@[[SKAction performSelector:@selector(setupBubblesSprites)onTarget:self],[SKAction waitForDuration:3]
 ]]count:10]];
 }
 */
- (void)playBackgroundMusic:(NSString *)filename
{
    
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    self.backgroundMusicPlayer.volume = 1;
    [self.backgroundMusicPlayer prepareToPlay];
}

-(void)setupCharacter{
    
    
  //  _bellBodyObject = [[BellBody alloc]initBellWithBodyandHeadInPosition:CGPointMake(self.sink.size.width/2 +240, self.size.height/3 - 70)];
    _bellBodyObject = [[BellBody alloc]initBellWithBodyandHeadInPosition:CGPointMake(400, self.size.height/3 - 70)];
    
    self.bellNode = [SKNode node];
    
    [self.bellNode addChild:_bellBodyObject];
    self.bellNode.zPosition = 0;
    [self addChild:self.bellNode];
    
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

#pragma mark TLO
-(void)setupBackground{
    self.duckCounter = 0;
    SKAction *fadeInTheBackground = [SKAction fadeAlphaTo:1 duration:1];
    
    self.backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"lazienka tlo"];
    self.backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.backgroundImage.zPosition = -2;
    self.backgroundImage.alpha = 0;
    [self addChild:self.backgroundImage];
    
    [self.backgroundImage runAction:fadeInTheBackground];
    self.lightSwitchStatus = NO;
    
}
-(void)drawHintinLocation:(SKSpriteNode *)node afterDelay:(CGFloat)duration{
    SKAction *alphaUp = [SKAction fadeAlphaTo:1.0 duration:0.2];
    SKAction *alphaDown = [SKAction fadeAlphaTo:0.2 duration:0.2];
    SKAction *blinkSeq = [SKAction sequence:@[alphaDown, alphaUp]];
    
    SKAction *wait = [SKAction waitForDuration:duration];
    SKAction *hintSeq = [SKAction sequence:@[wait, [SKAction repeatAction:blinkSeq count:2]]];
    [self runAction:wait completion:^{
        [node runAction:[SKAction repeatActionForever:hintSeq] withKey:@"hintAction"];
        
    }];
}
-(void)removeActionWithAlpha:(SKSpriteNode *)node{
    
    [node removeActionForKey:@"hintAction"];
    node.alpha = 1;
    
}
-(void)setupLightSwitch{
    self.lightSwitch = [SKSpriteNode spriteNodeWithImageNamed:@"sznurek3"];
    self.lightSwitch.position = CGPointMake(self.lightSwitch.size.width/2, 578);
    self.lightSwitch.zPosition = 1;
    self.lightSwitch.anchorPoint = CGPointZero;
    [self addChild:self.lightSwitch];
    [self drawHintinLocation:self.lightSwitch afterDelay:1];

}
-(void)animateTheDuck{
    if (self.duckActive){
        [self spawnDuck];
        SKAction *wait = [SKAction waitForDuration:8];
        SKAction *rotate = [SKAction rotateByAngle:M_PI_4 duration:1];
        [self.duck runAction:[SKAction runBlock:^{
            
            [self.duck.physicsBody applyImpulse:CGVectorMake(0, 50)];
            [self.duck runAction:rotate];
        }]completion:^{
            [self.duck runAction:wait completion:^{
                [self.duck removeFromParent];
                if(self.duckCounter<10){
                    [self animateTheDuck];
                }
            }];
            
        }];
    }
}
-(void)animateAnotherDuck{
    if (self.duckActive){
        [self spawnSecondDuck];
        
        SKAction *wait = [SKAction waitForDuration:7];
        SKAction *rotate = [SKAction rotateByAngle:M_PI_4 duration:1];
        [self.duckTwo runAction:[SKAction runBlock:^{
            
            [self.duckTwo.physicsBody applyImpulse:CGVectorMake(0, 50)];
            [self.duckTwo runAction:rotate];
        }]completion:^{
            [self.duckTwo runAction:wait completion:^{
                [self.duckTwo removeFromParent];
                
                if(self.duckCounter<4){
                    
                    [self animateAnotherDuck];
                }
            }];
            
        }];
    }
}
-(void)spawnSecondDuck{
    
    CGFloat randomX = ScalarRandomRange(535, 790);
    self.duckTwo= [SKSpriteNode spriteNodeWithImageNamed:@"duck"];
    self.duckTwo.position = CGPointMake(randomX, self.size.height/2-100);
    self.duckTwo.name = @"duck";
    self.duckTwo.zPosition = -1;
    
    self.duckTwo.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.duck.frame.size.width/2];
    self.duckTwo.physicsBody.density = 0.4;
    self.duckTwo.physicsBody.restitution = 0.4;
    self.duckTwo.physicsBody.categoryBitMask = LBPhysicsCategoryDuckTwo;
    self.duckTwo.physicsBody.collisionBitMask = LBPhysicsCategoryWorld;
    
    [self addChild:self.duckTwo];
    
}
-(void)spawnDuck{
    
    CGFloat randomX = ScalarRandomRange(535, 790);
    self.duck= [SKSpriteNode spriteNodeWithImageNamed:@"duck"];
    self.duck.position = CGPointMake(randomX, self.size.height/2-100);
    self.duck.name = @"duck";
    self.duck.zPosition = -1;
    
    self.duck.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.duck.frame.size.width/2];
    self.duck.physicsBody.density = 0.4;
    self.duck.physicsBody.restitution = 0.4;
    self.duck.physicsBody.categoryBitMask = LBPhysicsCategoryDuckOne;
    self.duck.physicsBody.collisionBitMask = LBPhysicsCategoryWorld;
    [self addChild:self.duck];
    
}
-(void)setupBathTubWithShower{
    self.bathTub = [SKSpriteNode spriteNodeWithImageNamed:@"wanna22"];
    self.bathTub.position = CGPointMake(self.size.width - 310, self.size.height/3 -50);
    self.bathTub.zPosition = 0;
    
    self.shower = [SKSpriteNode spriteNodeWithImageNamed:@"prysznic"];
    self.shower.position = CGPointMake(self.bathTub.position.x - 190, self.bathTub.position.y + 180);
    
    [self addChild:self.shower];
    self.rope = [SKSpriteNode spriteNodeWithImageNamed:@"walek"];
    self.rope.zPosition = 0;
    self.rope.position = CGPointMake(self.bathTub.position.x - 30, self.size.height-170);
    
    SKShapeNode *edgeLine = [SKShapeNode shapeNodeWithRect:CGRectMake(self.size.width - 610, self.size.height/3-100, 600, 10)];
    edgeLine.alpha = 0;
    edgeLine.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:edgeLine.frame];
    edgeLine.zPosition = -100;
    [self addChild:edgeLine];
    
    self.curtain = [SKSpriteNode spriteNodeWithImageNamed:@"kurtynaDuza"];
    self.curtain.position = CGPointMake(self.rope.position.x + 90, 440);
    self.curtain.zPosition = 2;
    
    
    [self addChild:self.curtain];
    [self addChild:self.rope];
    
    [self addChild:self.bathTub];
    
    
}

-(void)setupBubbleEmitter{
    self.bubbles = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"Bubbles" ofType:@"sks"]];
    self.bubbles.position = CGPointMake(self.size.width - 310, self.size.height/3 + 20);
    self.bubbles.zPosition = 1;
    [self addChild:self.bubbles];
    
}

-(void)setupFullSink{
    self.sink = [SKSpriteNode spriteNodeWithImageNamed:@"zlewDol"];
    self.sink.position = CGPointMake(self.sink.size.width/2 +50, self.size.height/3 -50);
    self.sink.zPosition = -1;
    self.tap = [SKSpriteNode spriteNodeWithImageNamed:@"kran"];
    self.tap.position = CGPointMake(self.sink.size.width/2 +50, self.size.height/3 +70);
    self.tap.zPosition = -1;
    
    
    self.bathtoolsTouchesActive = YES;
    self.toothPaste = [SKSpriteNode spriteNodeWithImageNamed:@"toothPaste"];
    self.toothPaste.position = CGPointMake(self.sink.position.x - 60, self.sink.position.y+65);
    self.toothPasteActive = YES;
    self.toothPaste.zPosition = 302;
    self.mug = [SKSpriteNode spriteNodeWithImageNamed:@"toothbrushMug"];
    self.mug.position = CGPointMake(self.sink.position.x + 80, self.sink.position.y+135);
    self.mugActive = YES;
    self.mug.zPosition = 302;
    [self addChild:self.mug];
    [self addChild:self.toothPaste];
    [self addChild:self.sink];
    [self addChild:self.tap];
    
}

-(void)setupMirror{
    self.mirror = [SKSpriteNode spriteNodeWithImageNamed:@"Lustro"];
    self.mirror.position = CGPointMake(self.sink.size.width/2 +50, self.size.height/2 +90);
    self.mirror.zPosition = -1;
    [self addChild:self.mirror];
}
- (void)showSoundButtonForTogglePosition:(BOOL)togglePosition
{
    if (togglePosition)
    {
        self.soundIcon.texture = [SKTexture textureWithImageNamed:@"glosnik2"];
        self.musicOn = NO;
        [[SKTAudio sharedInstance]pauseBackgroundMusic];
        
    }
    else
    {
        self.soundIcon.texture = [SKTexture textureWithImageNamed:@"glosnik"];
        self.musicOn = YES;
        [[SKTAudio sharedInstance]playBackgroundMusic:@"BathroomWaterMusic.mp3"];
        
    }
}

-(void)startTheBubbleAnimation{
    SKAction *wait = [SKAction waitForDuration:2];
    
    SKAction *wait2 = [SKAction waitForDuration:1];
    
    SKAction *wait3 = [SKAction waitForDuration:3];
    
    SKAction *wait4 = [SKAction waitForDuration:4];
    
    // SKAction *remove = [SKAction removeFromParent];
    
    SKAction *block1 =[SKAction runBlock:^{
        [self runAction:wait2 completion:^{
            [self setupBubble1];
            
            [self runAction:[SKAction waitForDuration:1] completion:^{
                [self setupBubble8];
                
            }];
            
        }];
        
        
    }];
    
    SKAction *block2 =[SKAction runBlock:^{
        [self runAction:wait3 completion:^{
            [self setupBubble2];
            
            [self runAction:[SKAction waitForDuration:1] completion:^{
                [self setupBubble6];
                
            }];
            
        }];
        
    }];
    SKAction *block3 =[SKAction runBlock:^{
        [self runAction:wait4 completion:^{
            [self setupBubble3];
            
            
            [self runAction:[SKAction waitForDuration:4] completion:^{
                [self setupBubble7];
                
            }];
            
        }];
        
    }];
    
    SKAction *block4 =[SKAction runBlock:^{
        [self runAction:wait completion:^{
            [self setupBubble4];
            [self runAction:[SKAction waitForDuration:2] completion:^{
                [self setupBubble5];
                
            }];
        }];
        
    }];
    
    [self runAction:[SKAction sequence:@[wait]] completion:^{
        
        
        [self runAction:[SKAction sequence:@[block1, block2, block3, block4]]];
        
        
    }];
    
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    SKAction *wait = [SKAction waitForDuration:1];
    
    
    for (UITouch * touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [_bellBodyObject moveHeadTowards:location];
        
        self.touchStartPoint = [touch locationInNode:self];
        
        if (!self.lightSwitch) {
            self.littleSparkEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"LittleSpark" ofType:@"sks"]];
            self.littleSparkEmitter.zPosition = 100;
            self.littleSparkEmitter.position = location;
            
            [self addChild:self.littleSparkEmitter];
        }
        
        if ([self.soundIcon containsPoint:location]){
            
            [self showSoundButtonForTogglePosition:self.musicOn];
        }
        
        if ([self.arrow containsPoint:location] && self.arrowActive) {
            
            SKView * skView = (SKView *)self.view;
            skView.showsFPS = NO;
            skView.showsNodeCount = NO;
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = YES;
            
            // Create and configure the scene.
            SKScene *gameScene3 = [[GameScene3 alloc]initWithSize:self.size];
            gameScene3.scaleMode = SKSceneScaleModeAspectFill;
            //[self fadeOutTheMusic];
            [[SKTAudio sharedInstance]pauseBackgroundMusic];
            SKTransition *transition = [SKTransition fadeWithColor:[UIColor blackColor] duration:3];
            // Present the scene.
            [self.view presentScene:gameScene3 transition:transition];
            
            
            
        }
        
        if ([_bellBodyObject.bellsBody containsPoint:location] || [_bellBodyObject.bellsHead containsPoint:location]) {
            [self bellRandomNoises];
            
        }
        if ([self.duck containsPoint:location] && self.duckActive) {
            [self setupDuckExplosionEmitter:location];
            [self.duck removeFromParent];
            self.duckCounter++;
            [[SKTAudio sharedInstance]playSoundEffect:@"SFX Scena 2 Kaczka.mp3"];
            if (self.duckCounter != 10) {
                SKAction *wait = [SKAction waitForDuration:3];
                [self runAction:wait completion:^{
                    [self animateTheDuck];
                }];
                
            }else{
                
            }
            
        }
        if ([self.duckTwo containsPoint:location] && self.duckActive) {
            [self setupDuckExplosionEmitter:location];
            [self.duckTwo removeFromParent];
            self.duckCounter++;
            [[SKTAudio sharedInstance]playSoundEffect:@"SFX Scena 2 Kaczka.mp3"];
            if (self.duckCounter !=3) {
                SKAction *wait = [SKAction waitForDuration:3];
                [self runAction:wait completion:^{
                    [self animateAnotherDuck];
                }];
                
            }else{
                //                [self setupCharacterHappyAnimation];
                //                self.duckActive = NO;
                //
                //                self.physicsWorld.gravity = CGVectorMake(0, 0.5);
                //
                //                [self startTheBubbleAnimation];
                
            }
            
        }
        
        
        if ([self.curtain containsPoint:location]) {
            
            if (!self.touchingCurtain){
                self.touchingCurtain = YES;
                [self removeActionWithAlpha:self.curtain];
                [self drawHintinLocation:self.shower afterDelay:1];
                [self.curtain removeFromParent];
                self.curtain = [SKSpriteNode spriteNodeWithImageNamed:@"kurtynaMala2"];
               // self.wardrobe.size = self.wardrobe.texture.size;
                self.curtain.size = self.curtain.texture.size;
                self.curtain.position = CGPointMake(self.rope.position.x + 190, 440);
                self.curtain.zPosition = 2;
                [self addChild:self.curtain];
                [self.curtain runAction:[SKAction playSoundFileNamed:@"SFX Scena2 Kurtyna.mp3" waitForCompletion:NO]];
                
                
                
            }
        }
        
        SKTexture *bubbleBurst = [SKTexture textureWithImageNamed:@"bankaWybuchEdited"];
        SKAction *bubbleExplosion = [SKAction fadeOutWithDuration:0.2];
        if ([self.bubble1 containsPoint:location]) {
            
            [self.bubble1 setTexture:bubbleBurst];
            [self.bubble1 runAction:self.bubbleSound];
            [self.bubble1 runAction:bubbleExplosion completion:^{
                
                [self.bubble1 removeFromParent];
                [self runAction:wait completion:^{
                    self.bubblesCounter++;
                    if (self.bubblesActive) {
                        [self setupBubble1];
                      }
                    }];
            }];
            
        }
        if ([self.bubble2 containsPoint:location]) {
            
            [self.bubble2 setTexture:bubbleBurst];
            [self.bubble2 runAction:self.bubbleSound];
            
            [self.bubble2 runAction:bubbleExplosion completion:^{
                self.bubblesCounter++;
                [self.bubble2 removeFromParent];
                [self runAction:wait completion:^{
                    
                    if (self.bubblesActive) {
                        [self setupBubble2];
                     }
                    }];
                
            }];
            
        }
        if ([self.bubble3 containsPoint:location]) {
            
            [self.bubble3 setTexture:bubbleBurst];
            [self.bubble3 runAction:self.bubbleSound];
            
            [self.bubble3 runAction:bubbleExplosion completion:^{
                self.bubblesCounter++;
                [self.bubble3 removeFromParent];
                [self runAction:wait completion:^{
                    if (self.bubblesActive){
                        [self setupBubble3];
                     }
                }];
                
            }];
            
        }
        if ([self.bubble4 containsPoint:location]) {
            
            [self.bubble4 setTexture:bubbleBurst];
            [self.bubble4 runAction:self.bubbleSound];
            
            [self.bubble4 runAction:bubbleExplosion completion:^{
                self.bubblesCounter++;
                [self.bubble4 removeFromParent];
                [self runAction:wait completion:^{
                    if (self.bubblesActive){
                        [self setupBubble4];}
                }];
                
            }];
            
        }
        if ([self.bubble5 containsPoint:location]) {
            
            [self.bubble5 setTexture:bubbleBurst];
            [self.bubble5 runAction:self.bubbleSound];
            
            [self.bubble5 runAction:bubbleExplosion completion:^{
                self.bubblesCounter++;
                [self.bubble5 removeFromParent];
                [self runAction:wait completion:^{
                    if (self.bubblesActive){
                        [self setupBubble5];
                    }
                }];
                
            }];
            
        }
        if ([self.bubble6 containsPoint:location]) {
            
            [self.bubble6 setTexture:bubbleBurst];
            [self.bubble6 runAction:self.bubbleSound];
            
            [self.bubble6 runAction:bubbleExplosion completion:^{
                self.bubblesCounter++;
                [self.bubble6 removeFromParent];
                [self runAction:wait completion:^{
                    if (self.bubblesActive){
                        [self setupBubble6];
                    }
                }];
                
            }];
            
        }
        if ([self.bubble7 containsPoint:location]) {
            
            [self.bubble7 setTexture:bubbleBurst];
            [self.bubble7 runAction:self.bubbleSound];
            
            [self.bubble7 runAction:bubbleExplosion completion:^{
                self.bubblesCounter++;
                [self.bubble7 removeFromParent];
                [self runAction:wait completion:^{
                    if (self.bubblesActive){
                        [self setupBubble7];
                    }
                }];
                
            }];
            
        }
        if ([self.bubble8 containsPoint:location]) {
            
            [self.bubble8 setTexture:bubbleBurst];
            [self.bubble8 runAction:self.bubbleSound];
            
            [self.bubble8 runAction:bubbleExplosion completion:^{
                self.bubblesCounter++;
                [self.bubble8 removeFromParent];
                [self runAction:wait completion:^{
                    
                    if (self.bubblesActive){
                        [self setupBubble8];
                    }
                }];
                
            }];
            
        }
        if ([self.shower containsPoint:location] && !self.touchingShower) {
            [self removeActionWithAlpha:self.shower];
            self.touchingShower = YES;
            
            
            
            SKTexture *bathTubeFullTexture = [SKTexture textureWithImageNamed:@"wanna2woda"];
            SKAction *setBathTubeTexture = [SKAction setTexture:bathTubeFullTexture];
            
            [self startTheWaterAnimation];
            
            // [self startTheBubbleAnimation];
            if (self.touchingShower) {
                
                
                
                [self.bathTub runAction:[SKAction sequence:@[wait, setBathTubeTexture]]];
                
                [self.bathTub runAction:wait completion:^{
                    [self setupBubbleEmitter];
                    // self.touchingShower = NO;
                    // [self setupSingleBubbles];
                }];
                
                
                
            }
            
            
            
        }
        
        
        if ([self.lightSwitch containsPoint:location]){
            self.lightSwitchStatus = YES;
            self.lightTouchingPoint = location;
        }
        if (self.bathtoolsTouchesActive){
            if ([self.toothPaste containsPoint:location] && self.toothPasteActive == YES) {
                self.originalPosition = self.toothPaste.position;

                self.touchingToothPaste = YES;
                self.touchingPoint = location;
            }
            if ([self.mug containsPoint:location] && self.mugActive == YES) {
                self.originalPosition = self.mug.position;
                
                self.touchingMug = YES;
                self.touchingPoint = location;
            }
        }
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    for (UITouch *touch in touches){
        
        CGPoint location = [touch locationInNode:self];
        CGPoint newLocation = CGPointMake(self.lightSwitch.position.x, location.y);
        
        self.touchingPoint = [[touches anyObject]locationInNode:self];
        
        self.cutEffect = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"cutEffect" ofType:@"sks"]];
        self.cutEffect.position = location;
        [self addChild:self.cutEffect];
        
        
        if (self.lightSwitchStatus) {
            self.lightSwitch.position = newLocation;
            
            if (newLocation.y < self.lightSwitchYOriginalPosition.y - 100) {
                
                newLocation.y = self.lightSwitchYOriginalPosition.y - 100;
            }
            
            
            self.lightSwitch.position = newLocation;
            
        }
        
    }
    
    
    //[self setupLevel2];
    
    
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
    if (!self.toothPasteActive) {
        [self.toothPaste runAction:bouncing];
        
    }
    if (!self.mugActive) {
        [self.mug runAction:bouncing];
    }
    
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    
    
    
    if (self.touchingToothPaste && self.toothPasteActive == YES) {
        CGPoint currentPoint = [[touches anyObject] locationInNode:self];
        CGPoint finalPos = _bellBodyObject.bellsBody.position;
        
        if ([self isWithinCharactersBody:currentPoint])
        {
            [self removeActionWithAlpha:self.toothPaste];
            self.toothPaste.position = CGPointMake(finalPos.x-70, finalPos.y+10);
            self.toothPaste.zRotation = M_PI-M_PI_4;
            self.touchingToothPaste = NO;
            self.toothPasteActive = NO;
            [self setupBigSparkEmiter:currentPoint];
            [self.toothPaste runAction:[SKAction playSoundFileNamed:@"SFX Scena 2 Szczotka Pasta.mp3" waitForCompletion:NO]];
            self.teethToolsCounter++;
            
        }else if (self.bathtoolsTouchesActive){
            [self animatePuttingThingsBack:self.toothPaste];
            self.touchingToothPaste = NO;
        }
    }
    
    if (self.touchingMug && self.mugActive == YES) {
        CGPoint currentPoint = [[touches anyObject] locationInNode:self];
        CGPoint finalPos = _bellBodyObject.bellsBody.position;
        
        if ([self isWithinCharactersBody:currentPoint])
        {
            [self removeActionWithAlpha:self.mug];
            self.mug.position = CGPointMake(finalPos.x+70, finalPos.y+20);
            self.mug.zRotation = -M_PI/8;
            self.touchingMug = NO;
            self.mugActive = NO;
            
            [self setupBigSparkEmiter:currentPoint];
            [self.mug runAction:[SKAction playSoundFileNamed:@"SFX Scena 2 Szczotka Pasta.mp3" waitForCompletion:NO]];
            self.teethToolsCounter++;
            // [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarThree];
            
        }else if(self.bathtoolsTouchesActive){
            [self animatePuttingThingsBack:self.mug];
            self.touchingMug = NO;
            
        }
    }
    
    
    if (self.lightSwitch.position.y < 550 && (self.lightSwitchStatus == YES)){
        self.moveUp = [SKAction moveToY: 758 duration:0.5];
        [self.lightSwitch runAction:self.moveUp];
        self.lightSwitchStatus = NO;
        [self.lightSwitch runAction:[SKAction playSoundFileNamed:@"Wlacznik SFX.mp3" waitForCompletion:NO]];
        [self removeActionWithAlpha:self.lightSwitch];
        [self setupLevel2];
        
        
    }
}
//-(void)setupShowerDrops{
//
//    self.bubblesCounter = 0;
//    self.showerDrops = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"Water" ofType: @"sks"]];
//    self.showerDrops.zPosition = 1;
//    // self.trail.targetNode = self;
//    self.showerDrops.position = CGPointMake(self.shower.position.x+50, self.shower.position.y+50);
//
//    [self addChild:self.showerDrops];
//
//
//}
-(void)startTheWater{
    
}
-(void)startTheWaterAnimation{
    
    NSMutableArray *dropFrames = [NSMutableArray array];
    [dropFrames addObject:[SKTexture textureWithImageNamed:@"woda prysznic1"]];
    [dropFrames addObject:[SKTexture textureWithImageNamed:@"woda prysznic2"]];
    [dropFrames addObject:[SKTexture textureWithImageNamed:@"woda prysznic3"]];
    
    
    self.showerDropsFrames = dropFrames;
    
    
    self.drops = [SKSpriteNode spriteNodeWithTexture:self.showerDropsFrames[0]];
    self.drops.zPosition = 1;
    self.drops.position = CGPointMake(self.shower.position.x+70, self.shower.position.y-30);
    
    [self addChild:self.drops];
    [self.drops runAction:[SKAction playSoundFileNamed:@"SFX Scena2 Woda.mp3" waitForCompletion:NO]];
    [self.drops runAction:[SKAction repeatAction:[SKAction animateWithTextures:self.showerDropsFrames
                                                                  timePerFrame:0.1f
                                                                        resize:NO
                                                                       restore:YES] count:10]completion:^{
        
        [self.drops removeFromParent];
        self.duckActive = YES;
        [self animateTheDuck];
        [self animateAnotherDuck];
    }];
    
    //    [self.drops runAction:[SKAction repeatAction:[SKAction animateWithTextures:self.showerDropsFrames
    //                                                                  timePerFrame:0.05f
    //                                                                        resize:NO
    //                                                                        restore:YES] count:15]completion:^{
    //
    //        [self.drops removeFromParent];
    //    }];
    
    
}
-(void)setupBigSparkEmiter:(CGPoint)coordinates{
    
    
    self.bigSparkEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"BigSpark" ofType:@"sks"]];
    self.bigSparkEmitter.zPosition = 500;
    self.bigSparkEmitter.position = coordinates;
    
    [self addChild:self.bigSparkEmitter];
}
-(void)setupDuckExplosionEmitter:(CGPoint)coordinates{
    
    
    self.duckExplosionEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"duckExplosion" ofType:@"sks"]];
    self.duckExplosionEmitter.zPosition = 500;
    self.duckExplosionEmitter.position = coordinates;
    
    [self addChild:self.duckExplosionEmitter];
    
}
-(BOOL)isWithinCharactersBody:(CGPoint)currentLocation{
    if (currentLocation.x >= _bellBodyObject.bellsBody.position.x - BODY_OFFSET && currentLocation.x <= _bellBodyObject.bellsBody.position.x + BODY_OFFSET && currentLocation.y >= _bellBodyObject.bellsBody.position.y - BODY_OFFSET && currentLocation.y <= _bellBodyObject.bellsBody.position.y + BODY_OFFSET){
        
        return YES;
    }else
        return NO;
}


-(void)animatePuttingThingsBack:(SKSpriteNode *)node
{
    self.bathtoolsTouchesActive = NO;
    
    SKAction *scaleDown = [SKAction scaleTo:1.0 duration:0.5];
    SKAction *moveLeft = [SKAction moveByX:-10 y:0 duration:0.2];
    SKAction *moveRight = [SKAction moveByX:10 y:0 duration:0.2];
    
    SKAction *fastMovementSeq = [SKAction repeatAction:[SKAction sequence:@[moveLeft, moveRight]] count:4];
    SKAction *moveBack = [SKAction moveTo:self.originalPosition duration: 1];
    SKAction *rotateBack = [SKAction rotateByAngle:M_PI *2 duration:0.5];
    SKAction *group = [SKAction group:@[moveBack, rotateBack]];
    ;
    
    SKAction *seq =[SKAction sequence: @[scaleDown, fastMovementSeq, group]];
    [node runAction:seq completion:^{
        
        self.bathtoolsTouchesActive = YES;
        
    }];
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.touchingMug = NO;
    self.touchingToothPaste = NO;
}
-(void)update:(CFTimeInterval)currentTime {
    
    if (self.touchingShower) {
        
        if (self.bubblesCounter == 20 && !self.bubbleStickerActive) {
            //run the animation here
            [self drawHintinLocation:self.mug afterDelay:4];
            [self drawHintinLocation:self.toothPaste afterDelay:5];
            self.bubblesActive = NO;
            [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarOne];
            [self setupCharacterHappyAnimation];
            self.bubbleStickerActive = YES;
            [self enumerateChildNodesWithName:@"bubble" usingBlock:^(SKNode *node, BOOL *stop) {
                SKTexture *bubbleBurst = [SKTexture textureWithImageNamed:@"bankaWybuchEdited"];
                SKAction *bubbleExplosion = [SKAction fadeOutWithDuration:0.2];
                
                [node runAction:[SKAction setTexture:bubbleBurst]];
                // [node setTexture:bubbleBurst];
                [node runAction:self.bubbleSound];
                [node runAction:bubbleExplosion completion:^{
                    
                    [node removeFromParent];
                    
                    
                }];
            }];
            
        }
        
        if (self.teethToolsCounter == 2 && !self.teethToolsActive) {
            self.teethToolsActive = YES;
            [self setupCharacterHappyAnimation];
            [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarTwo];
        }
        if (self.touchingToothPaste) {
            self.toothPaste.position = self.touchingPoint;
        }
        
        if (self.touchingMug) {
            self.mug.position = self.touchingPoint;
        }
        if (self.stickerOne.stickerCounter == 3 && self.arrowActive == NO) {
            [self blinking];
        }
        if (self.duckCounter == 10 && self.duckActive) {
            [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarThree];
            [self setupCharacterHappyAnimation];
            self.duckActive = NO;
            self.physicsWorld.gravity = CGVectorMake(0, 0.5);
            // SKAction *fadeOut = [SKAction fadeOutWithDuration:3];
            
            [self startTheBubbleAnimation];
            [self enumerateChildNodesWithName:@"duck" usingBlock:^(SKNode *node, BOOL *stop) {            [node removeFromParent];
                //            [node runAction:fadeOut];
                //            [node removeAllActions];
            }];
        }
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
