//
//  HelloWorldLayer.h
//  CCLabelBMFontMultiline
//
//  Created by Mark Wei on 6/29/11.
//  Copyright UC Berkeley 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
@class CCLabelBMFontMultiline;

#define LongSentencesExample @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
#define LineBreaksExample @"Lorem ipsum dolor\nsit amet\nconsectetur adipisicing elit"
#define MixedExample @"ABC\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt\nDEF"

#define ArrowsMax 0.95
#define ArrowsMin 0.7

#define LeftAlign 0
#define CenterAlign 1
#define RightAlign 2

#define LongSentences 0
#define LineBreaks 1
#define Mixed 2

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCLabelBMFontMultiline *label_;
    CCSprite *arrows_;
    
    BOOL drag_;
}

@property (nonatomic,retain) CCLabelBMFontMultiline *label;
@property (nonatomic,retain) CCSprite *arrows;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
