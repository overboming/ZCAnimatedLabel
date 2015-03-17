//
//  ZCTransparencyLabel.m
//  ZCAnimatedLabel
//
//  Created by Chen Zhang on 2/28/15.
//  Copyright (c) 2015 somewhere. All rights reserved.
//

#import "ZCTransparencyLabel.h"
#import "ZCEasingUtil.h"

@implementation ZCTransparencyLabel

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.onlyDrawDirtyArea = YES;
    }
    return self;
}

- (void) customAttributeInit:(ZCTextBlock *)attribute
{
    //customValue used as delay time
    attribute.startDelay = drand48();
    attribute.duration = drand48() * 2 + 1;
}

- (void) customAppearDrawingForRect: (CGRect) rect attribute: (ZCTextBlock *) attribute
{
    CGFloat alpha = [ZCEasingUtil easeOutWithStartValue:0 endValue:1 time:attribute.progress];
    //skip very low alpha
    if (alpha < 0.01) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIColor *color = [attribute.derivedTextColor colorWithAlphaComponent:alpha];
    attribute.textColor = color;
    [attribute.derivedAttributedString drawInRect:attribute.charRect];
    CGContextRestoreGState(context);
}

- (void) customDisappearDrawingForRect:(CGRect)rect attribute:(ZCTextBlock *)attribute
{
    CGFloat alpha = [ZCEasingUtil easeOutWithStartValue:1 endValue:0 time:attribute.progress];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIColor *color = [attribute.derivedTextColor colorWithAlphaComponent:alpha];
    attribute.textColor = color;
    [attribute.derivedAttributedString drawInRect:attribute.charRect];
    CGContextRestoreGState(context);
}

@end