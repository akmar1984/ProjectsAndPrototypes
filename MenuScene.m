//
//  MenuScene.m
//  gierka
//
//  Created by Marek Tomaszewski on 09/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
#import "GameViewController.h"

@interface MenuScene()
@property (nonatomic)SKSpriteNode *buttonPlay;
@property (nonatomic)SKSpriteNode *buttonLevelSelect;

@property GameViewController *gameViewController;
@end
@implementation MenuScene
-(void)didMoveToView:(SKView *)view{
    
    [self setupBackgroundWithButtons];
    
}
-(void)setupBackgroundWithButtons{
    
    

    SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"menuBackground"];
    backgroundImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:backgroundImage];

    self.buttonPlay = [SKSpriteNode spriteNodeWithImageNamed:@"playButton"];
    self.buttonPlay.position = CGPointMake(self.size.width - self.buttonPlay.size.width - 80, self.buttonPlay.size.height + 20);
    [self addChild:self.buttonPlay];

    self.buttonLevelSelect = [SKSpriteNode spriteNodeWithImageNamed:@"levelSelectButton"];
    self.buttonLevelSelect.position = CGPointMake(self.size.width - self.buttonPlay.size.width - 80, self.buttonPlay.size.height - 150);
    [self addChild:self.buttonLevelSelect];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
}
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    
    CGPoint tapLocation = [recognizer locationInView:self.view];
    tapLocation = [self convertPointFromView:tapLocation];

    NSLog(@"here!");
    
    if ([self.buttonPlay containsPoint:tapLocation]) {
        [self goToTheNextScene:self.view];
    }
}
-(void)update:(NSTimeInterval)currentTime{
   
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//   NSLog(@"tap");
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        NSLog(@"tapppppp!");
//        if ([self.buttonPlay containsPoint:location]) {
//            NSLog(@"locationTapped?");
//            
//                   }
//    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchEnded");
}

-(void)goToTheNextScene:(SKView *)view{
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

    SKScene *nextScene = [[GameScene alloc]initWithSize:self.size];
    nextScene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKTransition *transition = [SKTransition fadeWithDuration:3];
    [view presentScene:nextScene transition:transition];
    
}
@end
