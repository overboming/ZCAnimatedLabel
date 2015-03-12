//
//  ZCAnimatedLabel.m
//  ZCAnimatedLabel
//
//  Created by Chen Zhang on 2/13/15.
//  Copyright (c) 2015 somewhere. All rights reserved.
//

#import "ZCAnimatedLabel.h"
#import "ZCEasingUtil.h"


@interface ZCAnimatedLabel ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval animationTime;
@property (nonatomic, assign) BOOL useDefaultDrawing;
@property (nonatomic, assign) BOOL drawsCharRect;
@property (nonatomic, assign) NSTimeInterval animationDurationTotal;
@property (nonatomic, assign) BOOL animatingAppear;
@property (nonatomic, strong) ZCCoreTextLayout *layoutTool;

@end

@implementation ZCAnimatedLabel

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if ([super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit
{
    self.backgroundColor = [UIColor clearColor];

    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerTick:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _displayLink.paused = YES;
    
    _animationDuration = 1;
    _animationDiff = 0.1;
    _appearDirection = ZCAnimatedLabelAppearDirectionFromBottom;
    _layoutTool = [[ZCCoreTextLayout alloc] init];
    _onlyDrawDirtyArea = YES;
    
    _useDefaultDrawing = YES;
    _text = @"";
    _font = [UIFont systemFontOfSize:10];
}


- (CGFloat) totoalAnimationDuration
{
    return self.animationDurationTotal;
}

- (void) timerTick: (id) sender
{
    self.animationTime += self.displayLink.duration;
    if (self.animationTime > self.animationDurationTotal) {
        self.displayLink.paused = YES;
        self.useDefaultDrawing = YES;
    }
    else { //update text attributeds array
        
        [self.layoutTool.textAttributes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ZCTextAttribute *attribute = self.layoutTool.textAttributes[idx];
            NSUInteger sequence = self.animatingAppear ? idx : (self.layoutTool.textAttributes.count - idx - 1);
            //udpate attribute according to progress
            CGFloat progress = 0;
            CGFloat startDelay = attribute.startDelay > 0 ? attribute.startDelay : sequence * self.animationDiff;
            NSTimeInterval timePassed = self.animationTime - startDelay;
            CGFloat duration = attribute.duration > 0 ? attribute.duration : self.animationDuration;
            if (timePassed > duration && !attribute.ended) {
                progress = 1;
                attribute.ended = YES; //ended
                CGRect dityRect = [self customRedrawAreaWithRect:self.bounds attribute:attribute];
                [self setNeedsDisplayInRect:dityRect];
            }
            else if (timePassed < 0) {
                progress = 0;
            }
            else {
                if (!attribute.ended) {
                    CGRect dityRect = [self customRedrawAreaWithRect:self.bounds attribute:attribute];
                    [self setNeedsDisplayInRect:dityRect];
                }
                progress = timePassed / duration;
                progress = progress > 1 ? 1 : progress;
            }
            attribute.progress = progress;
        }];
    }
}

- (void) _layoutForChangedString
{
    [self.layoutTool cleanLayout];
    if (!self.attributedString) {
        self.attributedString = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName : self.font}];
    }
    
    [self.layoutTool layoutWithAttributedString:self.attributedString constainedToSize:self.frame.size];
    __block CGFloat maxDuration = 0;
    [self.layoutTool.textAttributes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ZCTextAttribute *attribute = obj;
        [self customAttributeInit:attribute];
        
        CGFloat duration = attribute.duration > 0 ? attribute.duration : self.animationDuration;
        CGFloat startDelay = attribute.startDelay > 0 ? attribute.startDelay : idx * self.animationDiff;
        CGFloat realStartDelay = startDelay + duration;
        if (realStartDelay > maxDuration) {
            maxDuration = realStartDelay;
        }
    }];
    self.animationDurationTotal = maxDuration;
}

- (void) setNeedsDisplayInRect:(CGRect)rect
{
    if (self.onlyDrawDirtyArea) {
        [super setNeedsDisplayInRect:rect];
    }
    else {
        [super setNeedsDisplay];
    }
}

- (void) setAttributedString:(NSAttributedString *)attributedString
{
    _attributedString = attributedString;
    NSDictionary *attributes = [attributedString attributesAtIndex:0 effectiveRange:NULL];
    UIFont *font = [attributes objectForKey:NSFontAttributeName];
    UIColor *color = [attributes objectForKey:NSForegroundColorAttributeName];
    if (font) {
        self.font = font;
    }
    if (color) {
        self.textColor = color;
    }
    [self _layoutForChangedString];
    [self setNeedsDisplay];
}

- (void) setFont:(UIFont *)font
{
    _font = font;
    [self _layoutForChangedString];
    [self setNeedsDisplay];
}

- (void) setText:(NSString *)text
{
    _text = text;
    [self _layoutForChangedString];
    [self setNeedsDisplay];    
}

- (void) setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setNeedsDisplay]; //no layout change
}

- (void) setUseDefaultDrawing:(BOOL)useDefaultDrawing
{
    _useDefaultDrawing = useDefaultDrawing;
    [self setNeedsDisplay];
}

