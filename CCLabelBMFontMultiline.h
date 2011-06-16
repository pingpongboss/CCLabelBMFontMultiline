//
//  CCLabelBMFontMultiline.h
//
//  Created by Mark Wei on 6/14/11.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {CenterAlignment, LeftAlignment} CCLabelBMFontMultilineAlignment;

@interface CCLabelBMFontMultiline : CCNode <CCLabelProtocol> {
    CCLabelBMFont *label_;
    CGSize dimension_;
    CCLabelBMFontMultilineAlignment alignment_;
    NSString *fntFile_;
}

@property (retain) CCLabelBMFont *label;
@property (assign) CGSize dimension;
@property (assign) CCLabelBMFontMultilineAlignment alignment;
@property (retain) NSString *fntFile;

- (id)initWithString:(NSString *)string fntFile:(NSString *)font dimensions:(CGSize)size alignment:(CCLabelBMFontMultilineAlignment)alignment;

+ (CCLabelBMFontMultiline *)labelWithString:(NSString *)string fntFile:(NSString *)font dimensions:(CGSize)size alignment:(CCLabelBMFontMultilineAlignment)alignment;

-(void) setString:(NSString*)label;
/** returns the string that is rendered */
-(NSString*) string;

@end
