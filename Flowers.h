//
//  Flowers.h
//  gierka
//
//  Created by Marek Tomaszewski on 26/01/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Flowers : SKSpriteNode
@property (nonatomic)SKSpriteNode *flowerOne;
@property (nonatomic)SKSpriteNode *flowerTwo;
@property (nonatomic)SKSpriteNode *flowerThree;
@property (nonatomic)SKSpriteNode *flowerFour;
@property (nonatomic)SKSpriteNode *flowerFive;
@property (nonatomic)SKSpriteNode *flowerSix;

@property (nonatomic)CGPoint flowerOneDestinationLocation;
@property (nonatomic)CGPoint flowerTwoDestinationLocation;
@property (nonatomic)CGPoint flowerThreeDestinationLocation;
@property (nonatomic)CGPoint flowerFourDestinationLocation;
@property (nonatomic)CGPoint flowerFiveDestinationLocation;
@property (nonatomic)CGPoint flowerSixDestinationLocation;

-(instancetype)initWithPosition:(CGPoint)position;
-(void)loadTexturesWithActionForFlower;
-(void)loadTexturesWithActionForFlowerTwo;
-(void)loadTexturesWithActionForFlowerThree;
-(void)loadAllFlowersAnimations;
-(void)unhideTheFlowers;
-(void)bounceFlowers;
@end
