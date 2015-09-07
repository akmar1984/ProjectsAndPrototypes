//
//  Worm.h
//  gierka
//
//  Created by Marek Tomaszewski on 20/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Worm : SKSpriteNode
@property (nonatomic) SKSpriteNode *worm;
-(instancetype)initWormWithPosition:(CGPoint)position;
-(void)setupWormAnimation;
-(void)hideTheWorm;
@end
