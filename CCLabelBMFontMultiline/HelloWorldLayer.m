//
//  HelloWorldLayer.m
//  CCLabelBMFontMultiline
//
//  Created by Mark Wei on 6/29/11.
//  Copyright UC Berkeley 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "CCLabelBMFontMultiline.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		// create and initialize a Label
		CCLabelBMFontMultiline *label = [CCLabelBMFontMultiline labelWithString:LongSentence fntFile:@"markerFelt.fnt" dimensions:CGSizeMake(480, 320) alignment:LeftAlignment];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width/2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label z:0 tag:LabelTag];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
