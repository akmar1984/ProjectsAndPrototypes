//
//  GameScene3.m
//  gierka
//
//  Created by Marek Tomaszewski on 28/11/2014.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "GameScene3.h"
#import "WardrobeScene.h"
#import "Stickers.h"
#import "BellBody.h"
#import "SKTUtils.h"
#import "GameViewController.h"
#import "SKTAudio.h"

typedef NS_ENUM(uint32_t, LBGameState){
    LBGameStateKitchen,
    LBGameStateCupboard,
    
};
@import AVFoundation;
@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end
@interface GameScene3 ()

@property (nonatomic)SKSpriteNode *background;
@property (nonatomic)SKSpriteNode *cupboardBackground;

@property (nonatomic)SKSpriteNode *cat;
@property BOOL catTouchesActive;


@property (nonatomic)SKSpriteNode *kitchenOvens;
@property (nonatomic)SKSpriteNode *cupboard;
@property (nonatomic)SKSpriteNode *fullScreenCupboard;
@property (nonatomic)SKSpriteNode *exitButton;
@property (nonatomic)SKSpriteNode *carillon;
@property (nonatomic)SKSpriteNode *cloud1;
@property (nonatomic)SKSpriteNode *cloud2;
@property (nonatomic)SKSpriteNode *cloud3;
@property (nonatomic)NSArray *catWalkingFrames;
@property (nonatomic)SKSpriteNode *character;

@property (nonatomic)SKSpriteNode *redCupSide1;
@property (nonatomic)SKSpriteNode *redCupSide2;

@property (nonatomic)SKSpriteNode *blueCupSide1;
@property (nonatomic)SKSpriteNode *blueCupSide2;

@property (nonatomic)SKSpriteNode *yellowCupSide1;
@property (nonatomic)SKSpriteNode *yellowCupSide2;
@property SKSpriteNode *soundIcon;
@property SKSpriteNode *arrow;
@property SKSpriteNode *queCup;
@property (nonatomic)SKSpriteNode *vase;

@property (nonatomic)SKSpriteNode *banana;
@property (nonatomic)SKSpriteNode *cake;
@property (nonatomic)SKSpriteNode *apple;
@property (nonatomic)SKSpriteNode *bread;
@property (nonatomic)SKSpriteNode *milkBottle;

@property BOOL breadActive;
@property BOOL cakeActive;
@property BOOL appleActive;
@property BOOL milkBottleActive;
@property BOOL bananaActive;

@property (nonatomic)SKSpriteNode *eatenBread;
@property (nonatomic)SKSpriteNode *eatenCake;
@property (nonatomic)SKSpriteNode *eatenApple;
@property (nonatomic)SKSpriteNode *eatenBanana;

@property BOOL eatenBreadActive;
@property BOOL eatenCakeActive;
@property BOOL eatenAppleActive;
@property BOOL eatenBananaActive;

@property (nonatomic)SKSpriteNode *redCup;
@property (nonatomic)SKSpriteNode *yellowCup;
@property (nonatomic)SKSpriteNode *blueCup;

@property (nonatomic)SKSpriteNode *chair;

@property (nonatomic)SKSpriteNode *kitchenWindow;
@property (nonatomic)SKSpriteNode *windowFrame;

@property (nonatomic)SKSpriteNode *windowBackground;
@property (nonatomic)SKSpriteNode *fridge;
@property (nonatomic)SKSpriteNode *table;
@property (nonatomic)SKSpriteNode *flower;
@property (nonatomic)SKSpriteNode *bin;
@property (nonatomic)SKSpriteNode *catBowl;
@property (nonatomic)SKSpriteNode *catHead;
@property (nonatomic)SKTexture *catTexture;
@property (nonatomic)SKSpriteNode *lunchbox;
@property (nonatomic)SKEmitterNode *littleSparkEmitter;
@property (nonatomic)SKEmitterNode *bigSparkEmitter;
@property (nonatomic) CGPoint redCupSide1OriginalLocation;
@property (nonatomic) CGPoint blueCupSide1OriginalLocation;
@property (nonatomic) CGPoint yellowCupSide1OriginalLocation;

@property (nonatomic) CGPoint redCupSide2OriginalLocation;
@property (nonatomic) CGPoint blueCupSide2OriginalLocation;
@property (nonatomic) CGPoint yellowCupSide2OriginalLocation;


@property (nonatomic) BOOL touchingFridge;
@property (nonatomic) BOOL cupboardSwitch;
@property (nonatomic) CGPoint touchingPoint;
@property (nonatomic) CGPoint cupOriginalLocation;

@property SKShapeNode *footer;

@property (nonatomic)BOOL touchingRedCupSide1;
@property (nonatomic)BOOL touchingBlueCupSide1;
@property (nonatomic)BOOL touchingYellowCupSide1;

@property (nonatomic)BOOL touchingRedCupSide2;
@property (nonatomic)BOOL touchingBlueCupSide2;
@property (nonatomic)BOOL touchingYellowCupSide2;


@property (nonatomic)BOOL redCupSide1Active;
@property (nonatomic)BOOL redCupSide2Active;
@property (nonatomic)BOOL blueCupSide1Active;
@property (nonatomic)BOOL blueCupSide2Active;
@property (nonatomic)BOOL yellowCupSide1Active;
@property (nonatomic)BOOL yellowCupSide2Active;
@property (nonatomic)BOOL cupTouchesActive;


@property (nonatomic)BOOL touchingBanana;
@property (nonatomic)BOOL touchingApple;
@property (nonatomic)BOOL touchingCake;
@property (nonatomic)BOOL touchingBread;
@property (nonatomic)BOOL touchingBottleOfMilk;


@property (nonatomic)BOOL touchingEatenBread;
@property (nonatomic)BOOL touchingEatenBanana;
@property (nonatomic)BOOL touchingEatenApple;
@property (nonatomic)BOOL touchingEatenCake;

@property (nonatomic)BOOL foodTouchesActive;


@property (nonatomic)BOOL bowlFull;
@property (nonatomic)BOOL stickerAnimationActive;


@property (nonatomic)BOOL binActive;
@property (nonatomic)BOOL foodActive;
@property BOOL arrowActive;


@property (nonatomic)BOOL touchingCharacter;


@property BOOL musicOn;

@property (nonatomic) CGPoint originalPosition;

@property (nonatomic) BellBody *bellBodyObject;
@property (nonatomic) Stickers *stickerOne;
@property (nonatomic) SKNode *stickerOneNode;
@property (assign) CGFloat foodCounter;
@property (assign) CGFloat foodWasteCounter;
@property (assign) CGFloat yellowCupCounter;
@property (assign) CGFloat redCupCounter;
@property (assign) CGFloat blueCupCounter;
@property (assign) CGFloat multiplierForDirection;
@property BOOL yellowCupCounterActive;
@property BOOL redCupCounterActive;
@property BOOL blueCupCounterActive;



@end

@implementation GameScene3{
    LBGameState _gameState;
}

static const CGFloat CupOffsetLeftOffset = 170;
static const CGFloat FirstRow = 534;
static const CGFloat SecondRow = 340;
static const CGFloat ThirdRow = 170;
static const CGFloat RightSideCupBoard = 642;
static const CGFloat MiddleSideCupBoard = RightSideCupBoard - 125;
static const CGFloat LeftSideCupBoard = 392;
static const int BODY_OFFSET = 100;


-(void)didMoveToView:(SKView *)view {
    
    [self setupLevel3];
    [self drawHintinLocation:self.cupboard afterDelay:0];
    
    
}


