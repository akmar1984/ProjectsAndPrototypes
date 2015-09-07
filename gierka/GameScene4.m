//
//  GameScene4.m
//  gierka
//
//  Created by Marek Tomaszewski on 11/12/2014.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "GameScene4.h"
#import "Flowers.h"
#import "Bird.h"
#import "Worm.h"
#import "Baloon.h"
#import "Stickers.h"
#import "GameScene5.h"
#import "SKTAudio.h"
#import "BellBody.h"
#import "SKTUtils.h"

@interface GameScene4 ()

@property (nonatomic)SKSpriteNode *character;
@property (nonatomic)SKSpriteNode *background;
@property (nonatomic)SKSpriteNode *cow;
@property (nonatomic)SKSpriteNode *cowsHead;
@property (nonatomic)SKSpriteNode *cowTail;

@property (nonatomic)SKSpriteNode *squirrel;
@property (nonatomic)SKSpriteNode *squirrelHead;
@property (nonatomic)SKSpriteNode *squirrelTail;
@property (nonatomic)SKSpriteNode *nuts;
@property (nonatomic)SKSpriteNode *nuts2;
@property (nonatomic)SKSpriteNode *nuts3;
@property (nonatomic) BOOL touchingNuts;
@property (nonatomic) BOOL touchingNuts2;
@property (nonatomic) BOOL touchingNuts3;
@property (nonatomic) BOOL nut1Active;
@property (nonatomic) BOOL nut2Active;
@property (nonatomic) BOOL nut3Active;

@property (nonatomic) CGPoint touchingPoint;
@property (nonatomic) CGPoint originalPosition;

@property (nonatomic)SKSpriteNode *bird;
@property (nonatomic)NSArray *cowWalkingFrames;
@property (nonatomic)NSArray *squirrelWalkingFrames;

@property (nonatomic)SKSpriteNode *fence;
@property (nonatomic)SKSpriteNode *tree;
@property (nonatomic)SKSpriteNode *cloud1;
@property (nonatomic)SKSpriteNode *cloud2;
@property (nonatomic)SKSpriteNode *cloud3;
@property (nonatomic)SKSpriteNode *cloud4;
@property (nonatomic)SKSpriteNode *cloud5;
@property (nonatomic)SKSpriteNode *cloud6;
@property SKSpriteNode *flower;
@property SKSpriteNode *flower2;
@property (nonatomic) SKSpriteNode *queFlower1;
@property (nonatomic) SKSpriteNode *queFlower2;
@property (nonatomic) SKSpriteNode *queFlower3;
@property (nonatomic) SKSpriteNode *queFlower4;
@property (nonatomic) SKSpriteNode *queFlower5;
@property (nonatomic) SKSpriteNode *queFlower6;

@property (nonatomic) Stickers *stickerOne;
@property (nonatomic) SKNode *stickerOneNode;

@property (nonatomic) SKTextureAtlas *atlas;


@property SKShapeNode *footer;
@property (nonatomic) NSArray *characterWalkingFrames;
@property (nonatomic)SKEmitterNode *chimneyFlame;
@property (nonatomic)SKEmitterNode *chimneyFlame2;
@property (nonatomic)SKEmitterNode *chimneyFlame3;
@property (nonatomic)SKEmitterNode *littleSparkEmitter;
@property (nonatomic)SKEmitterNode *bigSparkEmitter;


@property (nonatomic)AVAudioPlayer *backgroundMusicPlayer2;
@property SKSpriteNode *soundIcon;
@property SKSpriteNode *arrow;

@property (nonatomic)SKAction *cloudMoving;
@property (nonatomic)SKAction *fadeOut;
@property (nonatomic)SKAction *fadeIn;
@property (nonatomic)SKAction *playWind;


@property (nonatomic) BOOL touchingCow;
@property (nonatomic) BOOL touchingSquirrel;
@property (nonatomic) BOOL touchingFlowerOne;
@property (nonatomic) BOOL touchingFlowerTwo;
@property (nonatomic) BOOL touchingFlowerThree;
@property (nonatomic) BOOL touchingFlowerFour;
@property (nonatomic) BOOL touchingFlowerFive;
@property (nonatomic) BOOL touchingFlowerSix;
@property (nonatomic) BOOL flowerOneActive;
@property (nonatomic) BOOL flowerTwoActive;
@property (nonatomic) BOOL flowerThreeActive;
@property (nonatomic) BOOL flowerFourActive;
@property (nonatomic) BOOL flowerFiveActive;
@property (nonatomic) BOOL flowerSixActive;
@property (nonatomic) BOOL flowerAnimationActive;
@property BOOL arrowActive;
@property BOOL squirrelTouchesActive;
@property BOOL nutsTouchesActive;



@property (nonatomic) BOOL musicOn;
@property BOOL flowerOpenFlag;
@property (assign) int nutsCounter;
@property BOOL nutsActive;

@property (nonatomic) BOOL wormActive;
@property (assign) int wormCounter;

@property (nonatomic) BellBody *bellBodyObject;
@property (nonatomic) CGPoint cloudPoint;



@end
static const int BODY_OFFSET = 50;
//static const float ZOMBIE_MOVE_POINTS_PER_SEC = 120.0;

@implementation GameScene4
{
    Flowers *_flowerOne;
    Bird *_bird;
    Worm *_worm;
    Baloon *_baloon;
    SKNode *_flowerNode;
    SKNode * _birdNode;
    SKNode *_wormNode;
    SKNode *_baloonNode;
    
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    CGPoint _velocity;
    CGPoint _lastTouchLocation;
    
}
 


-(void)didMoveToView:(SKView *)view{
    
    [self setupLevel4];
    [[SKTAudio sharedInstance]playSoundEffectInaLoop:@"Wiatr SFX.mp3"];
    [self drawHintinLocation:self.nuts afterDelay:0];
    [self drawHintinLocation:self.nuts2 afterDelay:3];
    [self drawHintinLocation:self.nuts3 afterDelay:2];
    [self drawHintinLocation:self.squirrel afterDelay:2];

}



