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

static float alignmentItemPadding = 50;
static float menuItemPaddingCenter = 50;

@interface HelloWorldLayer ()

- (void)snapArrowsToEdge;

@end

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize label = label_;
@synthesize arrowsBar = arrowsBar_;
@synthesize arrows = arrows_;

#pragma mark -
#pragma mark Lifecycle Methods

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
        self.isTouchEnabled = YES;
        
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		// create and initialize a Label
		self.label = [CCLabelBMFontMultiline labelWithString:LongSentencesExample fntFile:@"markerFelt.fnt" width:size.width/1.5 alignment:CenterAlignment];
        self.label.debug = YES;
        
        self.arrowsBar = [CCSprite spriteWithFile:@"arrowsBar.png"];
        self.arrows = [CCSprite spriteWithFile:@"arrows.png"];
        
        [CCMenuItemFont setFontSize:20];
        CCMenuItemFont *longSentences = [CCMenuItemFont itemFromString:@"Long Flowing Sentences" target:self selector:@selector(stringChanged:)];
        CCMenuItemFont *lineBreaks = [CCMenuItemFont itemFromString:@"Short Sentences With Intentional Line Breaks" target:self selector:@selector(stringChanged:)];
        CCMenuItemFont *mixed = [CCMenuItemFont itemFromString:@"Long Sentences Mixed With Intentional Line Breaks" target:self selector:@selector(stringChanged:)];
        CCMenu *stringMenu = [CCMenu menuWithItems:longSentences, lineBreaks, mixed, nil];
        [stringMenu alignItemsVertically];
        
        [longSentences setColor:ccRED];
        lastSentenceItem_ = longSentences;
        longSentences.tag = LongSentences;
        lineBreaks.tag = LineBreaks;
        mixed.tag = Mixed;
        
        [CCMenuItemFont setFontSize:30];
        
        CCMenuItemFont *left = [CCMenuItemFont itemFromString:@"Left" target:self selector:@selector(alignmentChanged:)];
        CCMenuItemFont *center = [CCMenuItemFont itemFromString:@"Center" target:self selector:@selector(alignmentChanged:)];
        CCMenuItemFont *right = [CCMenuItemFont itemFromString:@"Right" target:self selector:@selector(alignmentChanged:)];
        CCMenu *alignmentMenu = [CCMenu menuWithItems:left, center, right, nil];
        [alignmentMenu alignItemsHorizontallyWithPadding:alignmentItemPadding];
        
        [center setColor:ccRED];
        lastAlignmentItem_ = center;
        left.tag = LeftAlign;
        center.tag = CenterAlign;
        right.tag = RightAlign;
	
		// position the label on the center of the screen
		self.label.position =  ccp( size.width/2 , size.height/2 );
        
        self.arrowsBar.visible = NO;
        
        float arrowsWidth = (ArrowsMax - ArrowsMin) * size.width;
        self.arrowsBar.scaleX = arrowsWidth / self.arrowsBar.contentSize.width;
        self.arrowsBar.position = ccp(((ArrowsMax + ArrowsMin) / 2) * size.width, self.label.position.y);
        
        [self snapArrowsToEdge];
        
        stringMenu.position = ccp(size.width/2, size.height - menuItemPaddingCenter);
        alignmentMenu.position = ccp(size.width/2, menuItemPaddingCenter);
        
		// add the label as a child to this Layer
		[self addChild:self.label];
        [self addChild:self.arrowsBar];
        [self addChild:self.arrows];
        [self addChild:stringMenu];
        [self addChild:alignmentMenu];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    self.label = nil;
    self.arrows = nil;
    self.arrowsBar = nil;
    
	[super dealloc];
}

#pragma mark -
#pragma mark Action Methods

- (void)stringChanged:(id)sender {
    CCMenuItemFont *item = sender;
    [item setColor:ccRED];
    [lastSentenceItem_ setColor:ccWHITE];
    lastSentenceItem_ = item;
    
    switch (item.tag) {
        case LongSentences:
            [self.label setString:LongSentencesExample];
            break;
        case LineBreaks:
            [self.label setString:LineBreaksExample];
            break;
        case Mixed:
            [self.label setString:MixedExample];
            break;
            
        default:
            break;
    }
    
    [self snapArrowsToEdge];
}

- (void)alignmentChanged:(id)sender {
    CCMenuItemFont *item = sender;
    [item setColor:ccRED];
    [lastAlignmentItem_ setColor:ccWHITE];
    lastAlignmentItem_ = item;
    
    switch (item.tag) {
        case LeftAlign:
            [self.label setAlignment:LeftAlignment];
            break;
        case CenterAlign:
            [self.label setAlignment:CenterAlignment];
            break;
        case RightAlign:
            [self.label setAlignment:RightAlignment];
            break;
            
        default:
            break;
    }
    
    [self snapArrowsToEdge];
}

#pragma mark -
#pragma mark Touch Methods

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    if (CGRectContainsPoint([self.arrows boundingBox], location)) {
        drag_ = YES;
        self.arrowsBar.visible = YES;
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    drag_ = NO;
    [self snapArrowsToEdge];
    
    self.arrowsBar.visible = NO;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!drag_) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    self.arrows.position = ccp(MAX(MIN(location.x, ArrowsMax*winSize.width), ArrowsMin*winSize.width), self.arrows.position.y);
    
    float labelWidth = abs(self.arrows.position.x - self.label.position.x) * 2;
    
    [self.label setWidth:labelWidth];
}

- (void)snapArrowsToEdge {
    self.arrows.position = ccp(self.label.position.x + self.label.contentSize.width/2, self.label.position.y);
}

@end