-(void)setupLevel3{
    self.musicOn = YES;
    
    
    [[SKTAudio sharedInstance] playBackgroundMusic:@"LittleBellKitchenMastered.mp3"];
    //    [self playBackgroundMusic:@"KitchenMusic.mp3"];
    //    [self.backgroundMusicPlayer play];
    [self setupBackground];
    [self setupCatWithBowl];
    [self setupKitchenOvens];
    [self setupArrow];
    [self setupKitchenWindow];
    [self setupTheFridge];
    [self setupTheCupboard];
    [self setupChair];
    [self setupBin];
    [self setupTable];
    [self setupCharacter];
    [self setupLunchbox];
    //[self setupFooter];
    [self setupSoundIcon];
    self.stickerOneNode = [SKNode node];
    self.stickerOne = [[Stickers alloc]initStickerWithPosition:CGPointMake(0, 768)andStickerFormsPosition:CGPointMake(130, 50)];
    [self.stickerOneNode addChild:self.stickerOne];
    [self addChild:self.stickerOneNode];
    
    _gameState = LBGameStateKitchen;
    
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

-(void)setupBackground{
    self.background = [SKSpriteNode spriteNodeWithImageNamed:@"kuchniaTlo"];
    self.background.anchorPoint = CGPointZero;
    self.background.zPosition = -2;
    [self addChild:self.background];
    
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
-(void)setupCharacter{
    
    //    NSMutableArray *walkFrames = [NSMutableArray array];
    //
    //    SKTextureAtlas *characterAnimatedAtlas = [SKTextureAtlas atlasNamed:@"postacStojaca"];
    //    NSInteger numImages = characterAnimatedAtlas.textureNames.count;
    //
    //    for (int i = 1; i<=numImages/2; i++) {
    //        NSString *textureName = [NSString stringWithFormat:@"postacStojaca0%i.png",i];
    //        SKTexture *temp = [characterAnimatedAtlas textureNamed:textureName];
    //        [walkFrames addObject:temp];
    //    }
    //    self.characterWalkingFrames = walkFrames;
    
    _bellBodyObject = [[BellBody alloc]initBellWithBodyandHeadInPosition:CGPointMake(270, 200)];
    SKNode *bellNode = [SKNode node];
    [bellNode addChild:_bellBodyObject];
    bellNode.zPosition = 0;
    [self addChild:bellNode];
    
}

-(void)setupCatWithBowl{
    
    NSMutableArray *walkFrames = [NSMutableArray array];
    
    // SKTextureAtlas *catAnimatedAtlas = [SKTextureAtlas atlasNamed:@"cat"];
    //  NSInteger numImages = catAnimatedAtlas.textureNames.count;
    
    //        for (int i = 1; i<=numImages/2; i++) {
    //            NSString *textureName = [NSString stringWithFormat:@"kot body%i.png",i];
    //            SKTexture *temp = [catAnimatedAtlas textureNamed:textureName];
    //            [walkFrames addObject:temp];
    //        }
    
    [walkFrames addObject:[SKTexture textureWithImageNamed:@"kot body1"]];
    [walkFrames addObject:[SKTexture textureWithImageNamed:@"kot body2"]];
    [walkFrames addObject:[SKTexture textureWithImageNamed:@"kot body3"]];
    
    self.catWalkingFrames = walkFrames;
    SKTexture *temp = self.catWalkingFrames[0];
    self.cat = [SKSpriteNode spriteNodeWithTexture:temp];
    self.catTouchesActive = YES;
    self.cat.position = CGPointMake(self.size.width - self.cat.size.width, 180);
    self.cat.zPosition = 3;
    [self addChild:self.cat];
    self.catHead = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"kot glowa"]];
    [self.cat addChild:self.catHead];
    self.catHead.zPosition = 100;
    self.catHead.position = CGPointMake(-50, 0);
    //    [self.cat runAction:[SKAction animateWithTextures:walkFrames timePerFrame:0.1f] withKey:@"walkingInPlaceCharacter"];
    SKAction *repeatBlock = [SKAction runBlock:^{
        [self moveCat];
        
    }];
    SKAction *wait = [SKAction waitForDuration:11];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[repeatBlock, wait]]]withKey:@"catForeverLoop"];
    
    
    //    [self.cat runAction:[SKAction repeatActionForever:
    //                              [SKAction animateWithTextures:self.catWalkingFrames
    //                                               timePerFrame:0.1f
    //                                                     resize:NO
    //                                                    restore:YES]] withKey:@"walkingInPlaceCarillon"];
    
    
    self.catBowl = [SKSpriteNode spriteNodeWithImageNamed:@"micha"];
    self.catBowl.position = CGPointMake(self.cat.position.x - self.catBowl.size.width, 150);
    self.bowlFull = NO;
    
    
    [self addChild:self.catBowl];
}
-(void)setupCatHeadAnimation{
    
    SKAction *wiggleHeadUp = [SKAction rotateByAngle:M_PI_4/16 duration:0.7];
    SKAction *wiggleHeadDown = [SKAction rotateByAngle:-M_PI_4/16 duration:0.7];
    SKAction *wigglingHead = [SKAction repeatAction:[SKAction sequence:@[wiggleHeadDown, wiggleHeadUp]] count:13];
    SKAction *wait = [SKAction waitForDuration:2];
    SKAction *seq =  [SKAction sequence:@[wigglingHead, wait]];
    [self.cat runAction:[SKAction repeatActionForever:seq]];
    
    
}
-(void)catDrinksMilk{
    //turn cat towards bowl
    
    
    if (self.cat.position.x > self.catBowl.position.x+self.cat.size.width/2) {
        self.cat.xScale = fabs(self.cat.xScale) *1;
        self.catTexture = [SKTexture textureWithImageNamed:@"kot glowaJezykPrawo"];
    }else if (self.cat.position.x < self.catBowl.position.x+self.cat.size.width/2) {
        self.cat.xScale = fabs(self.cat.xScale) *-1;
        self.catTexture = [SKTexture textureWithImageNamed:@"kot glowaJezyk"];
    }
    // catHead.position = CGPointMake(-50, 0);
    
    if (self.cat.position.x < self.catBowl.position.x) {
        SKAction *moveCatTowardsBowl = [SKAction moveToX:self.catBowl.position.x - self.cat.size.width/2 duration:2];
        SKAction *animate = [SKAction animateWithTextures:self.catWalkingFrames timePerFrame:0.1f];
        
        [self.cat runAction:[SKAction group:@[moveCatTowardsBowl, [SKAction repeatAction:animate count:10]]]];
    }
    
    SKAction *moveHeadDown = [SKAction moveToY:-10 duration:2];
    SKAction *moveHeadBackUp = [SKAction moveToY:0 duration:2];
    
    SKAction *setCatTexture = [SKAction setTexture:self.catTexture];
    SKAction *block = [SKAction runBlock:^{
        
        [self setupCatHeadAnimation];
    }];
    [self.catHead runAction:[SKAction sequence:@[setCatTexture, moveHeadDown, moveHeadBackUp, block]]];
    
}

-(void)moveCat{
    CGFloat randomX = arc4random()%200+500;
    
    SKAction *moveLeft = [SKAction moveToX:randomX duration:3]; //x = 600 worked
    SKAction *animate = [SKAction animateWithTextures:self.catWalkingFrames timePerFrame:0.1f];
    SKAction *moveLeftWithAnimation = [SKAction group:@[moveLeft, [SKAction repeatAction:animate count:10]]];
    SKAction *moveRight = [SKAction moveToX:884 duration:3];
    SKAction *moveRightWithAnimation = [SKAction group:@[moveRight, [SKAction repeatAction:animate count:10]]];
    SKAction *wait = [SKAction waitForDuration:1];
    SKAction *turnRight = [SKAction runBlock:^{
        self.cat.xScale = fabs(self.cat.xScale) *-1;
        
    }];
    SKAction *turnLeft = [SKAction runBlock:^{
        self.cat.xScale = fabs(self.cat.xScale) *1;
        
        
    }];
    
    [self.cat runAction:[SKAction sequence:@[moveLeftWithAnimation, wait, turnRight, wait, moveRightWithAnimation, wait, turnLeft,wait]]withKey:@"catAnimationLoop"];
}
-(void)checkCatPosition{
    
    if (self.cat.position.x <= 750 && self.cat.position.x >= 712) {
        self.multiplierForDirection = -1;
    } else {
        self.multiplierForDirection = 1;
    }
    self.cat.xScale = fabs(self.cat.xScale) * self.multiplierForDirection;
}
-(void)setupKitchenOvens{
    
    self.kitchenOvens = [SKSpriteNode spriteNodeWithImageNamed:@"kuchnia piekarnik"];
    
    self.kitchenOvens.position = CGPointMake(180, 200);
    self.kitchenOvens.zPosition = -1;
    [self addChild:self.kitchenOvens];
    
}
-(void)setupLunchbox{
    
    self.lunchbox = [SKSpriteNode spriteNodeWithImageNamed:@"lunch box"];
    self.lunchbox.position = CGPointMake(150, self.size.height/2);
    [self addChild:self.lunchbox];
    
    
}
-(void)setupKitchenWindow{
    
    self.kitchenWindow = [SKSpriteNode spriteNodeWithImageNamed:@"oknoBezChmur"];
    self.kitchenWindow.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - self.kitchenWindow.size.height + 250);
    self.windowFrame = [SKSpriteNode spriteNodeWithImageNamed:@"oknoBezSzyb"];
    self.windowFrame.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - self.kitchenWindow.size.height + 250);
    self.windowFrame.zPosition = 3;
    
    [self addChild:self.kitchenWindow];
    [self addChild:self.windowFrame];
    
    
    [self cloudAction];
    /*
     
     runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnEnemy), SKAction.waitForDuration(4.0)])))
     */
    
}
-(void)cloudAction{
    
    
    SKAction *block = [SKAction runBlock:^{
        
        [self spawnCloud: self.cloud1 waitDuration:4];
        [self spawnCloud: self.cloud2 waitDuration:1];
        [self spawnCloud: self.cloud3 waitDuration:5];
        [self spawnCloud: self.cloud1 waitDuration:2];
        
        
        
    }];
    SKAction *fullCloudMovementSequence = [SKAction repeatActionForever:[SKAction sequence:@[block, [SKAction waitForDuration:12.0]] ]];
    [self runAction: fullCloudMovementSequence];
}

