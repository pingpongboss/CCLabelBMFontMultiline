//
//  CCLabelBMFontMultiline.m
//
//  Created by Mark Wei on 6/14/11.
//

#import "CCLabelBMFontMultiline.h"

@interface CCLabelBMFontMultiline(Private) 
- (void)updateLabel;
@end

@implementation CCLabelBMFontMultiline

@synthesize label = label_;
@synthesize dimension = dimension_;
@synthesize alignment = alignment_;
@synthesize fntFile = fntFile_;

#pragma mark -
#pragma mark Lifecycle Methods

- (id)initWithString:(NSString *)string fntFile:(NSString *)font dimensions:(CGSize)size alignment:(CCLabelBMFontMultilineAlignment)alignment {
    self = [super init];
    if (self) {
        
        self.dimension = size;
        self.alignment = alignment;
        self.fntFile = font;
        
        self.contentSize = size;
        self.anchorPoint = ccp(0.5f, 0.5f);
        
        self.label = [CCLabelBMFont labelWithString:string fntFile:font];
        
        [self updateLabel];
    }
    return self;
}

+ (CCLabelBMFontMultiline *)labelWithString:(NSString *)string fntFile:(NSString *)font dimensions:(CGSize)size alignment:(CCLabelBMFontMultilineAlignment)alignment {
    return [[[CCLabelBMFontMultiline alloc] initWithString:string fntFile:font dimensions:size alignment:alignment] autorelease];
}

- (void)dealloc {
    self.label = nil;
    self.fntFile = nil;
    [super dealloc];
}

#pragma mark -

- (void)updateLabel {
    //Step 1: Make multiline
    
    NSString *multilineString = @"", *lastWord = @"";
    int line = 1, i = 0, stringLength = [[label_ string] length];
    float startOfLine = -1, startOfWord = -1;
    //Go through each character and insert line breaks as necessary
    for (CCSprite *characterSprite in self.label.children) {
        
        if (i >= stringLength || i < 0)
            break;
        
        unichar character = [[self.label string] characterAtIndex:i];
        
        if (startOfWord == -1)
            startOfWord = characterSprite.position.x - characterSprite.contentSize.width/2;
        if (startOfLine == -1)
            startOfLine = startOfWord;
        
        //Character is a line break
        //Put lastWord on the current line and start a new line
        //Reset lastWord
        if ([[NSCharacterSet newlineCharacterSet] characterIsMember:character]) {
            lastWord = [[lastWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByAppendingFormat:@"%C", character];
            multilineString = [multilineString stringByAppendingString:lastWord];
            lastWord = @"";
            startOfWord = -1;
            line++;
            startOfLine = -1;
            i++;
            
            //CCLabelBMFont do not have a character for new lines, so do NOT "continue;" in the for loop. Process the next character
            if (i >= stringLength || i < 0)
                break;
            character = [[self.label string] characterAtIndex:i];
            
            if (startOfWord == -1)
                startOfWord = characterSprite.position.x - characterSprite.contentSize.width/2;
            if (startOfLine == -1)
                startOfLine = startOfWord;
        }
        
        //Character is a whitespace
        //Put lastWord on current line and continue on current line
        //Reset lastWord
        if ([[NSCharacterSet whitespaceCharacterSet] characterIsMember:character]) {
            lastWord = [lastWord stringByAppendingFormat:@"%C", character];
            multilineString = [multilineString stringByAppendingString:lastWord];
            lastWord = @"";
            startOfWord = -1;
            i++;
            continue;
        }
        
        //Character is out of bounds
        //Do not put lastWord on current line. Add "\n" to current line to start a new line
        //Append to lastWord
        if (characterSprite.position.x + characterSprite.contentSize.width/2 - startOfLine > self.dimension.width) {
            lastWord = [lastWord stringByAppendingFormat:@"%C", character];
            NSString *trimmedString = [multilineString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            multilineString = [trimmedString stringByAppendingString:@"\n"];
            line++;
            startOfLine = -1;
            i++;
            continue;
        } else {
            //Character is normal
            //Append to lastWord
            lastWord = [lastWord stringByAppendingFormat:@"%C", character];
            i++;
            continue;
        }
    }
    
    multilineString = [multilineString stringByAppendingFormat:@"%@", lastWord];
    
    [self removeChild:self.label cleanup:YES];
    self.label = [CCLabelBMFont labelWithString:multilineString fntFile:self.fntFile];
    [self addChild:self.label];
    
    //Step 2: Make alignment
    
    switch (self.alignment) {
        case CenterAlignment:
            i = 0;
            int lineNumber = 0;
            //Go through line by line
            for (NSString *lineString in [multilineString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
                int lineWidth = 0;
                
                //Find index of last character in this line
                int index = i + [lineString length] - 1;
                if (index < 0 || index >= [self.label.children count])
                    continue;
                
                //Find position of last character on the line
                CCSprite *lastChar = [self.label.children objectAtIndex:index];
                
                lineWidth = lastChar.position.x + lastChar.contentSize.width/2;
                
                //Figure out how much to shift each character in this line horizontally
                float shift = self.label.contentSize.width/2 - lineWidth/2;
                
                if (shift != 0) {
                    int j = 0;
                    //For each character, shift it so that the line is center aligned
                    for (j = 0; j < [lineString length]; j++) {
                        index = i + j;
                        if (index < 0 || index >= [self.label.children count])
                            continue;
                        CCSprite *characterSprite = [self.label.children objectAtIndex:index];
                        characterSprite.position = ccpAdd(characterSprite.position, ccp(shift, 0));
                    }
                }
                i += [lineString length];
                lineNumber++;
            }
            break;
        case LeftAlignment:
        default:
            break;        
    }
    
    self.contentSize = self.label.contentSize;    
    self.label.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
}

//Draw the bounding box of this CCLabelBMFontMultiline for troubleshooting
/*
- (void)draw {
    glLineWidth(5);
    glColor4f(255, 0, 0, 255);
    ccDrawLine(ccp(0,0), ccp(0, self.contentSize.height));
    ccDrawLine(ccp(0,0), ccp(self.contentSize.width, 0));
    ccDrawLine(ccp(self.contentSize.width, 0), ccp(self.contentSize.width, self.contentSize.height));
    ccDrawLine(ccp(0, self.contentSize.height), ccp(self.contentSize.width, self.contentSize.height));
    ccDrawLine(ccp(0,0), ccp(self.contentSize.width, self.contentSize.height));
    ccDrawLine(ccp(0, self.contentSize.height), ccp(self.contentSize.width, 0));
}
*/

#pragma mark -
#pragma mark <CCLabelProtocol> Methods

- (void)setString:(NSString*)label {
    [self.label setString:label];
    [self updateLabel];
}
/** returns the string that is rendered */
-(NSString*)string {
    return [self.label string];
}

@end
