//
//  Baloon.h
//  gierka
//
//  Created by Marek Tomaszewski on 24/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Baloon : SKSpriteNode
@property (nonatomic) SKSpriteNode *baloon;

-(instancetype)initBaloonWithPosition:(CGPoint)position;
-(void)setupBaloonAnimation;
-(void)killTheBaloon;
@end