-(void)setupLevel4{
    [self setupBackground4];
    [self setupCow];
    [self setupSquirrel];
    [self setupFence];
    [self setupTree];
    [self setupBird];
    [self baloonAction];
    [self setupStickers];
    [self setupCloud];
    [self setupCharacter];
   // [self setupFooter];
    [self setupArrow];
    [self setupSoundIcon];
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

-(void)setupStickers{
    
    self.stickerOneNode = [SKNode node];
    self.stickerOne = [[Stickers alloc]initStickerWithPosition:CGPointMake(0, 768)andStickerFormsPosition:CGPointMake(130, 50)];
    [self.stickerOneNode addChild:self.stickerOne];
    [self addChild:self.stickerOneNode];
}
-(void)setupFooter{
    
    self.footer = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(1024, 70)];
    
    self.footer.fillColor = [SKColor whiteColor];
    self.footer.zPosition = 101;
    self.footer.position = CGPointMake(512, 50);
    //  self.footer.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 120) toPoint:CGPointMake(size.width, 120)];
    
    [self addChild:self.footer];
    
    
}
-(void)baloonAction{
    
    
    SKAction *block = [SKAction runBlock:^{
        
        [self setupBaloon];
        
        
        
    }];
    SKAction *fullBaloonMovementSequence = [SKAction repeatActionForever:[SKAction sequence:@[block, [SKAction waitForDuration:12.0]] ]];
    [self runAction: fullBaloonMovementSequence];
}

-(void)setupBaloon{
    _baloonNode = [SKNode node];
    CGFloat randomY = arc4random()%100;
    // setup the baloon //
    _baloon = [[Baloon alloc]initBaloonWithPosition:CGPointMake(self.size.width, self.size.height - _baloonNode.frame.size.height - randomY)];
    [_baloonNode addChild:_baloon];
    [self addChild:_baloonNode];
    [_baloon setupBaloonAnimation];
    
}
-(void)setupSoundIcon{
    self.soundIcon = [SKSpriteNode spriteNodeWithImageNamed:@"glosnik"];
    self.soundIcon.position = CGPointMake(self.soundIcon.size.width+50, self.size.height-self.soundIcon.size.height);
    [self addChild:self.soundIcon];
    
}
-(void)setupArrow{
    self.arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrowRight"];
    self.arrow.position = CGPointMake(self.size.width-self.arrow.size.width/2, self.arrow.size.height);
    self.arrow.zPosition = 102;
    self.arrow.alpha = 0.5;
    self.arrowActive = NO;
    [self addChild:self.arrow];
    
}
-(void)activateFlowers{
    
    self.flowerOneActive = YES;
    self.flowerTwoActive = YES;
    self.flowerThreeActive = YES;
    self.flowerFourActive = YES;
    self.flowerFiveActive = YES;
    self.flowerSixActive = YES;
}
-(void)setupBackground4{
    self.atlas = [SKTextureAtlas atlasNamed:@"flowers"];
    self.background = [SKSpriteNode spriteNodeWithImageNamed:@"background4"];
    self.background.anchorPoint = CGPointZero;
    self.background.zPosition = -2;
    [self addChild:self.background];
    
//    [self playBackgroundMusic:@"Bell Music Field Scene3.mp3"];
    self.musicOn = YES;
    [[SKTAudio sharedInstance]playBackgroundMusic:@"Bell Music Field Scene3.mp3"];
//   [self.backgroundMusicPlayer play];
    
    [self setupChimneyEmitterEffect];
    [self setupFlower];
    
}