- (void) startDisappearAnimation
{
    self.animatingAppear = NO;
    self.animationTime = 0;
    self.useDefaultDrawing = NO;
    self.displayLink.paused = NO;
    
    [self setNeedsDisplay]; //draw all rects
}

- (void) sizeToFit
{
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), self.layoutTool.estimatedHeight);
}

- (void) startAppearAnimation
{
    self.animatingAppear = YES;
    self.animationTime = 0;
    self.useDefaultDrawing = NO;
    self.displayLink.paused = NO;
}

- (CGRect) customRedrawAreaWithRect: (CGRect) rect attribute: (ZCTextAttribute *) attribute
{
    return  attribute.charRect;
}


/**
 *  Draw characters of different font size instead of using scale
 *  This might not be optimal but servies as an alternative.
 */
- (void) customAppearDrawingForRect:(CGRect)rect attribute:(ZCTextAttribute *)attribute
{
    CGFloat realProgress = [ZCEasingUtil bounceWithStiffness:0.01 numberOfBounces:1 time:attribute.progress shake:NO shouldOvershoot:NO];
    if (attribute.progress <= 0.0f) {
        return; 
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    if (self.appearDirection == ZCAnimatedLabelAppearDirectionFromCenter) {
        CGContextTranslateCTM(context, CGRectGetMidX(attribute.charRect), CGRectGetMidY(attribute.charRect));
        CGContextScaleCTM(context, realProgress, realProgress);
        CGRect rotatedRect = CGRectMake(-attribute.charRect.size.width / 2, - attribute.charRect.size.height / 2, attribute.charRect.size.width, attribute.charRect.size.height);
        [attribute.derivedAttributedString drawInRect:rotatedRect];
    }
    else if (self.appearDirection == ZCAnimatedLabelAppearDirectionFromTop) {
        CGContextTranslateCTM(context, CGRectGetMidX(attribute.charRect), CGRectGetMinY(attribute.charRect));
        CGContextScaleCTM(context, realProgress, realProgress);
        CGRect rotatedRect = CGRectMake(-attribute.charRect.size.width / 2,0, attribute.charRect.size.width, attribute.charRect.size.height);
        [attribute.derivedAttributedString drawInRect:rotatedRect];
    }
    else if (self.appearDirection == ZCAnimatedLabelAppearDirectionFromTopLeft) {
        CGContextTranslateCTM(context, CGRectGetMinX(attribute.charRect), CGRectGetMinY(attribute.charRect));
        CGContextScaleCTM(context, realProgress, realProgress);
        CGRect rotatedRect = CGRectMake(0, 0, attribute.charRect.size.width, attribute.charRect.size.height);
        [attribute.derivedAttributedString drawInRect:rotatedRect];
    }
    else if (self.appearDirection == ZCAnimatedLabelAppearDirectionFromBottom) {
        CGContextTranslateCTM(context, CGRectGetMidX(attribute.charRect), CGRectGetMaxY(attribute.charRect));
        CGContextScaleCTM(context, realProgress, realProgress);
        CGRect rotatedRect = CGRectMake(-attribute.charRect.size.width / 2, - attribute.charRect.size.height, attribute.charRect.size.width, attribute.charRect.size.height);
        [attribute.derivedAttributedString drawInRect:rotatedRect];
    }
    CGContextRestoreGState(context);
}

- (void) customDisappearDrawingForRect:(CGRect)rect attribute:(ZCTextAttribute *)attribute
{
    attribute.progress = 1 - attribute.progress; //default implementation, might not looks right
    [self customAppearDrawingForRect:rect attribute:attribute];
}

- (void) stopAnimation
{
    self.animationTime = 0;
    self.displayLink.paused = YES;
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];

    if (self.debugRedraw) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat hue = ( arc4random() % 256 / 256.0 );
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);        
    }
    
    for (ZCTextAttribute *attribute in self.layoutTool.textAttributes) {
        if (!CGRectIntersectsRect(rect, attribute.charRect)) {
            continue; //skip this text redraw
        }

        if (self.useDefaultDrawing) {

            if (self.drawsCharRect) {
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                CGContextAddRect(context, attribute.charRect);
                CGContextStrokePath(context);
            }
            
            if (self.animatingAppear) {
                [attribute.derivedAttributedString drawInRect:attribute.charRect];
            }            
        }
        else {
            if (self.animatingAppear && [self respondsToSelector:@selector(customAppearDrawingForRect:attribute:)]) {
                [self customAppearDrawingForRect:rect attribute:attribute];
            }
            if (!self.animatingAppear && [self respondsToSelector:@selector(customDisappearDrawingForRect:attribute:)]) {
                [self customDisappearDrawingForRect:rect attribute:attribute];
            }
        }
    }

    if (self.useDefaultDrawing) {
        [self.layoutTool cleanLayout];
    }
}

- (NSAttributedString *) attributedString: (NSAttributedString *) attributedString withOverridenAttributes: (NSDictionary *) attributes
{
    NSMutableAttributedString *mutableCopy = [attributedString mutableCopy];
    [mutableCopy addAttributes:attributes range:NSMakeRange(0, attributedString.length)];
    return mutableCopy;
}


- (void) customAttributeInit: (ZCTextAttribute *) attribute
{
    //override this in subclass
}

@end
