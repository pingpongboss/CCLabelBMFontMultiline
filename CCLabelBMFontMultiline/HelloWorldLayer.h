//
//  HelloWorldLayer.h
//  CCLabelBMFontMultiline
//
//  Created by Mark Wei on 6/29/11.
//  Copyright UC Berkeley 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#define LongSentence @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
#define LabelTag 0

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