-(void)setupFlower{
     [self activateFlowers];
    _flowerNode = [SKNode node];
    _flowerOne = [[Flowers alloc] initWithPosition:CGPointMake(300, 300)];
    [_flowerNode addChild:_flowerOne];
    [self addChild:_flowerNode];
    
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
        [[SKTAudio sharedInstance]playBackgroundMusic:@"Bell Music Field Scene3.mp3"];
    }
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
- (void)playBackgroundMusic2:(NSString *)filename
{
    
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    self.backgroundMusicPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer2.numberOfLoops = -1;
    self.backgroundMusicPlayer2.volume = 0.05;
    [self.backgroundMusicPlayer2 prepareToPlay];
}
-(void)setupSquirrel{
    self.squirrelTouchesActive = YES;

    self.touchingSquirrel = NO;
    NSMutableArray *walkFrames = [NSMutableArray array];
    [walkFrames addObject:[SKTexture textureWithImageNamed:@"wiewiora1"]];
    [walkFrames addObject:[SKTexture textureWithImageNamed:@"wiewiora2"]];
    
    self.squirrelWalkingFrames = walkFrames;
    SKTexture *temp = self.squirrelWalkingFrames[0];
    self.squirrel = [SKSpriteNode spriteNodeWithTexture:temp];
    self.squirrel.position = CGPointMake(self.size.width - self.squirrel.size.width, 180);
    [self addChild:self.squirrel];
    
    self.squirrelHead = [SKSpriteNode spriteNodeWithImageNamed:@"wiewiora glowa"];
    self.squirrelHead.position = CGPointMake(-50,30);
    self.squirrelHead.zPosition = 2;
    
    [self.squirrel addChild:self.squirrelHead];
    [self setupSquirrelHeadAnimation];
    
    
    self.nutsTouchesActive = YES;
    self.nut1Active = YES;
    self.nuts = [SKSpriteNode spriteNodeWithImageNamed:@"orzech"];
    self.nuts.position = CGPointMake(self.nuts.size.width, 300);
    self.nuts.zPosition = 2;
    [self addChild:self.nuts];
    
    self.nuts2 = [SKSpriteNode spriteNodeWithImageNamed:@"orzech"];
    self.nut2Active = YES;
    self.nuts2.position = CGPointMake(self.size.width - self.nuts2.size.width, 500);
    self.nuts2.zPosition = 2;
    self.nuts2.zRotation = M_PI_4;
    [self addChild:self.nuts2];
    
    self.nuts3 = [SKSpriteNode spriteNodeWithImageNamed:@"orzech"];
    self.nut3Active = YES;
    self.nuts3.position = CGPointMake(650, 500);
    self.nuts3.zPosition = 2;
    self.nuts3.zRotation = M_PI_2 *3;
    [self addChild:self.nuts3];
    self.nutsActive = YES;
    
}
-(void)setupSquirrelHeadAnimation{
    
    SKAction *wiggleHeadUp = [SKAction rotateByAngle:M_PI_4/16 duration:0.7];
    SKAction *wiggleHeadDown = [SKAction rotateByAngle:-M_PI_4/16 duration:0.7];
    SKAction *wigglingHead = [SKAction repeatAction:[SKAction sequence:@[wiggleHeadDown, wiggleHeadUp]] count:13];
    SKAction *wait = [SKAction waitForDuration:2];
    SKAction *seq =  [SKAction sequence:@[wigglingHead, wait]];
    [self.squirrel runAction:[SKAction repeatActionForever:seq]];
    
    
}
-(void)setupQueAnimationForSprite:(NSString *)sprite inLocation:(CGPoint)currentLocation{
    SKAction *scaling = [SKAction scaleTo:0.6 duration:0.4];
    SKAction *descaling = [SKAction scaleTo:0.5 duration:0.4];
    
    if ([sprite isEqualToString:@"flowerOne"]) {
        self.queFlower1 = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"001"]];
        self.queFlower1.position = currentLocation;
        self.queFlower1.alpha = 0.5;
        self.queFlower1.zPosition = 200;
        [self addChild:self.queFlower1];
        [self.queFlower1 runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaling, descaling]]]withKey:@"flowerAnimation"];
    }
    if ([sprite isEqualToString:@"flowerTwo"]) {
        self.queFlower2 = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"kwiatfaza1"]];
        self.queFlower2.position = currentLocation;
        self.queFlower2.alpha = 0.5;
        self.queFlower2.zPosition = 200;
        [self addChild:self.queFlower2];
        [self.queFlower2 runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaling, descaling]]]withKey:@"flowerAnimation"];
    }
    if ([sprite isEqualToString:@"flowerThree"]) {
        self.queFlower3 = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"kwiat2c"]];
        self.queFlower3.position = currentLocation;
        self.queFlower3.alpha = 0.5;
        self.queFlower3.zPosition = 200;
        [self addChild:self.queFlower3];
        [self.queFlower3 runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaling, descaling]]]withKey:@"flowerAnimation"];
    }
    if ([sprite isEqualToString:@"flowerFour"]) {
        self.queFlower4 = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"kwiatfaza1"]];
        self.queFlower4.position = currentLocation;
        self.queFlower4.alpha = 0.5;
        self.queFlower4.zPosition = 200;
        [self addChild:self.queFlower4];
        [self.queFlower4 runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaling, descaling]]]withKey:@"flowerAnimation"];
    }
    if ([sprite isEqualToString:@"flowerFive"]) {
        self.queFlower5 = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"kwiat2c"]];
        self.queFlower5.position = currentLocation;
        self.queFlower5.alpha = 0.5;
        self.queFlower5.zPosition = 200;
        [self addChild:self.queFlower5];
        [self.queFlower5 runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaling, descaling]]]withKey:@"flowerAnimation"];
    }
    if ([sprite isEqualToString:@"flowerSix"]) {
        self.queFlower6 = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"kwiatfaza1"]];
        self.queFlower6.position = currentLocation;
        self.queFlower6.alpha = 0.5;
        self.queFlower6.zPosition = 200;
        [self addChild:self.queFlower6];
        [self.queFlower6 runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaling, descaling]]]withKey:@"flowerAnimation"];
    }
}
-(BOOL)isWithinTheQueFlower:(SKSpriteNode *)queFlower inLocation:(CGPoint)currentLocation{
    if (currentLocation.x >= queFlower.position.x - BODY_OFFSET && currentLocation.x <= queFlower.position.x + BODY_OFFSET && currentLocation.y >= queFlower.position.y - BODY_OFFSET && currentLocation.y <= queFlower.position.y + BODY_OFFSET){
        [[SKTAudio sharedInstance]playSoundEffect:@"SFXKwiatywFormach.mp3"];
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)isWithinTheSquirrel:(CGPoint)currentLocation{
    if (currentLocation.x >= self.squirrel.position.x - BODY_OFFSET-50 && currentLocation.x <= self.squirrel.position.x + BODY_OFFSET+50 && currentLocation.y >= self.squirrel.position.y - BODY_OFFSET-50 && currentLocation.y <= self.squirrel.position.y + BODY_OFFSET +50){
        [[SKTAudio sharedInstance]playSoundEffect:@"SFXRadoscWiewiorki.mp3"];
        [self removeActionWithAlpha:self.squirrel];
        return YES;
    }else{
        return NO;
    }
}
-(void)setupCow{
    self.touchingCow = NO;
    NSMutableArray *walkFrames = [NSMutableArray array];
    [walkFrames addObject:[SKTexture textureWithImageNamed:@"krowa1"]];
    [walkFrames addObject:[SKTexture textureWithImageNamed:@"krowa22"]];
    
    self.cowWalkingFrames = walkFrames;
    SKTexture *temp = self.cowWalkingFrames[0];
    self.cow = [SKSpriteNode spriteNodeWithTexture:temp];
    
    
    
    self.cow.position = CGPointMake(self.cow.size.width, CGRectGetMidX(self.frame));
    [self addChild:self.cow];
    
    self.cowsHead = [SKSpriteNode spriteNodeWithImageNamed:@"krowaGlowaDuza"];
    self.cowsHead.anchorPoint = CGPointMake(1, 1);
    self.cowsHead.position = CGPointMake(-30, 90);
    self.cowsHead.zPosition = 2;
    
    self.cowTail = [SKSpriteNode spriteNodeWithImageNamed:@"cowTail"];
    self.cowTail.anchorPoint = CGPointMake(0, 1);
    self.cowTail.position = CGPointMake(120, 80);
    
    [self.cow addChild:self.cowTail];
    [self.cow addChild:self.cowsHead];
    
   // [self setupCowsHeadAnimation];
    
}
-(void)moveCow{
   // CGFloat randomX = arc4random()%200+600;
    
    SKAction *moveLeft = [SKAction moveToX:276 duration:7]; //x = 600 worked
    SKAction *animate = [SKAction animateWithTextures:self.cowWalkingFrames timePerFrame:0.3f];
    SKAction *moveLeftWithAnimation = [SKAction group:@[moveLeft, [SKAction repeatAction:animate count:12]]];
    SKAction *moveRight = [SKAction moveToX:884 duration:7];
    SKAction *moveRightWithAnimation = [SKAction group:@[moveRight, [SKAction repeatAction:animate count:12]]];
    SKAction *wait = [SKAction waitForDuration:1];
    SKAction *wiggleTailUp = [SKAction rotateByAngle:M_PI_4/4 duration:0.5];
    SKAction *wiggleTailDown = [SKAction rotateByAngle:-M_PI_4/4 duration:0.5];
    SKAction *wiggling = [SKAction repeatAction:[SKAction sequence:@[wiggleTailUp, wiggleTailDown]] count:17];
    SKAction *wiggleHeadUp = [SKAction rotateByAngle:M_PI_4/16 duration:0.7];
    SKAction *wiggleHeadDown = [SKAction rotateByAngle:-M_PI_4/16 duration:0.7];
    SKAction *wigglingHead = [SKAction repeatAction:[SKAction sequence:@[wiggleHeadDown, wiggleHeadUp]] count:13];
    SKAction *turnRight = [SKAction runBlock:^{
        self.cow.xScale = fabs(self.cow.xScale) *-1;
        
    }];
    SKAction *turnLeft = [SKAction runBlock:^{
        self.cow.xScale = fabs(self.cow.xScale) *1;
        
        
    }];
    [self.cowsHead runAction:wigglingHead];
    [self.cowTail runAction:wiggling];
    [self.cow runAction:[SKAction sequence:@[turnRight, moveRightWithAnimation, wait, turnLeft, wait, moveLeftWithAnimation, wait]]completion:^{
        
        self.touchingCow = NO;
    }];
}
-(void)setupFence{
    
    self.fence = [SKSpriteNode spriteNodeWithImageNamed:@"plotek2"];
    self.fence.position = CGPointMake(self.size.width-self.fence.size.width/2, 380);
    
    [self addChild:self.fence];
    
}
-(void)setupCowsHeadAnimation{
    self.touchingCow = YES;
    SKAction *rotate = [SKAction rotateByAngle:M_PI_4/4 duration:0.2];
    SKAction *reverseRotation = [rotate reversedAction];
    SKAction *wait = [SKAction waitForDuration:2];
    SKAction *cowMovementSequence = [SKAction sequence:@[rotate, wait, reverseRotation, wait]];
    
    
    SKTexture *cowsLookup = [SKTexture textureWithImageNamed:@"cow02"];
    SKAction *changeTexture = [SKAction setTexture:cowsLookup];
    SKAction *cowsHeadUp = [SKAction moveToY:120 duration:0.1];
    SKAction *wavingTail = [SKAction rotateByAngle:M_PI_4/4 duration:0.5];
    SKAction *wavingTailReversed = [wavingTail reversedAction];
    SKAction *wavingTailSequence = [SKAction sequence:@[wavingTail, wavingTailReversed, wait]];
    
    //SKAction *block = [SKAction runBlock:^{
    
    [self.cowTail runAction:[SKAction repeatActionForever:wavingTailSequence]];
    SKAction *rotateHeadUp = [SKAction rotateByAngle:-M_PI_4/4 duration:0.5];
    SKAction *rotateBack = [rotateHeadUp reversedAction];
    
    
    [self.cowsHead runAction:cowMovementSequence completion:^{
       SKAction *seqCow = [SKAction sequence:@[cowsHeadUp, wait, rotateHeadUp, rotateBack]];
        [self.cow runAction:changeTexture];
        //[self.cowsHead runAction:cowsHeadUp];
        [self.cowsHead runAction:seqCow  completion:^{
           
            
            [self.cowsHead runAction:[SKAction sequence:@[rotateHeadUp, rotateBack, wait]]];
            
            
            //cows coming down
            SKTexture *cowsLookdown = [SKTexture textureWithImageNamed:@"cow01"];
            SKAction *changeTexture3 = [SKAction setTexture:cowsLookdown];
            SKAction *cowsHeadDown = [SKAction moveToY:60 duration:0.1];
            
            [self.cow runAction:changeTexture3];
            [self.cowsHead runAction:cowsHeadDown];
            self.touchingCow = NO;
        }];
        
    }];
    //  [self.cow runAction:[SKAction repeatActionForever:block]];
    
}
-(void)setupWorm{
    self.wormActive = YES;
    CGFloat randomPosX;
    CGFloat randomPosY;
    randomPosX = arc4random() % 400 +50;
    randomPosY = arc4random() % 150 +200;
    _wormNode = [SKNode node];
    _worm = [[Worm alloc]initWormWithPosition:CGPointMake(randomPosX, randomPosY)]; //used to be 200, 300
    [_wormNode addChild:_worm];
    _wormNode.zPosition = 200;
    [self addChild:_wormNode];
    
    
}
-(void)setupBird{
    _birdNode = [SKNode node];
   _bird = [[Bird alloc] initBirdWithPosition:CGPointMake(self.size.width - 100, 440)];
    [_birdNode addChild:_bird];
    _birdNode.zPosition = 200;
    [self addChild:_birdNode];
   
    
}

-(void)setupTree{
    
    self.tree = [SKSpriteNode spriteNodeWithImageNamed:@"drzewoZielone"];
    self.tree.position = CGPointMake(self.size.width-100, self.tree.size.height/2);
    self.tree.zPosition = 100;
    [self addChild:self.tree];
    
}
-(void)setupCloud{
    
    self.cloud1 = [SKSpriteNode spriteNodeWithImageNamed:@"smallCloud"];
    self.cloud1.position = CGPointMake(900, 764);
    [self addChild:self.cloud1];
    
    self.cloud2 = [SKSpriteNode spriteNodeWithImageNamed:@"smallCloud"];
    self.cloud2.position = CGPointMake(100, self.size.height-self.cloud2.size.height/2);
    [self addChild:self.cloud2];

    
    self.cloud3 = [SKSpriteNode spriteNodeWithImageNamed:@"cloud"];
    self.cloud3.position = CGPointMake(400, 700);
    [self addChild:self.cloud3];

    
    self.cloud4 = [SKSpriteNode spriteNodeWithImageNamed:@"cloud"];
    self.cloud4.position = CGPointMake(600, self.size.height-self.cloud1.size.height/2);
    [self addChild:self.cloud4];
    
    self.cloud5 = [SKSpriteNode spriteNodeWithImageNamed:@"cloud"];
    self.cloud5.position = CGPointMake(1124, 764);
    [self addChild:self.cloud5];
    
    self.cloud6 = [SKSpriteNode spriteNodeWithImageNamed:@"cloud"];
    self.cloud6.position = CGPointMake(900, 720);
    [self addChild:self.cloud6];
    
    
    self.cloudMoving = [SKAction moveToX:-self.cloud1.size.width duration:30];
    self.cloudMoving.timingFunction = SKActionTimingLinear;
    [self.cloud1 runAction:self.cloudMoving completion:^{
        
        [self.cloud1 removeFromParent];
        self.cloud1.position  = CGPointMake(1124, 764);
        [self addChild:self.cloud1];
        
        
    }];
    
     
    
   // SKAction *cloudMoving2 = [SKAction moveToX:-self.size.width/2 duration:30];
    [self.cloud2 runAction:self.cloudMoving completion:^{
        
        [self.cloud2 removeFromParent];
        self.cloud2.position  = CGPointMake(1324, self.size.height-self.cloud2.size.height/2);
        [self addChild:self.cloud2];
        
        
    }];

    [self.cloud3 runAction:self.cloudMoving completion:^{
        
        [self.cloud3 removeFromParent];
        self.cloud3.position  = CGPointMake(1224, 700);
        [self addChild:self.cloud3];
        
        
    }];
    [self.cloud4 runAction:self.cloudMoving completion:^{
        
        [self.cloud4 removeFromParent];
        self.cloud4.position  = CGPointMake(1424, 680);
        [self addChild:self.cloud4];
        
        
    }];
    
    [self.cloud5 runAction:self.cloudMoving completion:^{
        
        //[self.cloud5 removeFromParent];
        self.cloud5.position  = CGPointMake(1424, 704);
       // [self addChild:self.cloud5];
        
        
    }];
    
    [self.cloud6 runAction:self.cloudMoving completion:^{
        
        
        self.cloud6.position  = CGPointMake(1424, 720);
        
        
        
    }];

    
}
-(void)setupCharacter{

    _bellBodyObject = [[BellBody alloc]initBellWithBodyandHeadInPosition2:CGPointMake(600, 200)];
    SKNode *bellNode = [SKNode node];
    [bellNode addChild:_bellBodyObject];
    bellNode.zPosition = 0;
    [self addChild:bellNode];
    
    

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
    
    [_bellBodyObject.bellsBody2 runAction:[SKAction group:@[wiggling, bouncing]]];
    [_bellBodyObject.bellsHead2 runAction:wigglingHead];

    if (self.wormActive) {
        [_flowerOne bounceFlowers];
    }
    
    
    
}

//-(void)setupCharacterAnimation{
//    
//    
//    
//   // [self.character runAction:[SKAction animateWithTextures:walkFrames timePerFrame:0.1f] withKey:@"walkingInPlaceCharacter"];
//    [self.character runAction:[SKAction repeatActionForever:
//                               [SKAction animateWithTextures:self.characterWalkingFrames
//                                       timePerFrame:0.1f
//                                             resize:NO
//                                            restore:YES]] withKey:@"walkingInPlaceCarillon"];
//   
//}
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
    if (self.backgroundMusicPlayer2.volume > 0.1) {
        self.backgroundMusicPlayer2.volume = self.backgroundMusicPlayer2.volume - 0.1;
        [self performSelector:@selector(fadeOutTheMusic) withObject:nil afterDelay:0.1];
        if (self.backgroundMusicPlayer2 == 0) {
        }
    } else {
        // Stop and get the sound ready for playing again
        [self.backgroundMusicPlayer2 stop];
        self.backgroundMusicPlayer2.currentTime = 0;
        [self.backgroundMusicPlayer2 prepareToPlay];
        self.backgroundMusicPlayer2.volume = 1.0;
    }
}
-(void)setupChimneyEmitterEffect{
    
    self.chimneyFlame = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"chimneyFlame" ofType: @"sks"]];
    self.chimneyFlame.position = CGPointMake(190,670);
    [self addChild:self.chimneyFlame];
    
    self.chimneyFlame2 = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"chimneyFlame" ofType: @"sks"]];
    self.chimneyFlame2.position = CGPointMake(335,640);
    [self addChild:self.chimneyFlame2];
    
    self.chimneyFlame3 = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"chimneyFlame" ofType: @"sks"]];
    self.chimneyFlame3.position = CGPointMake(820,670);
    [self addChild:self.chimneyFlame3];
    
}
-(void)handleFlower:(SKSpriteNode *)sprite inLocation:(CGPoint)location{
  
        
  
    if ([sprite containsPoint:location]){
        self.originalPosition = sprite.position;
        
        sprite.zPosition = 400;
        sprite.xScale = 0.7;
        sprite.yScale = 0.7;
        self.touchingPoint = location;
        if ([sprite.name isEqualToString:@"flowerOne"]) {
            [self setupQueAnimationForSprite:sprite.name inLocation:_flowerOne.flowerOneDestinationLocation];
            self.touchingFlowerOne = YES;
            }
        if ([sprite.name isEqualToString:@"flowerTwo"]) {
            [self setupQueAnimationForSprite:sprite.name inLocation:_flowerOne.flowerTwoDestinationLocation];
            self.touchingFlowerTwo = YES;
        }
        if ([sprite.name isEqualToString:@"flowerThree"]) {
            [self setupQueAnimationForSprite:sprite.name inLocation:_flowerOne.flowerThreeDestinationLocation];
            self.touchingFlowerThree = YES;
        }
        if ([sprite.name isEqualToString:@"flowerFour"]) {
            [self setupQueAnimationForSprite:sprite.name inLocation:_flowerOne.flowerFourDestinationLocation];
            self.touchingFlowerFour = YES;
        }
        if ([sprite.name isEqualToString:@"flowerFive"]) {
            [self setupQueAnimationForSprite:sprite.name inLocation:_flowerOne.flowerFiveDestinationLocation];
            self.touchingFlowerFive = YES;
        }
        if ([sprite.name isEqualToString:@"flowerSix"]) {
            [self setupQueAnimationForSprite:sprite.name inLocation:_flowerOne.flowerSixDestinationLocation];
            self.touchingFlowerSix = YES;
        }
        
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  
    for (UITouch *touch in touches)
    {
       
        CGPoint location = [touch locationInNode:self];
        
        [_bellBodyObject moveHeadTowards2:location];

        if ([self.arrow containsPoint:location]) {
            
            SKView * skView = (SKView *)self.view;
            skView.showsFPS = NO;
            skView.showsNodeCount = NO;
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = YES;
            [self fadeOutTheMusic];
            // Create and configure the scene.
            SKScene *gameScene5 = [[GameScene5 alloc]initWithSize:self.size];
            gameScene5.scaleMode = SKSceneScaleModeAspectFill;
           // [self fadeOutTheMusic];
            [[SKTAudio sharedInstance]pauseSoundEffect];
            [[SKTAudio sharedInstance]pauseSoundEffectInaLoop];
            [[SKTAudio sharedInstance]pauseBackgroundMusic];
            SKTransition *transition = [SKTransition fadeWithColor:[UIColor blackColor] duration:3];
            // Present the scene.
            [self.view presentScene:gameScene5 transition:transition];
            
            
            
        }
        if ([self.squirrel containsPoint:location] && self.squirrelTouchesActive){
            [self animateTheSquirrelHappiness];
            [[SKTAudio sharedInstance]playSoundEffect:@"SFXRadoscWiewiorki.mp3"];
        }
        if (self.flowerOneActive && !self.nutsActive) {
            [self handleFlower:_flowerOne.flowerOne inLocation:location];
        }
        if (self.flowerTwoActive && !self.nutsActive) {
            [self handleFlower:_flowerOne.flowerTwo inLocation:location];
        }
        if (self.flowerThreeActive && !self.nutsActive) {
            [self handleFlower:_flowerOne.flowerThree inLocation:location];
        }
        if (self.flowerFourActive && !self.nutsActive) {
            [self handleFlower:_flowerOne.flowerFour inLocation:location];
        }
        if (self.flowerFiveActive && !self.nutsActive) {
            [self handleFlower:_flowerOne.flowerFive inLocation:location];
        }
        if (self.flowerSixActive && !self.nutsActive) {
            [self handleFlower:_flowerOne.flowerSix inLocation:location];
        }

        
        self.littleSparkEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"LittleSpark" ofType:@"sks"]];
        self.littleSparkEmitter.zPosition = 100;
        self.littleSparkEmitter.position = location;
        
        [self addChild:self.littleSparkEmitter];
        
        if   ([self.soundIcon containsPoint:location]){
            
            [self showSoundButtonForTogglePosition:self.musicOn];
        }
        
        if ([self.nuts containsPoint:location] && self.nutsTouchesActive) {
            self.originalPosition = self.nuts.position;
            self.touchingNuts = YES;
            self.nuts.zPosition = 400;
            self.nuts.xScale = 1.4;
            self.nuts.yScale = 1.4;
            self.touchingPoint = location;
        }
        
        if ([self.nuts2 containsPoint:location] && self.nutsTouchesActive) {
            self.originalPosition = self.nuts2.position;
            self.touchingNuts2 = YES;
            self.nuts2.zPosition = 400;
            self.nuts2.xScale = 1.4;
            self.nuts2.yScale = 1.4;
            self.touchingPoint = location;
        }
        if ([self.nuts3 containsPoint:location] && self.nutsTouchesActive) {
            self.originalPosition = self.nuts3.position;
            self.touchingNuts3 = YES;
            self.nuts3.zPosition = 400;
            self.nuts3.xScale = 1.4;
            self.nuts3.yScale = 1.4;
            self.touchingPoint = location;
        }
        

        if([self.cow containsPoint:location] && !self.touchingCow)
        {
            [self.cow runAction:[SKAction playSoundFileNamed:@"Krowa SFX.mp3" waitForCompletion:NO]];
            self.touchingCow = YES;
            [self moveCow];
        }
        
        if ([_bird.birdBody containsPoint:location]) {
          // [_birdNode runAction:[SKAction playSoundFileNamed:@"birdSinging.mp3" waitForCompletion:NO]];
            [[SKTAudio sharedInstance]playSoundEffect:@"birdSinging.mp3"];
            [_bird setupBirdAnimation];

        }
        if ([_worm.worm containsPoint:location] && self.wormActive) {
            [_worm hideTheWorm];
            [[SKTAudio sharedInstance]playSoundEffect:@"SFXRobaczek.mp3"];
            [self setupWorm];
            [_worm setupWormAnimation];
            self.wormCounter++;
            
        }
        if ([_baloon.baloon containsPoint:location]) {
            [_baloon killTheBaloon];
        }
        
        if ([_bellBodyObject.bellsBody2 containsPoint:location] || [_bellBodyObject.bellsHead2 containsPoint:location]) {
            [self bellRandomNoises];
            
        }

    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint currentPoint = [[touches anyObject]locationInNode:self];

    
    if (self.touchingFlowerOne) {
        if ([self isWithinTheQueFlower:self.queFlower1 inLocation:currentPoint]) {
            self.touchingFlowerOne = NO;
            _flowerOne.flowerOne.position = _flowerOne.flowerOneDestinationLocation;
            _flowerOne.flowerOne.xScale = 0.5;
            _flowerOne.flowerOne.yScale = 0.5;
            [self setupBigSparkEmiter:currentPoint];
            self.flowerOneActive = NO;
        }else{
            [self animatePuttingThingsBack:_flowerOne.flowerOne];
            self.touchingFlowerOne = NO;
            [self.queFlower1 removeFromParent];
        }
    }
    if (self.touchingFlowerTwo) {
        if ([self isWithinTheQueFlower:self.queFlower2 inLocation:currentPoint]) {
            self.touchingFlowerTwo = NO;
            _flowerOne.flowerTwo.position = _flowerOne.flowerTwoDestinationLocation;
            _flowerOne.flowerTwo.xScale = 0.5;
            _flowerOne.flowerTwo.yScale = 0.5;
            [self setupBigSparkEmiter:currentPoint];
            self.flowerTwoActive = NO;
        }else{
            [self animatePuttingThingsBack:_flowerOne.flowerTwo];
            self.touchingFlowerTwo = NO;
            [self.queFlower2 removeFromParent];
        }
    }
    if (self.touchingFlowerThree) {
        if ([self isWithinTheQueFlower:self.queFlower3 inLocation:currentPoint]) {
            self.touchingFlowerThree = NO;
            _flowerOne.flowerThree.position = _flowerOne.flowerThreeDestinationLocation;
            _flowerOne.flowerThree.xScale = 0.5;
            _flowerOne.flowerThree.yScale = 0.5;
            [self setupBigSparkEmiter:currentPoint];
            self.flowerThreeActive = NO;
        }else{
            [self animatePuttingThingsBack:_flowerOne.flowerThree];
            self.touchingFlowerThree = NO;
            [self.queFlower3 removeFromParent];
        }
    }
    if (self.touchingFlowerFour) {
        if ([self isWithinTheQueFlower:self.queFlower4 inLocation:currentPoint]) {
            self.touchingFlowerFour = NO;
            _flowerOne.flowerFour.position = _flowerOne.flowerFourDestinationLocation;
            _flowerOne.flowerFour.xScale = 0.5;
            _flowerOne.flowerFour.yScale = 0.5;
            [self setupBigSparkEmiter:currentPoint];
            self.flowerFourActive = NO;
        }else{
            [self animatePuttingThingsBack:_flowerOne.flowerFour];
            self.touchingFlowerFour = NO;
            [self.queFlower4 removeFromParent];
        }
    }
    if (self.touchingFlowerFive) {
        if ([self isWithinTheQueFlower:self.queFlower5 inLocation:currentPoint]) {
            self.touchingFlowerFive = NO;
            _flowerOne.flowerFive.position = _flowerOne.flowerFiveDestinationLocation;
            _flowerOne.flowerFive.xScale = 0.5;
            _flowerOne.flowerFive.yScale = 0.5;
            [self setupBigSparkEmiter:currentPoint];
            self.flowerFiveActive = NO;
        }else{
            [self animatePuttingThingsBack:_flowerOne.flowerFive];
            self.touchingFlowerFive = NO;
            [self.queFlower5 removeFromParent];
        }
    }
    if (self.touchingFlowerSix) {
        if ([self isWithinTheQueFlower:self.queFlower6 inLocation:currentPoint]) {
            self.touchingFlowerSix = NO;
            _flowerOne.flowerSix.position = _flowerOne.flowerSixDestinationLocation;
            _flowerOne.flowerSix.xScale = 0.5;
            _flowerOne.flowerSix.yScale = 0.5;
            [self setupBigSparkEmiter:currentPoint];
            self.flowerSixActive = NO;
        }else{
            [self animatePuttingThingsBack:_flowerOne.flowerSix];
            self.touchingFlowerSix = NO;
            [self.queFlower6 removeFromParent];
        }
    }
    
    if (self.touchingNuts && self.nut1Active ) {

        if ([self isWithinTheSquirrel:currentPoint]&& self.squirrelTouchesActive) {
            self.touchingNuts = NO;
            self.nut1Active = NO;
            [self.nuts removeAllActions];
            [self.nuts removeFromParent];
            [self animateTheSquirrelHappiness];
            [self setupBigSparkEmiter:currentPoint];
            
            }else{
                [self removeActionWithAlpha:self.nuts];
            [self animatePuttingThingsBack:self.nuts];
            self.touchingNuts = NO;
        }
       

    }
    if (self.touchingNuts2 && self.nut2Active) {
        
        if ([self isWithinTheSquirrel:currentPoint]&& self.squirrelTouchesActive) {
            self.touchingNuts2 = NO;
            self.nut2Active = NO;
            [self.nuts2 removeFromParent];
            [self animateTheSquirrelHappiness];
            [self setupBigSparkEmiter:currentPoint];
        }else{
            [self removeActionWithAlpha:self.nuts2];
            [self animatePuttingThingsBack:self.nuts2];
             self.touchingNuts2 = NO;
        }
       

    }
    if (self.touchingNuts3 && self.nut3Active) {
        
        if ([self isWithinTheSquirrel:currentPoint] && self.squirrelTouchesActive) {
            self.touchingNuts3 = NO;
            self.nut3Active = NO;
            [self.nuts3 removeFromParent];
            [self animateTheSquirrelHappiness];
            [self setupBigSparkEmiter:currentPoint];
        }else{
            [self removeActionWithAlpha:self.nuts3];
            [self animatePuttingThingsBack:self.nuts3];
             self.touchingNuts3 = NO;
        }
       

    }
    

    //[self walkingCarillon:location];
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
   
    self.touchingPoint = [[touches anyObject] locationInNode:self];

}
-(void)animateTheSquirrelHappiness{
    
    self.squirrelTouchesActive = NO;
    
    SKAction *rotateBack = [SKAction rotateByAngle:M_PI *2 duration:2];
    SKAction *moveUp = [SKAction moveByX:0 y:50 duration:2];
    SKAction *moveDown = [SKAction moveByX:0 y:-50 duration:0.5];
    SKAction *seq = [SKAction sequence:@[moveUp, moveDown]];
    SKAction *groupMove = [SKAction group:@[rotateBack, seq]];
    
    [self.squirrel runAction:groupMove completion:^{
        
        self.squirrelTouchesActive = YES;
    }];
}
-(BOOL)isItNuts:(SKSpriteNode *)node{
    if (node == _nuts || node == _nuts2 || node == _nuts3 ) {
        return YES;
    }
    return NO;
}
-(void)animatePuttingThingsBack:(SKSpriteNode *)node
{
    SKAction *scaleDown = [SKAction scaleTo:0.5 duration:1];

    if ([self isItNuts:node]) {
        scaleDown = [SKAction scaleTo:1 duration:0.5];
        self.nutsTouchesActive = NO;
    }
    
    
        SKAction *moveLeft = [SKAction moveByX:-10 y:0 duration:0.2];
        SKAction *moveRight = [SKAction moveByX:10 y:0 duration:0.2];
        
        SKAction *fastMovementSeq = [SKAction repeatAction:[SKAction sequence:@[moveLeft, moveRight]] count:4];
        SKAction *moveBack = [SKAction moveTo:self.originalPosition duration: 1];
        SKAction *rotateBack = [SKAction rotateByAngle:M_PI *2 duration:0.5];
        SKAction *group = [SKAction group:@[moveBack, rotateBack]];
        ;
        
        SKAction *seq =[SKAction group: @[scaleDown, fastMovementSeq, group]];
        [node runAction:seq completion:^{
            
            self.nutsTouchesActive = YES;
        }];
    
    
}

