//
//  CCLabelBMFontMultiline.h
//
//  Created by Mark Wei on 6/14/11.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    CenterAlignment, LeftAlignment, RightAlignment
} CCLabelBMFontMultilineAlignment;

@interface CCLabelBMFontMultiline : CCLabelBMFont {
    NSString *initialString_;
    
    float width_;
    CCLabelBMFontMultilineAlignment alignment_;
    
    BOOL debug_;
}

@property (nonatomic,copy,readonly) NSString *initialString;

@property (nonatomic,assign,readonly) float width;
@property (nonatomic,assign,readonly) CCLabelBMFontMultilineAlignment alignment;

@property (nonatomic,assign) BOOL debug;

- (id)initWithString:(NSString *)string fntFile:(NSString *)font width:(float)width alignment:(CCLabelBMFontMultilineAlignment)alignment;

+ (CCLabelBMFontMultiline *)labelWithString:(NSString *)string fntFile:(NSString *)font width:(float)width alignment:(CCLabelBMFontMultilineAlignment)alignment;

- (void)setString:(NSString*)label;

- (void)setWidth:(float)width;
- (void)setAlignment:(CCLabelBMFontMultilineAlignment)alignment;

@end
