//
//  AppDelegate.h
//  CCLabelBMFontMultiline
//
//  Created by Mark Wei on 6/29/11.
//  Copyright UC Berkeley 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