-(void)setupBigSparkEmiter:(CGPoint)coordinates{
    self.nutsCounter++;
    self.bigSparkEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"BigSpark" ofType:@"sks"]];
    self.bigSparkEmitter.zPosition = 500;
    self.bigSparkEmitter.position = coordinates;
    
    [self addChild:self.bigSparkEmitter];
}


-(void)checkClouds{

    
    if (self.cloud1.position.x == 1124){
        
        
        [self.cloud1 runAction:self.cloudMoving completion:^{
            
            [self.cloud1 removeFromParent];
            self.cloud1.position  = CGPointMake(1124, 764);
            [self addChild:self.cloud1];
        }];
    }
    
    if (self.cloud2.position.x == 1324){
        
        
        [self.cloud2 runAction:self.cloudMoving completion:^{
            
            [self.cloud2 removeFromParent];
            self.cloud2.position  = CGPointMake(1324, self.size.height-self.cloud2.size.height/2);
            [self addChild:self.cloud2];
        }];
    }
    if (self.cloud3.position.x == 1224){
        
        
        [self.cloud3 runAction:self.cloudMoving completion:^{
            
            [self.cloud3 removeFromParent];
            self.cloud3.position  = CGPointMake(1224, 700);
            [self addChild:self.cloud3];
        }];
    }
    if (self.cloud4.position.x == 1424){
        
        
        [self.cloud4 runAction:self.cloudMoving completion:^{
            
            [self.cloud4 removeFromParent];
            self.cloud4.position  = CGPointMake(1424, 680);
            [self addChild:self.cloud4];
        }];
    }
    if (self.cloud5.position.x < 600){
        
        self.fadeOut = [SKAction fadeAlphaTo:0.0 duration:5];
        self.fadeIn = [SKAction fadeAlphaTo:1.0 duration:2];

        [self.cloud5 runAction:self.fadeOut completion:^{
            
            self.cloud5.position = CGPointMake(1124, 704);
            
            [self.cloud5 runAction: [SKAction group:@[self.fadeIn, self.cloudMoving]]];
                                     
        }];
        
    }
    
    if (self.cloud6.position.x < 700){
        
        self.fadeOut = [SKAction fadeAlphaTo:0.0 duration:5];
        self.fadeIn = [SKAction fadeAlphaTo:1.0 duration:2];
        
        [self.cloud6 runAction:self.fadeOut completion:^{
            
            self.cloud6.position = CGPointMake(1024, 720);
            
            [self.cloud6 runAction: [SKAction group:@[self.fadeIn, self.cloudMoving]]];
            
        }];
    
    }
    

}
-(void)runWormBlock{
    SKAction *wait = [SKAction waitForDuration:10];
    SKAction *block = [SKAction runBlock:^{
        
        [self setupWorm];
        [_worm setupWormAnimation];
        
    }];
    [self runAction:[SKAction sequence:@[wait, block]]];

}
//- (void)rotateSpriteToFace:(CGPoint)velocity
//       rotateRadiansPerSec:(CGFloat)rotateRadiansPerSec
//{
//    float targetAngle = CGPointToAngle(velocity);
//    float shortest = ScalarShortestAngleBetween(_bellBodyObject.bellsHead2.zRotation, targetAngle);
//    float amtToRotate = rotateRadiansPerSec * _dt;
//    if (ABS(shortest) < amtToRotate) {
//        amtToRotate = ABS(shortest);
//    }
//   _bellBodyObject.bellsHead2.zRotation += ScalarSign(shortest) * amtToRotate;
//}
-(void)bellRandomNoises{
    
    switch (arc4random()%3+1) {
        case 1:
        {
            [[SKTAudio sharedInstance]playSoundEffect:@"SFXBellHi.mp3"];
            SKAction *wiggleHeadUp = [SKAction rotateByAngle:M_PI_4/8 duration:0.2];
            SKAction *wiggleHeadDown = [SKAction rotateByAngle:-M_PI_4/8 duration:0.2];
            SKAction *wigglingHead = [SKAction repeatAction:[SKAction sequence:@[wiggleHeadDown, wiggleHeadUp]] count:5];
            
            [_bellBodyObject.bellsHead2 runAction:[SKAction group:@[wigglingHead]]];
        }
            break;
        case 2:{
            [[SKTAudio sharedInstance]playSoundEffect:@"SFXBellMm.mp3"];
            SKAction *wiggleHeadUp = [SKAction rotateByAngle:M_PI_4/8 duration:0.2];
            SKAction *wiggleHeadDown = [SKAction rotateByAngle:-M_PI_4/8 duration:0.2];
            SKAction *wigglingHead = [SKAction repeatAction:[SKAction sequence:@[wiggleHeadDown, wiggleHeadUp]] count:5];
            
            [_bellBodyObject.bellsHead2 runAction:[SKAction group:@[wigglingHead]]];
        }
            break;
        case 3:{
            [[SKTAudio sharedInstance]playSoundEffect:@"SFXOoBell.mp3"];
            SKAction *wiggleHeadUp = [SKAction rotateByAngle:M_PI_4/8 duration:0.2];
            SKAction *wiggleHeadDown = [SKAction rotateByAngle:-M_PI_4/8 duration:0.2];
            SKAction *wigglingHead = [SKAction repeatAction:[SKAction sequence:@[wiggleHeadDown, wiggleHeadUp]] count:5];
            
            [_bellBodyObject.bellsHead2 runAction:[SKAction group:@[wigglingHead]]];
        }
            break;
        default:
            break;
    }
    
}