-(void)spawnCloud: (SKSpriteNode *)cloud waitDuration:(CGFloat)duration{
    
    
    cloud = [SKSpriteNode spriteNodeWithImageNamed:@"chmurka2"];
    cloud.position = CGPointMake(self.size.width/2 + 100, RandomFloatRange(600, 750));
    cloud.zPosition = 2;
    cloud.alpha = 0.0;
    [self addChild:cloud];
    
    SKAction *fadeIn = [SKAction fadeAlphaTo:1.0 duration:3];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:4];
    SKAction *wait = [SKAction waitForDuration:duration];
    SKAction *cloudMoving = [SKAction moveByX:-140 y:0 duration:15];
    cloudMoving.timingFunction = SKActionTimingLinear;
    SKAction *cloudSequenceFirst = [SKAction group:@[fadeIn, cloudMoving]];
    
    SKAction *cloudSequenceSecond = [SKAction group:@[cloudSequenceFirst, fadeOut]];
    
    SKAction *cloudSequenceFinal = [SKAction sequence:@[wait, cloudSequenceFirst, cloudSequenceSecond]];
    
    [cloud runAction: cloudSequenceFinal completion:^{
        [cloud removeFromParent];
    }];
}
-(void)setupSoundIcon{
    self.soundIcon = [SKSpriteNode spriteNodeWithImageNamed:@"glosnik"];
    self.soundIcon.position = CGPointMake(self.soundIcon.size.width-20, self.size.height-self.soundIcon.size.height -50);
    [self addChild:self.soundIcon];
}

