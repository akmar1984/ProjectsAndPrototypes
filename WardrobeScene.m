//
//  WardrobeScene.m
//  gierka
//
//  Created by Marek Tomaszewski on 05/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "WardrobeScene.h"
#import "Wardrobe.h"
#import "BellBody.h"
#import "SKTUtils.h"
#import "GameScene4.h"
#import "Stickers.h"
#import "SKTAudio.h"

@interface WardrobeScene ()
@property (nonatomic)SKSpriteNode *wardrobe;
@property (nonatomic)SKSpriteNode *soundIcon;
@property (nonatomic)SKSpriteNode *arrow;
@property (nonatomic)BOOL musicOn;
@property (nonatomic) Stickers *stickerOne;
@property (nonatomic) SKNode *stickerOneNode;
@property BOOL arrowActive;
@property BOOL clothesTouchesActive;
@property (nonatomic) CGPoint currentPosition;
@property (nonatomic) CGPoint originalPosition;
@property (nonatomic) SKAction *zoomIn;
@property (nonatomic) SKAction *zoomOut;
@property (nonatomic) SKShapeNode *footer;

@end
static const int CLOTHES_OFFSET = 50;
static const int BODY_OFFSET = 150;

@implementation WardrobeScene
{
    
    SKNode *_wardrobeNode;
    SKNode *_clothesNode;
    SKNode *_blackDressNode;
    SKNode *_bellNode;
    
    
    Wardrobe *_wardrobeObject;
    BellBody *_bellBodyObject;
    BOOL _touchingPinkDress;
    BOOL _touchingBlackDress;
    BOOL _touchingTrousers;
    BOOL _touchingShoeShort;
    BOOL _touchingShoeLong;
    BOOL _touchingYellowHat;
    BOOL _touchingBlackHat;
    
    
    
    BOOL _wardrobeClosed;
    BOOL _touchingCoat;
    BOOL _touchingNode;
    BOOL _yellowCoatActive;
    BOOL _yellowShoeShortActive;
    BOOL _yellowHatActive;
    
    
}
-(void)didMoveToView:(SKView *)view{
    self.zoomIn = [SKAction scaleTo:1.2 duration:0.5];
    self.zoomOut = [SKAction scaleTo:1.0 duration:0.5];
    
    [[SKTAudio sharedInstance]playBackgroundMusic:@"BellSZAFA.mp3"];
    self.musicOn = YES;

    self.wardrobe = (SKSpriteNode *)[self childNodeWithName:@"wardrobe"];
    _wardrobeClosed = YES;
    _bellBodyObject = [[BellBody alloc] initBellWithBodyandHeadInPosition:CGPointMake(180, 180)];
    _bellNode = [SKNode node];
    
    [_bellNode addChild:_bellBodyObject];
    [self addChild:_bellNode];
    [self setButtons];
    [self setupStickers];
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
        [[SKTAudio sharedInstance]playBackgroundMusic:@"BellSZAFA.mp3"];
        
        
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
-(void)setupStickers{
    
    self.stickerOneNode = [SKNode node];
    self.stickerOne = [[Stickers alloc]initStickerWithPosition:CGPointMake(0, 768)andStickerFormsPosition:CGPointMake(130, 50)];
    [self.stickerOneNode addChild:self.stickerOne];
    [self addChild:self.stickerOneNode];
}
-(void)openWardrobeWithClothes{
    
    [self.wardrobe setTexture:[SKTexture textureWithImageNamed:@"szafa otwarta"]];
    self.clothesTouchesActive = YES;
    
    self.wardrobe.size = self.wardrobe.texture.size;
    
    // _clothesNode = [SKNode node];
    _wardrobeObject = [[Wardrobe alloc]initWardrobeWithPosition:CGPointMake(self.size.width/2 -  CLOTHES_OFFSET, 550)];
    // [_clothesNode addChild:_wardrobeObject];
    _wardrobeClosed = NO;
    [self addChild:_wardrobeObject];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        
        
        [_bellBodyObject moveHeadTowards:location];
        
        
        if   ([self.soundIcon containsPoint:location]){
            
            [self showSoundButtonForTogglePosition:self.musicOn];
        }
        
        if ([self.wardrobe containsPoint:location] && _wardrobeClosed) {
            [[SKTAudio sharedInstance]playSoundEffect:@"SFXszafa.mp3"];
            [self openWardrobeWithClothes];
        }
        
        if (self.clothesTouchesActive) {
            
            if ([_wardrobeObject.blackDress containsPoint:location]) {
                _touchingBlackDress = YES;
                [_wardrobeObject.blackDress runAction:self.zoomIn];
                self.originalPosition = _wardrobeObject.blackDress.position;
                self.currentPosition = location;
            }
            if ([_wardrobeObject.trousers containsPoint:location]) {
                _touchingTrousers = YES;
                [_wardrobeObject.trousers runAction:self.zoomIn];
                self.originalPosition = _wardrobeObject.trousers.position;
                self.currentPosition = location;
            }
            
            
            if ([_wardrobeObject.pinkDress containsPoint:location]) {
                _touchingPinkDress = YES;
                [_wardrobeObject.pinkDress runAction:self.zoomIn];
                self.originalPosition = _wardrobeObject.pinkDress.position;
                self.currentPosition = location;
            }
            if ([_wardrobeObject.coat containsPoint:location]) {
                _touchingCoat = YES;
                [_wardrobeObject.coat runAction:self.zoomIn];
                self.currentPosition = location;
                self.originalPosition = _wardrobeObject.coat.position;
            }
            if ([_wardrobeObject.shoeShort containsPoint:location]) {
                _touchingShoeShort = YES;
                [_wardrobeObject.shoeShort runAction:self.zoomIn];
                self.currentPosition = location;
                self.originalPosition = _wardrobeObject.shoeShort.position;
            }
            if ([_wardrobeObject.shoeLong containsPoint:location]) {
                _touchingShoeLong = YES;
                [_wardrobeObject.shoeLong runAction:self.zoomIn];
                self.currentPosition = location;
                self.originalPosition = _wardrobeObject.shoeLong.position;
            }
            if ([_wardrobeObject.yellowHat containsPoint:location]) {
                _touchingYellowHat = YES;
                [_wardrobeObject.yellowHat runAction:self.zoomIn];
                self.currentPosition = location;
                self.originalPosition = _wardrobeObject.yellowHat.position;
            }
            if ([_wardrobeObject.blackHat containsPoint:location]) {
                _touchingBlackHat = YES;
                [_wardrobeObject.blackHat runAction:self.zoomIn];
                self.currentPosition = location;
                self.originalPosition = _wardrobeObject.blackHat.position;
            }
            if ([_bellBodyObject.bellsBody containsPoint:location] || [_bellBodyObject.bellsHead containsPoint:location]) {
                [self bellRandomNoises];
                
            }
        }
    }
    
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
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    self.currentPosition = [[touches anyObject]locationInNode:self];
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    for (UITouch *touch in touches) {
        CGPoint currentLocation = [touch locationInNode:self];
        
        
        if ([self.arrow containsPoint:currentLocation] && self.arrowActive) {
            
            SKView * skView = (SKView *)self.view;
            skView.showsFPS = NO;
            skView.showsNodeCount = NO;
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = YES;
            [[SKTAudio sharedInstance]pauseBackgroundMusic];
            // Create and configure the scene.
            SKScene *gameScene4 = [[GameScene4 alloc]initWithSize:self.size];
            gameScene4.scaleMode = SKSceneScaleModeAspectFill;
            
            SKTransition *transition = [SKTransition fadeWithColor:[UIColor blackColor] duration:3];
            // Present the scene.
            [self.view presentScene:gameScene4 transition:transition];
        }
        if (_touchingPinkDress) {
            if ([self isWithinCharactersBody:currentLocation]) {
                
                [self putTheClothesOnCharacter:_wardrobeObject.pinkDress inPosition:currentLocation];
                
            }
            else
                [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniaNiePasuja.mp3"];
            _wardrobeObject.pinkDress.position = self.originalPosition;
            _touchingPinkDress = NO;
            [_wardrobeObject.pinkDress runAction:self.zoomOut];
            
        }
        
        if (_touchingBlackDress) {
            if ([self isWithinCharactersBody:currentLocation]) {
                
                [self putTheClothesOnCharacter:_wardrobeObject.blackDress inPosition:currentLocation];
                
            }
            else
                [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniaNiePasuja.mp3"];
            _wardrobeObject.blackDress.position = self.originalPosition;
            _touchingBlackDress = NO;
            [_wardrobeObject.blackDress runAction:self.zoomOut];
            
        }
        
        if (_touchingCoat) {
            
            if ([self isWithinCharactersBody:currentLocation]) {
                
                [self putTheClothesOnCharacter:_wardrobeObject.coat inPosition:currentLocation];
            }else
                [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniaNiePasuja.mp3"];
            _wardrobeObject.coat.position = self.originalPosition;
            _touchingCoat = NO;
            [_wardrobeObject.coat runAction:self.zoomOut];
            
        }
        
        
        if (_touchingShoeShort) {
            if ([self isWithinCharactersBody:currentLocation]) {
                
                [self putTheClothesOnCharacter:_wardrobeObject.shoeShort inPosition:currentLocation];
                
            }
            else
                [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniaNiePasuja.mp3"];
            _wardrobeObject.shoeShort.position = self.originalPosition;
            _touchingShoeShort = NO;
            [_wardrobeObject.shoeShort runAction:self.zoomOut];
            
        }
        
        if (_touchingShoeLong) {
            if ([self isWithinCharactersBody:currentLocation]) {
                
                [self putTheClothesOnCharacter:_wardrobeObject.shoeLong inPosition:currentLocation];
                
            }
            else
                [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniaNiePasuja.mp3"];
            _wardrobeObject.shoeLong.position = self.originalPosition;
            _touchingShoeLong = NO;
            [_wardrobeObject.shoeLong runAction:self.zoomOut];
            
        }
        if (_touchingTrousers) {
            if ([self isWithinCharactersBody:currentLocation]) {
                
                [self putTheClothesOnCharacter:_wardrobeObject.trousers inPosition:currentLocation];
                
            }
            else
                [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniaNiePasuja.mp3"];
            _wardrobeObject.trousers.position = self.originalPosition;
            _touchingTrousers = NO;
            [_wardrobeObject.trousers runAction:self.zoomOut];
            
        }
        
        if (_touchingYellowHat) {
            if ([self isWithinCharactersHead:currentLocation]) {
                
                [self putTheClothesOnCharacter:_wardrobeObject.yellowHat inPosition:currentLocation];
                
            }
            else
                [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniaNiePasuja.mp3"];
            _wardrobeObject.yellowHat.position = self.originalPosition;
            _touchingYellowHat = NO;
            [_wardrobeObject.yellowHat runAction:self.zoomOut];
            
        }
        if (_touchingBlackHat) {
            if ([self isWithinCharactersHead:currentLocation]) {
                
                [self putTheClothesOnCharacter:_wardrobeObject.blackHat inPosition:currentLocation];
                
            }
            else
                [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniaNiePasuja.mp3"];
            _wardrobeObject.blackHat.position = self.originalPosition;
            _touchingBlackHat = NO;
            [_wardrobeObject.blackHat runAction:self.zoomOut];
            
        }
        
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

-(void)putTheClothesOnCharacter:(SKSpriteNode *)node inPosition:(CGPoint)currentLocation{
    
    
    if ([node.name isEqualToString:@"ciuch5bodyOnly"] && !_yellowShoeShortActive) {
        [_bellBodyObject.bellsBody setTexture:[SKTexture textureWithImageNamed:node.name]];
        _bellBodyObject.bellsBody.size = _bellBodyObject.bellsBody.texture.size;
        [node removeFromParent];
        _yellowCoatActive = YES;
        [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniePasuje.mp3"];
        [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarThree];
                [self setupCharacterHappyAnimation];
        
    }else if ([node.name isEqualToString:@"ciuch5bodyOnly"] && _yellowShoeShortActive) {
        [_bellBodyObject.bellsBody setTexture:[SKTexture textureWithImageNamed:@"BellBodyinYellowShoesAndCoat"]];
        _bellBodyObject.bellsBody.size = _bellBodyObject.bellsBody.texture.size;
        [node removeFromParent];
        _yellowCoatActive = YES;
                [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniePasuje.mp3"];
        [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarThree];
                [self setupCharacterHappyAnimation];
        
        
    }else if([node.name isEqualToString:@"shoeShort"] && !_yellowCoatActive) {
        [_bellBodyObject.bellsBody setTexture:[SKTexture textureWithImageNamed:@"BellBodyinYellowShoes"]];
        _bellBodyObject.bellsBody.size = _bellBodyObject.bellsBody.texture.size;
        [node removeFromParent];
        _yellowShoeShortActive = YES;
        [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarTwo];
                [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniePasuje.mp3"];
                [self setupCharacterHappyAnimation];
    }else if([node.name isEqualToString:@"shoeShort"] && _yellowCoatActive) {
        [_bellBodyObject.bellsBody setTexture:[SKTexture textureWithImageNamed:@"BellBodyinYellowShoesAndCoat"]];
        _bellBodyObject.bellsBody.size = _bellBodyObject.bellsBody.texture.size;
        [node removeFromParent];
        _yellowShoeShortActive = YES;
        [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarTwo];
                [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniePasuje.mp3"];
        [self setupCharacterHappyAnimation];
    }else if([node.name isEqualToString:@"yellowHat"] && !_yellowHatActive) {
        [_bellBodyObject.bellsHead setTexture:[SKTexture textureWithImageNamed:@"bellYellowHatHead"]];
        _bellBodyObject.bellsHead.size = _bellBodyObject.bellsHead.texture.size;
        [node removeFromParent];
                [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniePasuje.mp3"];
        _yellowHatActive = YES;
        [self.stickerOne runStickerAnimation:self.stickerOne.stickerStarOne];
                [self setupCharacterHappyAnimation];
    }else
        
    {
        [self animateWrongClothesNode:node];
    }
    
    
    
}
-(void)animateWrongClothesNode:(SKSpriteNode *)node
{
    [[SKTAudio sharedInstance]playSoundEffect:@"SFXUbraniaNiePasuja.mp3"];
    self.clothesTouchesActive = NO;
    SKAction *scaleDown = [SKAction scaleTo:1.0 duration:0.5];
    SKAction *moveLeft = [SKAction moveByX:-10 y:0 duration:0.2];
    SKAction *moveRight = [SKAction moveByX:10 y:0 duration:0.2];
    
    SKAction *fastMovementSeq = [SKAction repeatAction:[SKAction sequence:@[moveLeft, moveRight]] count:2];
    SKAction *moveBack = [SKAction moveTo:self.originalPosition duration: 1];
    SKAction *rotateBack = [SKAction rotateByAngle:M_PI *2 duration:0.5];
    SKAction *group = [SKAction group:@[moveBack, rotateBack]];
    ;
    
    SKAction *seq =[SKAction sequence: @[scaleDown, fastMovementSeq, group]];
    
    [node runAction:seq completion:^{
        
        self.clothesTouchesActive = YES;
        
    }];
    
}
-(BOOL)isWithinCharactersBody:(CGPoint)currentLocation{
    if (currentLocation.x >= _bellBodyObject.bellsBody.position.x - BODY_OFFSET && currentLocation.x <= _bellBodyObject.bellsBody.position.x + BODY_OFFSET && currentLocation.y >= _bellBodyObject.bellsBody.position.y - BODY_OFFSET && currentLocation.y <= _bellBodyObject.bellsBody.position.y + BODY_OFFSET){
        
        return YES;
    }else
        
        return NO;
}
-(BOOL)isWithinCharactersHead:(CGPoint)currentLocation{
   
 if (currentLocation.x >= 180 - BODY_OFFSET && currentLocation.x <= 180 + BODY_OFFSET && currentLocation.y >= 180 - 50 && currentLocation.y <= 180 + 250){

        return YES;
     
    }else

        return NO;
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    _touchingPinkDress = NO;
    _touchingCoat = NO;
    _touchingBlackDress = NO;
    _touchingShoeShort = NO;
    _touchingShoeLong = NO;
    _touchingYellowHat = NO;
    _touchingBlackDress = NO;
    _touchingTrousers = NO;
    
    
}
-(void)update:(NSTimeInterval)currentTime{
    if (_touchingPinkDress) {
        _wardrobeObject.pinkDress.position = self.currentPosition;
    }
    if (_touchingCoat) {
        _wardrobeObject.coat.position = self.currentPosition;
    }
    if (_touchingBlackDress) {
        _wardrobeObject.blackDress.position = self.currentPosition;
    }
    if (_touchingShoeShort) {
        _wardrobeObject.shoeShort.position = self.currentPosition;
    }
    if (_touchingShoeLong) {
        _wardrobeObject.shoeLong.position = self.currentPosition;
    }
    if (_touchingYellowHat) {
        _wardrobeObject.yellowHat.position = self.currentPosition;
    }
    if (_touchingBlackHat) {
        _wardrobeObject.blackHat.position = self.currentPosition;
    }
    if (_touchingTrousers) {
        _wardrobeObject.trousers.position = self.currentPosition;
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



-(void)setButtons{
    
    
    self.soundIcon = [SKSpriteNode spriteNodeWithImageNamed:@"glosnik"];
    self.soundIcon.position = CGPointMake(self.soundIcon.size.width+ 50, self.size.height-self.soundIcon.size.height);
    self.soundIcon.zPosition = 100;
    [self addChild:self.soundIcon];
    
    self.arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrowRight"];
    self.arrow.position = CGPointMake(self.size.width-self.arrow.size.width/2, self.arrow.size.height);
    self.arrow.zPosition = 102;
    self.arrow.alpha = 0.5;
    self.arrowActive = NO;
    [self addChild:self.arrow];
    
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

@end
