//
//  BellBody.h
//  gierka
//
//  Created by Marek Tomaszewski on 06/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BellBody : SKSpriteNode{
    CGPoint _velocity;
}
@property (nonatomic)SKSpriteNode *bellsHead;
@property (nonatomic)SKSpriteNode *bellsBody;
@property (nonatomic)SKSpriteNode *bellsHead2;
@property (nonatomic)SKSpriteNode *bellsBody2;
-(instancetype)initBellWithBodyandHeadInPosition:(CGPoint)position;
-(instancetype)initBellWithBodyandHeadInPosition2:(CGPoint)position;

-(void)moveHeadTowards:(CGPoint)location;
-(void)moveHeadTowards2:(CGPoint)location;

@end