-(void)setupArrow{
    self.arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrowRight"];
    self.arrow.position = CGPointMake(self.size.width-self.arrow.size.width/2, self.arrow.size.height);
    self.arrow.zPosition = 5;
    self.arrow.alpha = 0.5;
    self.arrowActive = NO;
    [self addChild:self.arrow];
    
}
-(void)setupBin{
    self.bin = [SKSpriteNode spriteNodeWithImageNamed:@"kosz"];
    self.bin.position =  CGPointMake(self.size.width - 80, 220);
    self.bin.zPosition = 2;
    self.binActive = YES;
    [self addChild:self.bin];
}
-(void)setupTheFridge{
    
    self.fridge = [SKSpriteNode spriteNodeWithImageNamed:@"lodowka zamknieta"];
    self.fridge.position =  CGPointMake(self.size.width - 110, 420);
    self.fridge.zPosition = 0;
    [self addChild:self.fridge];
    self.foodTouchesActive = YES;
}
-(void)setupTheCupboard{
    self.cupboard = [SKSpriteNode spriteNodeWithImageNamed:@"szafka zamknieta"];
    self.cupboard.position = CGPointMake(self.cupboard.size.width/2+60, self.size.height - self.cupboard.size.height/2);
    
    [self addChild:self.cupboard];
}
-(void)setupEatenApple{
    
    self.eatenApple = [SKSpriteNode spriteNodeWithImageNamed:@"ogryzek"];
    self.eatenApple.position = CGPointMake(self.table.position.x-50, self.table.position.y+80);
    self.eatenApple.zPosition = 3;
    self.eatenApple.name = @"food";
    self.eatenAppleActive = YES;
    
    [self addChild:self.eatenApple];
    
}
-(void)setupEatenBread{
    
    self.eatenBread = [SKSpriteNode spriteNodeWithImageNamed:@"chleb okruszki"];
    self.eatenBread.position = CGPointMake(self.table.position.x, self.table.position.y-140);
    self.eatenBread.zPosition = 3;
    self.eatenBread.name = @"food";
    self.eatenBreadActive = YES;
    [self addChild:self.eatenBread];
    
}
-(void)setupEatenCake{
    
    self.eatenCake = [SKSpriteNode spriteNodeWithImageNamed:@"ciastko nadgryzione"];
    self.eatenCake.position = CGPointMake(self.table.position.x-110, self.table.position.y+80);
    self.eatenCake.zPosition = 3;
    self.eatenCake.name = @"food";
    self.eatenCakeActive = YES;
    [self addChild:self.eatenCake];
    
}
-(void)setupEatenBanana{
    
    self.eatenBanana = [SKSpriteNode spriteNodeWithImageNamed:@"skorka banan"];
    self.eatenBanana.position = CGPointMake(self.table.position.x+70, self.table.position.y+80);
    self.eatenBanana.zPosition = 3;
    self.eatenBanana.name = @"food";
    self.eatenBananaActive = YES;
    
    [self addChild:self.eatenBanana];
    
}
-(void)setupTable{
    
    self.table = [SKSpriteNode spriteNodeWithImageNamed:@"table"];
    self.table.position = CGPointMake(self.size.width/2+20, 230);
    
    
    SKSpriteNode *kettle = [SKSpriteNode spriteNodeWithImageNamed:@"czajnik"];
    kettle.position = CGPointMake(self.size.width/2+20, 330);
    kettle.zPosition = 2;
    [self addChild:kettle];
    //    self.vase = [SKSpriteNode spriteNodeWithImageNamed:@"wazon"];
    //    self.vase.position = CGPointMake(self.size.width/2+20, 330);
    //    self.vase.zPosition = 2;
    //    [self addChild:self.vase];
    [self addChild:self.table];
    
}
-(void)setupFullScreenCupboard{
    [self resetStars];
    [self enumerateChildNodesWithName:@"food" usingBlock:^(SKNode *node, BOOL *stop) {
        
        node.zPosition = 2;
    }];
    _gameState = LBGameStateCupboard;
    CGFloat cupsZPosition = 201;
    _bellBodyObject.bellsHead.zPosition = 0;
    CGPoint redCupPosition = CGPointMake(self.size.width/2 - 120, self.size.height/2 +150);
    self.fullScreenCupboard = [SKSpriteNode spriteNodeWithImageNamed:@"szafkaDuza"];
    self.fullScreenCupboard.position = CGPointMake(self.size.width/2, self.size.height/2);
    self.fullScreenCupboard.zPosition = 200;
    self.fullScreenCupboard.name = @"cups";
    
    self.cupboardBackground = [SKSpriteNode  spriteNodeWithImageNamed:@"kitchenCupboardBackground"];
    self.cupboardBackground.position = CGPointMake(self.size.width/2, self.size.height/2);
    self.cupboardBackground.zPosition = 199;
    self.cupboardBackground.name = @"cups";
    [self addChild:self.cupboardBackground];
    
    [self addChild:self.fullScreenCupboard];
    //    [self playBackgroundMusic:@"Bell Music Wardrobe.mp3"];
    //    [self.backgroundMusicPlayer play];
    [[SKTAudio sharedInstance]pauseBackgroundMusic];
    [[SKTAudio sharedInstance] playBackgroundMusic:@"Bell Music Wardrobe.mp3"];
    self.redCup = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka red polka"];
    self.redCup.position = redCupPosition;
    self.redCup.zPosition = cupsZPosition;
    self.redCup.name = @"cups";
    self.redCupCounterActive = YES;
    
    [self addChild:self.redCup];
    
    
    self.blueCup = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka blue polka"];
    //self.blueCup.position = CGPointMake(redCupPosition.x+self.blueCup.size.width, 340);
    self.blueCup.position = CGPointMake(MiddleSideCupBoard, SecondRow);
    self.blueCup.zPosition = cupsZPosition;
    self.blueCup.name = @"cups";
    self.blueCupCounterActive = YES;
    [self addChild:self.blueCup];
    
    self.yellowCup = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka yellow polka"];
    self.yellowCup.position = CGPointMake(LeftSideCupBoard, 170);
    self.yellowCup.zPosition = cupsZPosition;
    self.yellowCup.name = @"cups";
    self.yellowCupCounterActive = YES;
    [self addChild:self.yellowCup];
    
    self.cupTouchesActive = YES;
    
    self.exitButton = [SKSpriteNode spriteNodeWithImageNamed:@"backButton"];
    self.exitButton.position = CGPointMake(self.size.width - self.exitButton.size.width, self.size.height-self.exitButton.size.height);
    self.exitButton.zPosition = cupsZPosition;
    self.exitButton.name = @"cups";
    [self addChild:self.exitButton];
    
    
    
    self.redCupSide1 = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka red polka"];
    self.redCupSide1.position = CGPointMake(LeftSideCupBoard -CupOffsetLeftOffset, SecondRow);
    //self.originalPosition =self.redCupSide1.position;
    self.redCupSide1Active = YES;
    self.redCupSide1.zPosition = cupsZPosition;
    self.redCupSide1.name = @"cups";
    [self addChild:self.redCupSide1];
    
    
    
    self.redCupSide2 = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka red polka"];
    self.redCupSide2.position = CGPointMake(RightSideCupBoard + CupOffsetLeftOffset, ThirdRow);
    self.redCupSide2OriginalLocation = self.redCupSide2.position;
    self.redCupSide2Active = YES;
    self.redCupSide2.zPosition = cupsZPosition;
    self.redCupSide2.name = @"cups";
    [self addChild:self.redCupSide2];
    
    self.blueCupSide1 = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka blue polka"];
    self.blueCupSide1.position = CGPointMake(redCupPosition.x-CupOffsetLeftOffset, FirstRow);
    self.blueCupSide1OriginalLocation = self.blueCupSide1.position;
    self.blueCupSide1Active = YES;
    self.blueCupSide1.zPosition = cupsZPosition;
    self.blueCupSide1.name = @"cups";
    [self addChild:self.blueCupSide1];
    
    self.blueCupSide2 = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka blue polka"];
    self.blueCupSide2.position = CGPointMake(redCupPosition.x-CupOffsetLeftOffset, ThirdRow);
    self.blueCupSide2OriginalLocation = self.blueCupSide2.position;
    self.blueCupSide2Active = YES;
    
    self.blueCupSide2.zPosition = cupsZPosition;
    self.blueCupSide2.name = @"cups";
    
    [self addChild:self.blueCupSide2];
    
    self.yellowCupSide1 = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka yellow polka"];
    self.yellowCupSide1.position = CGPointMake(RightSideCupBoard + CupOffsetLeftOffset, FirstRow);
    self.yellowCupSide1OriginalLocation = self.yellowCupSide1.position;
    self.yellowCupSide1Active = YES;
    
    self.yellowCupSide1.zPosition = cupsZPosition;
    self.yellowCupSide1.name = @"cups";
    [self addChild:self.yellowCupSide1];
    
    self.yellowCupSide2 = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka yellow polka"];
    self.yellowCupSide2.position = CGPointMake(RightSideCupBoard + CupOffsetLeftOffset, SecondRow);
    self.yellowCupSide2OriginalLocation = self.yellowCupSide2.position;
    self.yellowCupSide2Active = YES;
    self.yellowCupSide2.zPosition = cupsZPosition;
    self.yellowCupSide2.name = @"cups";
    [self addChild:self.yellowCupSide2];
    
}
-(void)setupFood{
    self.foodActive = YES;
    self.banana = [SKSpriteNode spriteNodeWithImageNamed:@"banan"];
    self.banana.position = CGPointMake(self.size.width - 200, self.size.height - 190);
    self.banana.name = @"food";
    self.banana.zPosition = 2;
    self.bananaActive = YES;
    [self addChild:self.banana];
    
    
    self.apple = [SKSpriteNode spriteNodeWithImageNamed:@"jablko"];
    self.apple.position = CGPointMake(self.size.width - 200, self.size.height - 250);
    self.apple.name = @"food";
    self.apple.zPosition = 2;
    self.appleActive = YES;
    [self addChild:self.apple];
    
    self.cake = [SKSpriteNode spriteNodeWithImageNamed:@"ciastko"];
    self.cake.position = CGPointMake(self.size.width - 140, self.size.height - 255);
    self.cake.zPosition = 2;
    self.cake.name = @"food";
    self.cakeActive = YES;
    [self addChild:self.cake];
    
    self.bread = [SKSpriteNode spriteNodeWithImageNamed:@"chleb"];
    self.bread.position = CGPointMake(self.size.width - 140, self.size.height - 335);
    self.bread.zPosition = 2;
    self.bread.name = @"food";
    self.breadActive = YES;
    [self addChild:self.bread];
    
    self.milkBottle = [SKSpriteNode spriteNodeWithImageNamed:@"butelka mleko"];
    self.milkBottle.position = CGPointMake(self.size.width - 220, self.size.height - 380);
    self.milkBottle.zPosition = 2;
    self.milkBottle.name = @"food";
    self.milkBottleActive = YES;
    [self addChild:self.milkBottle];
}
-(void)setupChair{
    
    self.chair = [SKSpriteNode spriteNodeWithImageNamed:@"stolek"];
    self.chair.position = CGPointMake(self.kitchenOvens.position.x, self.kitchenOvens.position.y-40);
    
    [self addChild:self.chair];
    
    
}
-(void)setupBigSparkEmiter:(CGPoint)coordinates{
    
    
    self.bigSparkEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"BigSpark" ofType:@"sks"]];
    self.bigSparkEmitter.zPosition = 500;
    self.bigSparkEmitter.position = coordinates;
    [self runAction:[SKAction playSoundFileNamed:@"SFX Scena 2 Szczotka Pasta.mp3" waitForCompletion:NO]];

    [self addChild:self.bigSparkEmitter];
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
        [[SKTAudio sharedInstance]playBackgroundMusic:@"LittleBellKitchenMastered.mp3"];
    }
}
-(void)setupCharactersHeadHappyAnimation{
    
    
    //    SKAction *wiggleTailUp = [SKAction rotateByAngle:M_PI_4/16 duration:0.2];
    //    SKAction *wiggleTailDown = [SKAction rotateByAngle:-M_PI_4/16 duration:0.2];
    // SKAction *wiggling = [SKAction repeatAction:[SKAction sequence:@[wiggleTailUp, wiggleTailDown]] count:7];
    SKAction *wiggleHeadUp = [SKAction rotateByAngle:M_PI_4/8 duration:0.2];
    SKAction *wiggleHeadDown = [SKAction rotateByAngle:-M_PI_4/8 duration:0.2];
    SKAction *wigglingHead = [SKAction repeatAction:[SKAction sequence:@[wiggleHeadDown, wiggleHeadUp]] count:5];
    
    
    [_bellBodyObject.bellsHead runAction:[SKAction group:@[wigglingHead]]];
    
    //    SKAction *bounceUp = [SKAction moveByX:0 y:20 duration:0.3];
    //    SKAction *bounceDown = [SKAction moveByX:0 y:-20 duration:0.3];
    //   // SKAction *bouncing = [SKAction repeatAction:[SKAction sequence:@[bounceUp, bounceDown]] count:5];
    
    //    SKAction *scaleUp = [SKAction scaleTo:0.8 duration:0.2];
    //    SKAction *scaleDown = [SKAction scaleTo:1.0 duration:0.2];
    //    SKAction *scalingSeq = [SKAction sequence:@[scaleUp, scaleDown]];
    //    SKAction *scaling = [SKAction repeatAction:scalingSeq count:5];
    
    // [_bellBodyObject.bellsHead runAction:[SKAction group:@[wiggling, bouncing]]];
    
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
-(void)animateTheCatHappiness{
    self.catTouchesActive = NO;
    
    SKAction *rotateBack = [SKAction rotateByAngle:M_PI *2 duration:2];
    SKAction *moveUp = [SKAction moveByX:0 y:50 duration:2];
    SKAction *moveDown = [SKAction moveByX:0 y:-50 duration:0.5];
    SKAction *seq = [SKAction sequence:@[moveUp, moveDown]];
    SKAction *groupMove = [SKAction group:@[rotateBack, seq]];
    
    [self.cat runAction:groupMove completion:^{
        
        self.catTouchesActive = YES;
        
    }];
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
-(void)foodHint{
    
    
    [self drawHintinLocation:self.cake afterDelay:1];
    [self drawHintinLocation:self.bread afterDelay:2];
    [self drawHintinLocation:self.banana afterDelay:3];
    [self drawHintinLocation:self.apple afterDelay:4];
    [self drawHintinLocation:self.milkBottle afterDelay:5];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        switch (_gameState) {
            case LBGameStateKitchen:
                _bellBodyObject.bellsHead.zPosition = 101;
                
                [_bellBodyObject moveHeadTowards:location];
                
                self.littleSparkEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"LittleSpark" ofType:@"sks"]];
                self.littleSparkEmitter.zPosition = 100;
                self.littleSparkEmitter.position = location;
                [self addChild:self.littleSparkEmitter];
                
                if   ([self.soundIcon containsPoint:location]){
                    
                    [self showSoundButtonForTogglePosition:self.musicOn];
                }
                
                if ([_bellBodyObject.bellsBody containsPoint:location] || [_bellBodyObject.bellsHead containsPoint:location]) {
                    [self bellRandomNoises];
                    
                }
                if ([self.arrow containsPoint:location] && self.arrowActive) {
                    
                    SKView * skView = (SKView *)self.view;
                    skView.showsFPS = NO;
                    skView.showsNodeCount = NO;
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = YES;
                    [[SKTAudio sharedInstance]pauseBackgroundMusic];
                    //[self fadeOutTheMusic];
                    WardrobeScene *scene =  [WardrobeScene unarchiveFromFile:@"wardrobeScene"];
                    scene.scaleMode = SKSceneScaleModeAspectFill;
                    SKTransition *transition = [SKTransition fadeWithColor:[UIColor blackColor] duration:4];
                    // Present the scene.
                    [skView presentScene:scene transition:transition];
                }
                
                if (self.foodTouchesActive) {
                    
                    
                    
                    if ([self.milkBottle containsPoint:location]){
                        self.originalPosition = self.milkBottle.position;
                        self.touchingBottleOfMilk = YES;
                        self.milkBottle.zPosition = 400;
                        self.milkBottle.xScale = 1.4;
                        self.milkBottle.yScale = 1.4;
                        self.touchingPoint = location;
                        
                        
                    }
                    
                    if ([self.banana containsPoint:location]){
                        self.originalPosition = self.banana.position;
                        self.touchingBanana = YES;
                        self.banana.zPosition = 400;
                        self.banana.xScale = 1.4;
                        self.banana.yScale = 1.4;
                        self.touchingPoint = location;
                        
                        
                    }
                    
                    if ([self.bread containsPoint:location]){
                        self.originalPosition = self.bread.position;
                        self.touchingBread = YES;
                        self.bread.zPosition = 400;
                        self.bread.xScale = 1.4;
                        self.bread.yScale = 1.4;
                        self.touchingPoint = location;
                        
                        
                    }
                    if ([self.cake containsPoint:location] ){
                        self.originalPosition = self.cake.position;
                        self.touchingCake = YES;
                        self.cake.zPosition = 400;
                        self.cake.xScale = 1.4;
                        self.cake.yScale = 1.4;
                        self.touchingPoint = location;
                        
                        
                    }
                    if ([self.apple containsPoint:location]){
                        self.touchingApple = YES;
                        self.originalPosition = self.apple.position;
                        
                        self.apple.zPosition = 400;
                        self.apple.xScale = 1.4;
                        self.apple.yScale = 1.4;
                        self.touchingPoint = location;
                        
                        
                    }
                    
                    
                    //eaten family
                    
                    if ([self.eatenBread containsPoint:location]) {
                        self.originalPosition = self.eatenBread.position;
                        self.touchingEatenBread = YES;
                        self.eatenBread.zPosition = 400;
                        self.eatenBread.xScale = 1.4;
                        self.eatenBread.yScale = 1.4;
                        self.touchingPoint = location;
                    }
                    if ([self.eatenBanana containsPoint:location]) {
                        self.originalPosition = self.eatenBanana.position;
                        self.touchingEatenBanana = YES;
                        self.eatenBanana.zPosition = 400;
                        self.eatenBanana.xScale = 1.4;
                        self.eatenBanana.yScale = 1.4;
                        self.touchingPoint = location;
                    }
                    if ([self.eatenApple containsPoint:location]) {
                        self.originalPosition = self.eatenApple.position;
                        self.touchingEatenApple = YES;
                        self.eatenApple.zPosition = 400;
                        self.eatenApple.xScale = 1.4;
                        self.eatenApple.yScale = 1.4;
                        self.touchingPoint = location;
                    }
                    if ([self.eatenCake containsPoint:location]) {
                        self.originalPosition = self.eatenCake.position;
                        self.touchingEatenCake = YES;
                        self.eatenCake.zPosition = 400;
                        self.eatenCake.xScale = 1.4;
                        self.eatenCake.yScale = 1.4;
                        self.touchingPoint = location;
                    }
                    
                    
                }
                
                
                if ([self.cupboard containsPoint:location] && !self.cupboardSwitch) {
                    self.cupboardSwitch = YES;
                    [self removeActionWithAlpha:self.cupboard];
                    [self setupFullScreenCupboard];
                    
                    
                    
                    
                }
                
                if ([self.fridge containsPoint:location]){
                    
                    if (!self.touchingFridge && !self.cupboardSwitch){
                       
                        SKTexture *fridgeTexture = [SKTexture textureWithImageNamed:@"lodowka otwarta"];
                        [self.fridge setTexture:fridgeTexture];
                        [[SKTAudio sharedInstance]playSoundEffect:@"SFXlodowka2.mp3"];
                        self.touchingFridge = YES;
                        [self setupFood];
                         [self removeActionWithAlpha:self.fridge];
                        [self foodHint];
                    }
                }
                
                if ([self.cat containsPoint:location]&& self.stickerAnimationActive && self.catTouchesActive) {
                    [[SKTAudio sharedInstance]playSoundEffect:@"SFXKot.mp3"];
                    [self animateTheCatHappiness];
                }
                
                
                
                break;
            case LBGameStateCupboard:
                
                if ([self.exitButton containsPoint:location]) {
                    [self enumerateChildNodesWithName:@"cups" usingBlock:^(SKNode *node, BOOL *stop) {
                        
                        [node removeFromParent];
                        [self.queCup removeFromParent];
                        [self resetStars];
                        
                        [[SKTAudio sharedInstance]pauseBackgroundMusic];
                        [[SKTAudio sharedInstance] playBackgroundMusic:@"LittleBellKitchenMastered.mp3"];
                        self.soundIcon.texture = [SKTexture textureWithImageNamed:@"glosnik"];
                        self.musicOn = YES;
                        //
                    }];
                    
                    //                                     self.cupboardSwitch = NO;
                    _gameState = LBGameStateKitchen;
                    self.cupboardSwitch = NO;
                    if (!self.foodActive) {
                        [self drawHintinLocation:self.fridge afterDelay:0];

                    
                    }
                }
                if (self.cupTouchesActive) {
                    
                    
                    if ([self.redCupSide1 containsPoint:location] && self.redCupSide1Active) {
                        self.touchingRedCupSide1 = YES;
                        self.cupOriginalLocation = self.redCupSide1.position;
                        self.redCupSide1.yScale = 1.2;
                        self.redCupSide1.xScale = 1.2;
                        self.touchingPoint = location;
                        [self setupQueCupAnimationFor:@"redCupSide1" andPosition:CGPointMake(517, 534)];
                    }
                    if ([self.redCupSide2 containsPoint:location]&& self.redCupSide2Active) {
                        self.touchingRedCupSide2 = YES;
                        self.cupOriginalLocation = self.redCupSide2.position;
                        
                        self.redCupSide2.yScale = 1.2;
                        self.redCupSide2.xScale = 1.2;
                        self.touchingPoint = location;
                        [self setupQueCupAnimationFor:@"redCupSide2" andPosition:CGPointMake(RightSideCupBoard, FirstRow)];
                        
                    }
                    if ([self.blueCupSide1 containsPoint:location] && self.blueCupSide1Active) {
                        self.touchingBlueCupSide1 = YES;
                        self.cupOriginalLocation = self.blueCupSide1.position;
                        self.blueCupSide1.yScale = 1.2;
                        self.blueCupSide1.xScale = 1.2;
                        self.touchingPoint = location;
                        [self setupQueCupAnimationFor:@"blueCupSide1" andPosition:CGPointMake(RightSideCupBoard, SecondRow)];
                    }
                    if ([self.blueCupSide2 containsPoint:location] && self.blueCupSide2Active) {
                        self.touchingBlueCupSide2 = YES;
                        self.cupOriginalLocation = self.blueCupSide2.position;
                        self.blueCupSide2.yScale = 1.2;
                        self.blueCupSide2.xScale = 1.2;
                        self.touchingPoint = location;
                        [self setupQueCupAnimationFor:@"blueCupSide2" andPosition:CGPointMake(LeftSideCupBoard, SecondRow)];
                    }
                    if ([self.yellowCupSide1 containsPoint:location] && self.yellowCupSide1Active) {
                        self.touchingYellowCupSide1 = YES;
                        self.cupOriginalLocation = self.yellowCupSide1.position;
                        self.yellowCupSide1.yScale = 1.2;
                        self.yellowCupSide1.xScale = 1.2;
                        self.touchingPoint = location;
                        [self setupQueCupAnimationFor:@"yellowCupSide1" andPosition:CGPointMake(RightSideCupBoard, ThirdRow)];
                    }
                    if ([self.yellowCupSide2 containsPoint:location] && self.yellowCupSide2Active) {
                        self.touchingYellowCupSide2 = YES;
                        self.cupOriginalLocation = self.yellowCupSide2.position;
                        self.yellowCupSide2.yScale = 1.2;
                        self.yellowCupSide2.xScale = 1.2;
                        self.touchingPoint = location;
                        [self setupQueCupAnimationFor:@"yellowCupSide2" andPosition:CGPointMake(MiddleSideCupBoard, ThirdRow)];
                    }
                }
                break;
        }
        
        
        
        
        
        
        
        
    }
    
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    self.touchingPoint = [[touches anyObject] locationInNode:self];
    
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.queCup removeFromParent];
    self.touchingRedCupSide1 = NO;
    self.touchingBlueCupSide1 = NO;
    self.touchingYellowCupSide1 = NO;
    
    self.touchingRedCupSide2 = NO;
    self.touchingBlueCupSide2 = NO;
    self.touchingYellowCupSide2 = NO;
    
    self.touchingBanana = NO;
    self.touchingCake = NO;
    self.touchingApple = NO;
    self.touchingBread = NO;
    self.touchingBottleOfMilk = NO;
    
    self.touchingEatenBanana = NO;
    self.touchingEatenApple = NO;
    self.touchingEatenBread = NO;
    self.touchingEatenCake = NO;
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    for (UITouch *touch in touches) {
        CGPoint currentLocation = [touch locationInNode:self];
        //cup size w: 125 h: 76 redCupPos = x:517, y:534
        CGPoint currentPoint = [[touches anyObject]locationInNode:self];
        if (self.touchingRedCupSide1 && self.redCupSide1Active) {
            
            
            if (currentLocation.x >= 457  && currentLocation.x <=637 && currentLocation.y >= 490 && currentLocation.y <= 575) {
                
                currentLocation = CGPointMake(517, 534);
                [self setupBigSparkEmiter:currentPoint];
                self.redCupSide1.yScale = 1.0;
                self.redCupSide1.xScale = 1.0;
                self.redCupSide1.position = currentLocation;
                self.redCupSide1Active  = NO;
                [self.queCup removeFromParent];
                
            }else
                if (self.cupTouchesActive) {
                    [self animatePuttingThingsBack:self.redCupSide1];
                }
            
            self.touchingRedCupSide1 = NO;
            [self.queCup removeFromParent];
            self.redCupCounter++;
            
        }
        if (self.touchingRedCupSide2 && self.redCupSide2Active) {
            
            
            if (currentLocation.x >= RightSideCupBoard - 100  && currentLocation.x <= RightSideCupBoard + 100 && currentLocation.y >= FirstRow - 60 && currentLocation.y <= FirstRow + 60) {
                
                currentLocation = CGPointMake(RightSideCupBoard, FirstRow);
                [self setupBigSparkEmiter:currentPoint];
                
                self.redCupSide2.yScale = 1.0;
                self.redCupSide2.xScale = 1.0;
                self.redCupSide2.position = currentLocation;
                self.redCupSide2Active = NO;
                self.redCupCounter++;
            }else
                if (self.cupTouchesActive) {
                    [self animatePuttingThingsBack:self.redCupSide2];
                }
            self.touchingRedCupSide2 = NO;
            [self.queCup removeFromParent];
            
        }
        if (self.touchingBlueCupSide1 && self.blueCupSide1Active){
            
            if (currentLocation.x >= RightSideCupBoard - 100  && currentLocation.x <= RightSideCupBoard +100 && currentLocation.y >= SecondRow - 60 && currentLocation.y <= SecondRow +60){
                
                currentLocation = CGPointMake(RightSideCupBoard, SecondRow);
                [self setupBigSparkEmiter:currentPoint];
                self.blueCupSide1.yScale = 1.0;
                self.blueCupSide1.xScale = 1.0;
                self.blueCupSide1.position = currentLocation;
                self.blueCupSide1Active = NO;
                self.blueCupCounter++;
            }else if (self.cupTouchesActive) {
                [self animatePuttingThingsBack:self.blueCupSide1];
            }
            self.touchingBlueCupSide1 = NO;
            [self.queCup removeFromParent];
            
        }
        if (self.touchingBlueCupSide2 && self.blueCupSide2Active){
            
            
            if (currentLocation.x >= LeftSideCupBoard - 100  && currentLocation.x <= LeftSideCupBoard +100 && currentLocation.y >= SecondRow - 60 && currentLocation.y <= SecondRow +60){
                
                currentLocation = CGPointMake(LeftSideCupBoard, SecondRow);
                [self setupBigSparkEmiter:currentPoint];
                
                self.blueCupSide2.yScale = 1.0;
                self.blueCupSide2.xScale = 1.0;
                self.blueCupSide2.position = currentLocation;
                self.blueCupSide2Active = NO;
                self.blueCupCounter++;
                
            }else if (self.cupTouchesActive) {
                [self animatePuttingThingsBack:self.blueCupSide2];
            }
            self.touchingBlueCupSide2 = NO;
            [self.queCup removeFromParent];
        }
        if (self.touchingYellowCupSide1 && self.yellowCupSide1Active){
            
            if (currentLocation.x >= RightSideCupBoard - 100  && currentLocation.x <= RightSideCupBoard +100 && currentLocation.y >= ThirdRow - 60 && currentLocation.y <= ThirdRow + 60){
                
                currentLocation = CGPointMake(RightSideCupBoard, ThirdRow);
                [self setupBigSparkEmiter:currentPoint];
                
                self.yellowCupSide1.yScale = 1.0;
                self.yellowCupSide1.xScale = 1.0;
                self.yellowCupSide1.position = currentLocation;
                self.yellowCupSide1Active = NO;
                self.yellowCupCounter++;
                
            }else if (self.cupTouchesActive) {
                [self animatePuttingThingsBack:self.yellowCupSide1];
            }
            self.touchingYellowCupSide1 = NO;
            [self.queCup removeFromParent];
            
        }
        if (self.touchingYellowCupSide2 && self.yellowCupSide2Active){
            
            if (currentLocation.x >= MiddleSideCupBoard - 100  && currentLocation.x <= MiddleSideCupBoard +100 && currentLocation.y >= ThirdRow - 60 && currentLocation.y <= ThirdRow + 60){
                
                currentLocation = CGPointMake(MiddleSideCupBoard, ThirdRow);
                [self setupBigSparkEmiter:currentPoint];
                
                self.yellowCupSide2.yScale = 1.0;
                self.yellowCupSide2.xScale = 1.0;
                self.yellowCupSide2.position = currentLocation;
                self.yellowCupSide2Active = NO;
                self.yellowCupCounter++;
            }else
                if (self.cupTouchesActive) {
                    [self animatePuttingThingsBack:self.yellowCupSide2];
                }
            self.touchingYellowCupSide2 = NO;
            [self.queCup removeFromParent];
        }
        
        if (self.touchingBottleOfMilk && self.milkBottleActive) {
            CGPoint currentPoint = [[touches anyObject]locationInNode:self];
            if ([self isWithinCatBowl:currentPoint]){
                [self removeActionWithAlpha:self.milkBottle];
                self.milkBottleActive = NO;
                self.touchingBottleOfMilk = NO;
                [self.catBowl setTexture:[SKTexture textureWithImageNamed:@"micha mleko"]];
                self.bowlFull = YES;
                [self.milkBottle removeFromParent];
                [self setupBigSparkEmiter:currentPoint];
                
                
            }else if (self.foodTouchesActive) {
                [self animatePuttingThingsBack:self.milkBottle];
            }
            self.touchingBottleOfMilk = NO;
        }
        
        
        if (self.touchingBanana && self.bananaActive) {
            CGPoint currentPoint = [[touches anyObject]locationInNode:self];
            if ([self isWithinCharactersBody:currentPoint]){
                [self removeActionWithAlpha:self.banana];
                
                self.touchingBanana = NO;
                self.bananaActive = NO;
                
                [self.banana removeFromParent];
                [self setupBigSparkEmiter:currentPoint];
                [self setupEatenBanana];
                [self drawHintinLocation:self.eatenBanana afterDelay:2];
                
            }else if (self.foodTouchesActive) {
                [self animatePuttingThingsBack:self.banana];
            }
            self.touchingBanana = NO;
        }
        
        if (self.touchingApple && self.appleActive) {
            CGPoint currentPoint = [[touches anyObject] locationInNode:self];
            if ([self isWithinCharactersBody:currentPoint])
            {   [self removeActionWithAlpha:self.apple];
                self.appleActive = NO;
                self.touchingApple = NO;
                [self.apple removeFromParent];
                [self setupBigSparkEmiter:currentPoint];
                [self setupEatenApple];
                [self drawHintinLocation:self.eatenApple afterDelay:2];

                // [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarThree];
                
            }else if (self.foodTouchesActive) {
                [self animatePuttingThingsBack:self.apple];
            }
            self.touchingApple = NO;
        }
        
        
        if (self.touchingCake && self.cakeActive) {
            CGPoint currentPoint = [[touches anyObject] locationInNode:self];
            
            
            if ([self isWithinCharactersBody:currentPoint]){
                [self removeActionWithAlpha:self.cake];
                self.cakeActive = NO;
                self.touchingCake = NO;
                [self.cake removeFromParent];
                [self setupBigSparkEmiter:currentPoint];
                [self setupEatenCake];
                [self drawHintinLocation:self.eatenCake afterDelay:2];

            }else if (self.foodTouchesActive) {
                [self animatePuttingThingsBack:self.cake];
            }
            self.touchingCake = NO;
        }
        if (self.touchingBread && self.breadActive) {
            CGPoint currentPoint = [[touches anyObject] locationInNode:self];
            
            
            if ([self isWithinCharactersBody:currentPoint]){
                [self removeActionWithAlpha:self.bread];
                self.breadActive = NO;
                self.touchingBread = NO;
                [self.bread removeFromParent];
                [self setupBigSparkEmiter:currentPoint];
                [self setupEatenBread];
                [self drawHintinLocation:self.eatenBread afterDelay:2];

            }else if (self.foodTouchesActive) {
                [self animatePuttingThingsBack:self.bread];
            }
            self.touchingBread = NO;
            
        }
        if (self.touchingEatenBread && self.eatenBreadActive) {
            CGPoint currentPoint = [[touches anyObject]locationInNode:self];
            
            if ([self isWithinBin:currentPoint]) {
                [self removeActionWithAlpha:self.eatenBread];
                self.eatenBreadActive = NO;
                self.touchingEatenBread = NO;
                [self.eatenBread removeFromParent];
                [self setupBigSparkEmiter:currentPoint];
            }else if (self.foodTouchesActive) {
                
                [self animatePuttingThingsBack:self.eatenBread];
            }
            self.touchingEatenBread = NO;
        }
        
        
        
        if (self.touchingEatenCake && self.eatenCakeActive) {
            CGPoint currentPoint = [[touches anyObject]locationInNode:self];
            
            if ([self isWithinBin:currentPoint]) {
                [self removeActionWithAlpha:self.eatenCake];
                self.eatenCakeActive = NO;
                self.touchingEatenCake = NO;
                [self.eatenCake removeFromParent];
                [self setupBigSparkEmiter:currentPoint];
            }else if (self.foodTouchesActive) {
                
                [self animatePuttingThingsBack:self.eatenCake];
            }
            self.touchingEatenCake = NO;
        }
        
        if (self.touchingEatenBanana && self.eatenBananaActive) {
            CGPoint currentPoint = [[touches anyObject]locationInNode:self];
            
            if ([self isWithinBin:currentPoint]) {
                [self removeActionWithAlpha:self.eatenBanana];
                self.touchingEatenBanana = NO;
                [self.eatenBanana removeFromParent];
                [self setupBigSparkEmiter:currentPoint];
            }else if (self.foodTouchesActive) {
                
                [self animatePuttingThingsBack:self.eatenBanana];
            }
            self.touchingEatenBanana = NO;
            
        }
        if (self.touchingEatenApple && self.eatenAppleActive) {
            CGPoint currentPoint = [[touches anyObject]locationInNode:self];
            
            if ([self isWithinBin:currentPoint]) {
                [self removeActionWithAlpha:self.eatenApple];
                self.eatenAppleActive = NO;
                self.touchingEatenApple = NO;
                [self.eatenApple removeFromParent];
                [self setupBigSparkEmiter:currentPoint];
            }else  if (self.foodTouchesActive) {
                NSLog(@"gotHere!");
                [self animatePuttingThingsBack:self.eatenApple];
            }
            self.touchingEatenApple = NO;
            
        }
    }
    
}
-(void)resetStars{
    [_stickerOne.stickerStarOne removeFromParent];
    [_stickerOne.stickerStarTwo removeFromParent];
    [_stickerOne.stickerStarThree removeFromParent];
    [_stickerOne addStarsInPosition:CGPointMake(0, 768)];
}
-(void)setupQueCupAnimationFor:(NSString *)typeOfCup andPosition:(CGPoint)position{
    
    SKAction *scaling = [SKAction scaleTo:1 duration:0.2];
    SKAction *descaling = [SKAction scaleTo:0.6 duration:0.2];
    
    if ([typeOfCup isEqualToString:@"redCupSide1"]) {
        self.queCup = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka red polka"];
        self.queCup.position = position;
        self.queCup.alpha = 0.5;
        self.queCup.zPosition = 200;
        
        [self addChild:self.queCup];
        [self.queCup runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaling, descaling]]]withKey:@"cupAnimation"];
    }
    if ([typeOfCup isEqualToString:@"redCupSide2"]) {
        self.queCup = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka red polka"];
        self.queCup.position = position;
        self.queCup.alpha = 0.5;
        self.queCup.zPosition = 200;
        
        [self addChild:self.queCup];
        [self.queCup runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaling, descaling]]]withKey:@"cupAnimation"];
    }
    if ([typeOfCup isEqualToString:@"blueCupSide1"]) {
        self.queCup = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka blue polka"];
        self.queCup.position = position;
        self.queCup.alpha = 0.5;
        self.queCup.zPosition = 200;
        
        [self addChild:self.queCup];
        [self.queCup runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaling, descaling]]]withKey:@"cupAnimation"];
    }
    if ([typeOfCup isEqualToString:@"blueCupSide2"]) {
        self.queCup = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka blue polka"];
        self.queCup.position = position;
        self.queCup.alpha = 0.5;
        self.queCup.zPosition = 200;
        
        [self addChild:self.queCup];
        [self.queCup runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaling, descaling]]]withKey:@"cupAnimation"];
    }
    if ([typeOfCup isEqualToString:@"yellowCupSide1"]) {
        self.queCup = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka yellow polka"];
        self.queCup.position = position;
        self.queCup.zPosition = 200;
        self.queCup.alpha = 0.5;
        [self addChild:self.queCup];
        [self.queCup runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaling, descaling]]]withKey:@"cupAnimation"];
    }
    if ([typeOfCup isEqualToString:@"yellowCupSide2"]) {
        self.queCup = [SKSpriteNode spriteNodeWithImageNamed:@"filizanka yellow polka"];
        self.queCup.position = position;
        self.queCup.zPosition = 200;
        self.queCup.alpha = 0.5;
        [self addChild:self.queCup];
        [self.queCup runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaling, descaling]]]withKey:@"cupAnimation"];
    }
}
-(BOOL)isWithinBin:(CGPoint)currentLocation{
    if (currentLocation.x >= self.bin.position.x - BODY_OFFSET && currentLocation.x <= self.bin.position.x + BODY_OFFSET && currentLocation.y >= self.bin.position.y - BODY_OFFSET && currentLocation.y <= self.bin.position.y + BODY_OFFSET){
        self.foodWasteCounter++;
        [[SKTAudio sharedInstance]playSoundEffect:@"SFXSmieci.mp3"];
        return YES;
    }else {
        return NO;
    }
}
-(BOOL)isWithinCatBowl:(CGPoint)currentLocation{
    if (currentLocation.x >= self.catBowl.position.x - BODY_OFFSET && currentLocation.x <= self.catBowl.position.x + BODY_OFFSET && currentLocation.y >= self.catBowl.position.y - BODY_OFFSET && currentLocation.y <= self.catBowl.position.y + BODY_OFFSET){
        [[SKTAudio sharedInstance]playSoundEffect:@"SFXMleko.mp3"];
        return YES;
    }else {
        return NO;
    }
}