-(void)update:(NSTimeInterval)currentTime{
    
    [self checkClouds];
    
    if (self.touchingNuts) {
        self.nuts.position = self.touchingPoint;
    }
    if (self.touchingNuts2) {
        self.nuts2.position = self.touchingPoint;
    }
    if (self.touchingNuts3) {
        self.nuts3.position = self.touchingPoint;
    }
    
  
    if (self.nutsActive && self.nutsCounter == 3) {
        self.nutsActive = NO;
         [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarThree];
        [self setupCharacterHappyAnimation];

        [_flowerOne unhideTheFlowers];
        
    }
    if (self.touchingFlowerOne && self.flowerOneActive) {
        _flowerOne.flowerOne.position = self.touchingPoint;
    }
    if (self.touchingFlowerTwo && self.flowerTwoActive) {
        _flowerOne.flowerTwo.position = self.touchingPoint;
    }
    if (self.touchingFlowerThree && self.flowerThreeActive) {
        _flowerOne.flowerThree.position = self.touchingPoint;
    }
    if (self.touchingFlowerFour && self.flowerFourActive) {
        _flowerOne.flowerFour.position = self.touchingPoint;
    }
    if (self.touchingFlowerFive && self.flowerFiveActive) {
        _flowerOne.flowerFive.position = self.touchingPoint;
    }
    if (self.touchingFlowerSix && self.flowerSixActive) {
        _flowerOne.flowerSix.position = self.touchingPoint;
    }
    
    if (!self.flowerOneActive && !self.flowerTwoActive && !self.flowerThreeActive && !self.flowerFourActive && !self.flowerFiveActive && !self.flowerSixActive && !self.flowerAnimationActive) {
        [_flowerOne loadAllFlowersAnimations];
       
        SKAction *wait = [SKAction waitForDuration:4];
        [self runAction:wait completion:^{
            
            [_stickerOne runStickerAnimation:_stickerOne.stickerStarOne];
        }];
        [[SKTAudio sharedInstance]playSoundEffect:@"SFXKwiaty 2.mp3"];
        self.flowerAnimationActive = YES;
        [self.queFlower1 removeFromParent];
        [self.queFlower2 removeFromParent];
        [self.queFlower3 removeFromParent];
        [self.queFlower4 removeFromParent];
        [self.queFlower5 removeFromParent];
        [self.queFlower6 removeFromParent];
        [self setupCharacterHappyAnimation];

        [self runWormBlock];
        
}
    if (self.wormActive && self.wormCounter == 7) {
        [_stickerOne runStickerAnimation:_stickerOne.stickerStarTwo];
        [_worm.worm removeFromParent];
        [self setupCharacterHappyAnimation];

        self.wormActive = NO;
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
