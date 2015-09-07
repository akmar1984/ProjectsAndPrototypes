//
//  wardrobe.m
//  gierka
//
//  Created by Marek Tomaszewski on 05/02/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "Wardrobe.h"

static const int CLOTHES_SPACE_DOWN = 200;
static const int zPositionFront = 300;

@implementation Wardrobe
{
 SKTextureAtlas *_atlas;
}
-(instancetype)initWardrobeWithPosition:(CGPoint)position{
    
    if (self = [super init]) {
        
      //  _atlas = [SKTextureAtlas atlasNamed:@"clothes"];
        self.pinkDress = [SKSpriteNode spriteNodeWithImageNamed:@"rozowa sukienka.png"];
        self.pinkDress.position = position;
        self.originalPinkDressPosition = self.pinkDress.position;
        self.pinkDress.name = @"ciuch4bodyOnly";
        self.pinkDress.zPosition = zPositionFront;
        [self addChild:self.pinkDress];
        self.blackDress = [SKSpriteNode spriteNodeWithImageNamed:@"czarna sukienka"];
        self.blackDress.position = CGPointMake(position.x, position.y - CLOTHES_SPACE_DOWN);
        self.blackDress.zPosition = zPositionFront;
        self.blackDress.name = @"czarna sukienka";
        [self addChild:self.blackDress];
        self.trousers = [SKSpriteNode spriteNodeWithImageNamed:@"portki"];
        self.trousers.position = CGPointMake(position.x + CLOTHES_SPACE_DOWN -50, position.y);
        self.trousers.zPosition = zPositionFront;
        
        [self addChild:self.trousers];
        
        self.yellowHat = [SKSpriteNode spriteNodeWithImageNamed:@"czapka"];
        self.yellowHat.position = CGPointMake(position.x +80, position.y - CLOTHES_SPACE_DOWN *2 +100);
        self.yellowHat.zPosition = zPositionFront;
        self.yellowHat.name = @"yellowHat";
        [self addChild:self.yellowHat];
        
        self.blackHat = [SKSpriteNode spriteNodeWithImageNamed:@"czarny kapelusz"];
        self.blackHat.position = CGPointMake(position.x +200, position.y - CLOTHES_SPACE_DOWN *2 +100);
        self.blackHat.zPosition = zPositionFront;
        [self addChild:self.blackHat];
        
        self.shoeShort = [SKSpriteNode spriteNodeWithImageNamed:@"but"];
        self.shoeShort.position = CGPointMake(position.x +50, position.y - CLOTHES_SPACE_DOWN *2);
        self.shoeShort.zPosition = zPositionFront;
        self.shoeShort.name = @"shoeShort";
        [self addChild:self.shoeShort];
        self.shoeLong = [SKSpriteNode spriteNodeWithImageNamed:@"but szafa"];
        self.shoeLong.position = CGPointMake(position.x +180, position.y - CLOTHES_SPACE_DOWN *2 );
        self.shoeLong.zPosition = zPositionFront;
        [self addChild:self.shoeLong];

        self.coat = [SKSpriteNode spriteNodeWithImageNamed:@"kurtka"];
        self.coat.position = CGPointMake(position.x + CLOTHES_SPACE_DOWN -50, position.y - CLOTHES_SPACE_DOWN);
        self.coat.zPosition = zPositionFront;
        self.coat.name = @"ciuch5bodyOnly";

        [self addChild:self.coat];
        
        
    }
    return self;
}
@end