-(BOOL)isWithinCharactersBody:(CGPoint)currentLocation{
    if (currentLocation.x >= _bellBodyObject.bellsBody.position.x - BODY_OFFSET && currentLocation.x <= _bellBodyObject.bellsBody.position.x + BODY_OFFSET && currentLocation.y >= _bellBodyObject.bellsBody.position.y - BODY_OFFSET && currentLocation.y <= _bellBodyObject.bellsBody.position.y + BODY_OFFSET){
        self.foodCounter++;
        [self setupCharactersHeadHappyAnimation];
        [[SKTAudio sharedInstance]playSoundEffect:@"SFXyummy.mp3"];
        return YES;
    }
    if (currentLocation.x >= _bellBodyObject.bellsBody.position.x - BODY_OFFSET && currentLocation.x <= _bellBodyObject.bellsBody.position.x + BODY_OFFSET && currentLocation.y >= _bellBodyObject.bellsBody.position.y + 50 && currentLocation.y <= _bellBodyObject.bellsBody.position.y + 240)
    {
        self.foodCounter++;
        [self setupCharactersHeadHappyAnimation];
        [[SKTAudio sharedInstance]playSoundEffect:@"SFXyummy.mp3"];
        return YES;
    }else {
        

        return NO;
        
    }
}

-(BOOL)isItFood:(SKSpriteNode *)node{
    if (node == self.banana || node == self.bread || node == self.cake || node == self.apple || node == self.eatenBanana || node == self.eatenBread || node == self.eatenApple || node == self.milkBottle || node == self.eatenCake) {
        return YES;
    }
    return NO;
}
-(void)animatePuttingThingsBack:(SKSpriteNode *)node
{
    if ([self isItFood:node]) {
        [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniaNiePasuja.mp3"];
        self.foodTouchesActive = NO;
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
            
            self.foodTouchesActive = YES;
        }];
    }else
    {
        self.cupTouchesActive = NO;
        SKAction *scaleDown = [SKAction scaleTo:1.0 duration:0.5];
        SKAction *moveLeft = [SKAction moveByX:-10 y:0 duration:0.2];
        SKAction *moveRight = [SKAction moveByX:10 y:0 duration:0.2];
        
        SKAction *fastMovementSeq = [SKAction repeatAction:[SKAction sequence:@[moveLeft, moveRight]] count:4];
        SKAction *moveBack = [SKAction moveTo:self.cupOriginalLocation duration: 1];
        SKAction *rotateBack = [SKAction rotateByAngle:M_PI *2 duration:0.5];
        SKAction *group = [SKAction group:@[moveBack, rotateBack]];
        ;
        
        SKAction *seq =[SKAction sequence: @[scaleDown, fastMovementSeq, group]];
        [node runAction:seq completion:^{
            
            self.cupTouchesActive = YES;
        }];
    }
}

