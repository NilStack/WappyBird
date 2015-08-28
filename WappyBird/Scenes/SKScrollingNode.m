//
//  SKScrollingNode.m
//  spritybird
//
//  Created by Alexis Creuzot on 09/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "SKScrollingNode.h"

@implementation SKScrollingNode


+ (id) scrollingNodeWithImageNamed:(NSString *)name inContainerWidth:(float) width
{
    UIImage * image = [UIImage imageNamed:name];
    
    SKScrollingNode * realNode = [SKScrollingNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(width, image.size.height)];
    realNode.scrollingSpeed = 1;
    
    float total = 0;
    while(total<(width + image.size.width)){
        SKSpriteNode * child = [SKSpriteNode spriteNodeWithImageNamed:name ];
        [child setAnchorPoint:CGPointZero];
        [child setPosition:CGPointMake(total, 0)];
        [realNode addChild:child];
        total+=child.size.width;
    }
    
    return realNode;
}


- (void) update:(NSTimeInterval)currentTime
{
    [self.children enumerateObjectsUsingBlock:^(SKNode * child, NSUInteger idx, BOOL *stop) {
        
        SKSpriteNode *spriteChild = (SKSpriteNode *)child;
        
        spriteChild.position = CGPointMake(spriteChild.position.x-self.scrollingSpeed, spriteChild.position.y);
        if (spriteChild.position.x <= -spriteChild.size.width){
            float delta = spriteChild.position.x+spriteChild.size.width;
            spriteChild.position = CGPointMake(spriteChild.size.width*(self.children.count-1)+delta, child.position.y);
        }
    }];
}

@end
