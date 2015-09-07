//
//  GameViewController.h
//  gierka
//

//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
@import AVFoundation;
@interface GameViewController : UIViewController
@property BOOL mainMenuActive;
@property AVAudioPlayer *backgroundMusicPlayer;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (nonatomic) NSInteger levelNum;
-(void)fadeOutTheMusic;
@end