-(void)setupFooter{
    
    self.footer = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(1024, 70)];
    
    // self.footer.fillColor = [SKColor whiteColor];
    
    self.footer.position = CGPointMake(512, 50);
    //  self.footer.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 120) toPoint:CGPointMake(size.width, 120)];
    
    [self addChild:self.footer];
    
    
}

-(void)walkingCarillon:(CGPoint)location{
    
    CGSize screenSize = self.frame.size;
    CGFloat multiplierForDirection;
    float bearVelocity = screenSize.width / 3.0;
    
    //x and y distances for move
    // CGPoint moveDifference = CGPointMake(location.x - self.character.position.x, location.y - self.character.position.y);
    CGPoint moveDifference = CGPointMake(location.x - self.carillon.position.x, location.y - self.carillon.position.y);
    float distanceToMove = sqrtf(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y);
    
    float moveDuration = distanceToMove / bearVelocity;
    
    if (moveDifference.x < 0) {
        multiplierForDirection = 1;
    } else {
        multiplierForDirection = -1;
    }
    self.carillon.xScale = fabs(self.carillon.xScale) * multiplierForDirection;
    
    if ([self.carillon actionForKey:@"carillonMoving"]) {
        //stop just the moving to a new location, but leave the walking legs movement running
        [self.carillon removeActionForKey:@"carillonMoving"];
    }
    
    if (![self.carillon actionForKey:@"walkingInPlaceBear"]) {
        //if legs are not moving go ahead and start them
        // [self setupCharacterAnimation];  //start the bear walking
    }
    SKAction *moveAction = [SKAction moveToX:location.x duration:moveDuration];
    //    SKAction *moveAction = [SKAction moveTo:location duration:moveDuration];
    SKAction *doneAction = [SKAction runBlock:(dispatch_block_t)^() {
        [self characterMoveEnded];
    }];
    
    SKAction *moveActionWithDone = [SKAction sequence:@[moveAction,doneAction]];
    
    [self.carillon runAction:moveActionWithDone withKey:@"carillonMoving"];
    
}
-(void)characterMoveEnded{
    
    [self.carillon removeAllActions];
}

