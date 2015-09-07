//
//  GameScene.h
//  gierka
//

//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@import AVFoundation;
@interface GameScene : SKScene <SKPhysicsContactDelegate>
@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@end
