//
//  BellBody.m
//  gierka
//
//  Created by Marek Tomaszewski on 06/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "BellBody.h"
#import "SKTUtils.h"
static const float MOVE_POINTS_PER_SEC = 120.0;


//static const float ZOMBIE_MOVE_POINTS_PER_SEC = 120.0;
//static const float ZOMBIE_ROTATE_RADIANS_PER_SEC = 4 * M_PI;
@implementation BellBody
-(instancetype)initBellWithBodyandHeadInPosition:(CGPoint)position{
    
    if (self = [super init]) {
        
        self.bellsBody = [SKSpriteNode spriteNodeWithImageNamed:@"BellBody"];
        self.bellsBody.position = position;
        self.bellsBody.name = @"charactersBody";
        [self addChild:self.bellsBody];
        self.bellsHead = [SKSpriteNode spriteNodeWithImageNamed:@"BellsHead"];
      
        [self.bellsBody addChild:self.bellsHead];
          self.bellsHead.position = CGPointMake(-5, 145);
        
        self.bellsBody.zPosition = 100;
        self.bellsHead.zPosition = 101;
    }
    
    return self;
}
-(instancetype)initBellWithBodyandHeadInPosition2:(CGPoint)position{
    
    if (self = [super init]) {
        
        self.bellsBody2 = [SKSpriteNode spriteNodeWithImageNamed:@"BellBodyinYellowShoesAndCoat3"];
        self.bellsBody2.position = position;
        self.bellsBody2.name = @"charactersBody2";
        [self addChild:self.bellsBody2];
        self.bellsHead2 = [SKSpriteNode spriteNodeWithImageNamed:@"bellYellowHatHead"];
        
        [self.bellsBody2 addChild:self.bellsHead2];
        self.bellsHead2.position = CGPointMake(-5, 145);
        
        self.bellsBody2.zPosition = 100;
        self.bellsHead2.zPosition = 101;
    }
    
    return self;
}

-(void)moveHeadTowards2:(CGPoint)location
{
    NSInteger side;
    if (location.x < self.bellsBody2.position.x) {
        side = -1;
    }else{
        side = 1;
    }
    //set -1 side !!
    CGPoint offset = CGPointSubtract(location, self.bellsHead2.position);
    CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y);
    
    CGPoint direction = CGPointMake(offset.x /length, offset.y / length);
    _velocity = CGPointMake(direction.x * MOVE_POINTS_PER_SEC, direction.y *MOVE_POINTS_PER_SEC);
    
    
    SKConstraint *angleConstraint = [SKConstraint zRotation:[SKRange rangeWithLowerLimit:-M_PI /8  upperLimit:M_PI /8]];
    self.bellsHead2.constraints = @[angleConstraint];
    self.bellsHead2.zRotation = CGPointToAngle(_velocity);
    SKAction *rotate = [SKAction rotateToAngle:self.bellsHead2.zRotation *side duration:2];
    if (self.bellsHead2) {
        [self.bellsHead2 runAction:rotate];
        
    }
    
}

-(void)moveHeadTowards:(CGPoint)location
{
    NSInteger side;
    if (location.x < self.bellsBody.position.x) {
        side = -1;
    }else{
        side = 1;
    }

    CGPoint offset = CGPointSubtract(location, self.bellsHead.position);
    CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y);
    
    CGPoint direction = CGPointMake(offset.x /length, offset.y / length);
    _velocity = CGPointMake(direction.x * MOVE_POINTS_PER_SEC, direction.y *MOVE_POINTS_PER_SEC);
    
   
       SKConstraint *angleConstraint = [SKConstraint zRotation:[SKRange rangeWithLowerLimit:-M_PI /8  upperLimit:M_PI /8]];
    self.bellsHead.constraints = @[angleConstraint];
     self.bellsHead.zRotation = CGPointToAngle(_velocity);
    SKAction *rotate = [SKAction rotateToAngle:self.bellsHead.zRotation *side duration:2];
    if (self.bellsHead) {
        [self.bellsHead runAction:rotate];

    }

}
@end
