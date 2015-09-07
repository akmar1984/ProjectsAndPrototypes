//
//  TheEndScene.m
//  gierka
//
//  Created by Marek Tomaszewski on 28/03/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "TheEndScene.h"
#import "SKTAudio.h"
#import "MainMenuViewController.h"
#import "GameViewController.h"
#import "GameScene.h"

@interface TheEndScene()
@property SKLabelNode *theEndLabel;
@property SKLabelNode *creditsLabel;
@property SKLabelNode *playAgainLabel;



@end
@implementation TheEndScene


-(void)didMoveToView:(SKView *)view{
    
    
    SKSpriteNode *bkg = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:CGSizeMake(1024, 768)];
    bkg.anchorPoint = CGPointZero;
    bkg.position = CGPointZero;
   [self addChild:bkg];
    
    [self setupLabels];
    SKAction *fadeIn = [SKAction fadeInWithDuration:3];
    
    [self.playAgainLabel runAction:fadeIn];
//    SKAction *wait = [SKAction waitForDuration:1];
//    SKAction *fadeOut = [SKAction fadeOutWithDuration:1];
//    
//    SKAction *seq = [SKAction sequence:@[wait, fadeOut]];
//    [self.theEndLabel runAction:seq completion:^{
// 
//        
//        [self.creditsLabel runAction:fadeIn];
//   
//    }];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
       for (UITouch *touch in touches){
       CGPoint location =  [touch locationInNode:self];
        
           if ([self.playAgainLabel containsPoint:location]){
               
               [self loadTheFirstScene];
           }
        
         
    }
}

-(void)loadTheFirstScene{
    
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    SKScene *gameScene = [[GameScene alloc]initWithSize:self.size];
    gameScene.scaleMode = SKSceneScaleModeAspectFill;
    // [self fadeOutTheMusic];
    [[SKTAudio sharedInstance]pauseSoundEffect];
    [[SKTAudio sharedInstance]pauseSoundEffectInaLoop];
    [[SKTAudio sharedInstance]pauseBackgroundMusic];
    SKTransition *transition = [SKTransition fadeWithColor:[UIColor blackColor] duration:5];
    // Present the scene.
    [self.view presentScene:gameScene transition:transition];
}
-(void)setupLabels{
//    self.theEndLabel = [SKLabelNode labelNodeWithFontNamed:@"OriyaSangamMN-Bold"];
//    self.theEndLabel.text = @"THE END";
//    self.theEndLabel.fontSize = 74;
//    self.theEndLabel.color = [SKColor whiteColor];
//    self.theEndLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
//    self.theEndLabel.alpha = 0;
//    [self addChild:self.theEndLabel];
//    
//    self.creditsLabel = [SKLabelNode labelNodeWithFontNamed:@"OriyaSangamMN-Bold"];
//   // self.creditsLabel.text = @"Programming - Marek Tomaszewski\nGame Design - Marta Carillon, Marek Tomaszewski\nMusic/Sound Design - Marta Carillon\nIllustration - Pawel Krol";
//    self.creditsLabel.text = @"Play Again?";
//    self.creditsLabel.fontSize = 60;
//    self.creditsLabel.color = [SKColor whiteColor];
//    self.creditsLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
//    self.creditsLabel.alpha = 0;
//    [self addChild:self.creditsLabel];
    
    
    self.playAgainLabel = [SKLabelNode labelNodeWithFontNamed:@"OriyaSangamMN-Bold"];
    self.playAgainLabel.text = NSLocalizedString(@"Play Again?", nil) ;
    self.playAgainLabel.fontSize = 60;
    self.playAgainLabel.color = [SKColor whiteColor];
    self.playAgainLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
    self.playAgainLabel.alpha = 0;
    [self addChild:self.playAgainLabel];

    
}

-(void)animateTheLabel:(SKLabelNode *)label{
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:3];
    
    [label runAction:fadeIn];
}
@end
