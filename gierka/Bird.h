//
//  Bird.h
//  gierka
//
//  Created by Marek Tomaszewski on 03/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Bird : SKSpriteNode
@property (nonatomic)SKSpriteNode *birdBody;
@property (nonatomic)SKSpriteNode *birdHead;
-(instancetype)initBirdWithPosition:(CGPoint)position;
-(void)setupBirdAnimation;
@end
