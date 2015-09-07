//
//  wardrobe.h
//  gierka
//
//  Created by Marek Tomaszewski on 05/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Wardrobe : SKSpriteNode

@property (nonatomic) SKSpriteNode *pinkDress;
@property (nonatomic) SKSpriteNode *blackDress;
@property (nonatomic) SKSpriteNode *yellowHat;
@property (nonatomic) SKSpriteNode *blackHat;
@property (nonatomic) SKSpriteNode *shoeShort;
@property (nonatomic) SKSpriteNode *shoeLong;
@property (nonatomic) SKSpriteNode *trousers;
@property (nonatomic) SKSpriteNode *coat;

@property (nonatomic) CGPoint originalPinkDressPosition;



-(instancetype)initWardrobeWithPosition:(CGPoint)position;
@end
