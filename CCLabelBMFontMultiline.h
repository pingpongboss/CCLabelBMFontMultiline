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
    
    CGSize dimension_;
    CCLabelBMFontMultilineAlignment alignment_;
    
    BOOL debug_;
}

@property (nonatomic,assign,readonly) CGSize dimension;
@property (nonatomic,assign,readonly) CCLabelBMFontMultilineAlignment alignment;

@property (nonatomic,assign) BOOL debug;

- (id)initWithString:(NSString *)string fntFile:(NSString *)font dimensions:(CGSize)size alignment:(CCLabelBMFontMultilineAlignment)alignment;

+ (CCLabelBMFontMultiline *)labelWithString:(NSString *)string fntFile:(NSString *)font dimensions:(CGSize)size alignment:(CCLabelBMFontMultilineAlignment)alignment;

- (void)setString:(NSString*)label;

- (void)setDimension:(CGSize)dimension;
- (void)setAlignment:(CCLabelBMFontMultilineAlignment)alignment;

@end
