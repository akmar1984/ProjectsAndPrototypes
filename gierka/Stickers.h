//
//  Stickers.h
//  gierka
//
//  Created by Marek Tomaszewski on 03/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Stickers : SKSpriteNode
@property (nonatomic) SKSpriteNode *stickerStarOne;
@property (nonatomic) SKSpriteNode *stickerStarTwo;
@property (nonatomic) SKSpriteNode *stickerStarThree;
@property (nonatomic) SKSpriteNode *stickersForms;
@property (nonatomic, assign) int stickerCounter;
-(instancetype)initStickerWithPosition:(CGPoint)position andStickerFormsPosition:(CGPoint)position2;
-(void)runStickerAnimation:(SKSpriteNode *)sticker;
-(void)addStarsInPosition:(CGPoint)position;
@end
