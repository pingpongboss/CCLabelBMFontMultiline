//
//  CCLabelBMFontMultiline.m
//
//  Created by Mark Wei on 6/14/11.
//  https://github.com/pingpongboss/CCLabelBMFontMultiline

#import "CCLabelBMFontMultiline.h"

@interface CCLabelBMFontMultiline()

- (void)updateLabel;

@end

@implementation CCLabelBMFontMultiline

@synthesize initialString = initialString_;

@synthesize width = width_;
@synthesize alignment = alignment_;

@synthesize debug = debug_;

#pragma mark -
#pragma mark Lifecycle Methods

- (id)initWithString:(NSString *)string fntFile:(NSString *)font width:(float)width alignment:(CCLabelBMFontMultilineAlignment)alignment {
    self = [super initWithString:string fntFile:font];
    if (self) {
        initialString_ = [string copy];
        
        width_ = width;
        alignment_ = alignment;        
        
        [self updateLabel];
    }
    return self;
}

+ (CCLabelBMFontMultiline *)labelWithString:(NSString *)string fntFile:(NSString *)font width:(float)width alignment:(CCLabelBMFontMultilineAlignment)alignment {
    return [[[CCLabelBMFontMultiline alloc] initWithString:string fntFile:font width:width alignment:alignment] autorelease];
}

- (void)dealloc {
    [initialString_ release], initialString_ = nil;
    
    [super dealloc];
}

#pragma mark -

- (void)updateLabel {
    
    [string_ release];
    string_ = [initialString_ copy];
    
    [self removeAllChildrenWithCleanup:YES]; //Inserted so fontChars do not get reused
    
    [self createFontChars];
    
    //Step 1: Make multiline
    
    NSString *multilineString = @"", *lastWord = @"";
    int line = 1, i = 0, stringLength = [self.string length];
    float startOfLine = -1, startOfWord = -1;
    //Go through each character and insert line breaks as necessary
    for (CCSprite *characterSprite in self.children) {
        
        if (i >= stringLength || i < 0)
            break;
        
        unichar character = [self.string characterAtIndex:i];
        
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
            character = [self.string characterAtIndex:i];
            
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
        if (characterSprite.position.x + characterSprite.contentSize.width/2 - startOfLine > self.width) {
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
    
    
    //Set the label's string to multilineString. But we don't want to use [super setString]
    //because -createFontChars does the "reusing fonts" bit which messes stuff up
    //
    //
    //Taken from CCLabelBMFont -(void)setString:(NSString *)label
    
    [string_ release];
     string_ = [multilineString copy];
    
    [self removeAllChildrenWithCleanup:YES]; //Inserted so fontChars do not get reused by -createFontChars
    
    [self createFontChars];
    
    //END Taken from CCLabelBMFont
    //
    //
    
    
    //Step 2: Make alignment
    
    if (self.alignment != LeftAlignment) {
        
        i = 0;
        int lineNumber = 0;
        //Go through line by line
        for (NSString *lineString in [multilineString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
            int lineWidth = 0;
            
            //Find index of last character in this line
            int index = i + [lineString length] - 1;
            if (index < 0 || index >= [self.children count])
                continue;
            
            //Find position of last character on the line
            CCSprite *lastChar = [self.children objectAtIndex:index];
            
            lineWidth = lastChar.position.x + lastChar.contentSize.width/2;
            
            //Figure out how much to shift each character in this line horizontally
            float shift = 0;
            switch (self.alignment) {
                case CenterAlignment:
                    shift = self.contentSize.width/2 - lineWidth/2;
                    break;
                case RightAlignment:
                    shift = self.contentSize.width - lineWidth;
                default:
                    break;
            }
            
            if (shift != 0) {
                int j = 0;
                //For each character, shift it so that the line is center aligned
                for (j = 0; j < [lineString length]; j++) {
                    index = i + j;
                    if (index < 0 || index >= [self.children count])
                        continue;
                    CCSprite *characterSprite = [self.children objectAtIndex:index];
                    characterSprite.position = ccpAdd(characterSprite.position, ccp(shift, 0));
                }
            }
            i += [lineString length];
            lineNumber++;
        }
    }
}

//Draw the bounding box of this CCLabelBMFontMultiline for troubleshooting
- (void)draw {
    [super draw];
    
    if (debug_) {
        glLineWidth(5);
        glColor4f(255, 0, 0, 255);
        ccDrawLine(ccp(0,0), ccp(0, self.contentSize.height));
        ccDrawLine(ccp(0,0), ccp(self.contentSize.width, 0));
        ccDrawLine(ccp(self.contentSize.width, 0), ccp(self.contentSize.width, self.contentSize.height));
        ccDrawLine(ccp(0, self.contentSize.height), ccp(self.contentSize.width, self.contentSize.height));
        ccDrawLine(ccp(0,0), ccp(self.contentSize.width, self.contentSize.height));
        ccDrawLine(ccp(0, self.contentSize.height), ccp(self.contentSize.width, 0));
    }
}

#pragma mark -
#pragma mark <CCLabelProtocol> Methods

- (void)setString:(NSString*)label {
    [initialString_ release];
    initialString_ = [label copy];
    
    [super setString:label];
    
    [self updateLabel];
}

#pragma mark -
#pragma mark Setter Methods

//Overwrite default setter methods

- (void)setWidth:(float)width {
    width_ = width;
    [self updateLabel];
}

- (void)setAlignment:(CCLabelBMFontMultilineAlignment)alignment {
    alignment_ = alignment;
    [self updateLabel];
}

@end