-(void)update:(NSTimeInterval)currentTime{
    
    if ([self actionForKey:@"catForeverLoop"] && self.bowlFull == YES && !self.stickerAnimationActive){
        [self removeActionForKey:@"catForeverLoop"];
        [self.cat removeActionForKey:@"catAnimationLoop"];
        
        [self catDrinksMilk];
        self.stickerAnimationActive = YES;
        [_stickerOne runStickerAnimation:_stickerOne.stickerStarTwo];
        [self setupCharacterHappyAnimation];
        
    }
    
    if (self.touchingRedCupSide1) {
        self.redCupSide1.position = self.touchingPoint;
        
    }
    
    if (self.touchingRedCupSide2) {
        self.redCupSide2.position = self.touchingPoint;
        
    }
    
    if (self.touchingBlueCupSide1) {
        self.blueCupSide1.position = self.touchingPoint;
        
    }
    
    if (self.touchingBlueCupSide2) {
        self.blueCupSide2.position = self.touchingPoint;
        
    }
    if (self.touchingYellowCupSide1) {
        self.yellowCupSide1.position = self.touchingPoint;
        
    }
    if (self.touchingYellowCupSide2) {
        self.yellowCupSide2.position = self.touchingPoint;
        
    }
    if (self.touchingBread) {
        self.bread.position = self.touchingPoint;
    }
    if (self.touchingBanana) {
        self.banana.position = self.touchingPoint;
    }
    if (self.touchingCake) {
        self.cake.position = self.touchingPoint;
    }
    if (self.touchingApple) {
        self.apple.position = self.touchingPoint;
    }
    if (self.touchingEatenBread) {
        self.eatenBread.position = self.touchingPoint;
    }
    if (self.touchingEatenCake) {
        self.eatenCake.position = self.touchingPoint;
    }
    if (self.touchingEatenBanana) {
        self.eatenBanana.position = self.touchingPoint;
    }
    if (self.touchingEatenApple) {
        self.eatenApple.position = self.touchingPoint;
    }
    if (self.touchingBottleOfMilk) {
        self.milkBottle.position = self.touchingPoint;
    }
    
    if (self.foodWasteCounter == 4 && self.binActive == YES) {
        [self.bin setTexture:[SKTexture textureWithImageNamed:@"kosz pelny"]];
        self.binActive = NO;
        [[SKTAudio sharedInstance]playSoundEffect:@"SFXSmieci.mp3"];
        [_stickerOne runStickerAnimation:_stickerOne.stickerStarThree];
        [self setupCharacterHappyAnimation];
    }
    if (self.foodCounter == 4 && self.foodActive == YES) {
        [_stickerOne runStickerAnimation:_stickerOne.stickerStarOne];
        [self setupCharacterHappyAnimation];
        self.foodActive = NO;
        
    }
    
    if (self.yellowCupCounter == 2 && self.yellowCupCounterActive == YES) {
        [_stickerOne runStickerAnimation:_stickerOne.stickerStarOne];
        self.yellowCupCounterActive = NO;
        self.yellowCupCounter = 0;
    }
    if (self.redCupCounter == 2 && self.redCupCounterActive == YES) {
        [_stickerOne runStickerAnimation:_stickerOne.stickerStarTwo];
        self.redCupCounterActive = NO;
        self.redCupCounter = 0;
        
    }
    if (self.blueCupCounter == 2 && self.blueCupCounterActive == YES) {
        [_stickerOne runStickerAnimation:_stickerOne.stickerStarThree];
        self.blueCupCounterActive = NO;
        self.blueCupCounter = 0;
        
        
    }
    
    
    if (self.stickerOne.stickerCounter == 3 && self.arrowActive == NO) {
        
        [self blinking];
    }
    
}
-(void)blinkingBackButton{
    SKAction *alphaUp = [SKAction fadeAlphaTo:1.0 duration:0.7];
    SKAction *alphaDown = [SKAction fadeAlphaTo:0.2 duration:0.7];
    SKAction *blinkSeq = [SKAction sequence:@[alphaDown, alphaUp]];
    // self.exitButtonActive = YES;
    [self.exitButton runAction:[SKAction repeatActionForever:blinkSeq]];
    
}
-(void)blinking{
    SKAction *alphaUp = [SKAction fadeAlphaTo:1.0 duration:0.7];
    SKAction *alphaDown = [SKAction fadeAlphaTo:0.2 duration:0.7];
    SKAction *blinkSeq = [SKAction sequence:@[alphaDown, alphaUp]];
    self.arrowActive = YES;
    [self.arrow runAction:[SKAction repeatActionForever:blinkSeq]];
    
}


@end
