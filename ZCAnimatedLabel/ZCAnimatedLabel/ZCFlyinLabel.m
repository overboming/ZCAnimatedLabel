//
//  ZCFlyinLabel.m
//  ZCAnimatedLabel
//
//  Created by Chen Zhang on 2/28/15.
//  Copyright (c) 2015 somewhere. All rights reserved.
//

#import "ZCFlyinLabel.h"


@implementation ZCFlyinLabel

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.onlyDrawDirtyArea = YES;
    }
    return self;
}

- (void) customAttributeInit:(ZCTextBlock *)attribute
{
}

- (CGRect) customRedrawAreaWithRect: (CGRect) rect attribute: (ZCTextBlock *) attribute
{
    CGRect charRect = attribute.charRect;
    return CGRectMake(0, charRect.origin.y, rect.size.width, rect.size.height - charRect.origin.y);
}

- (void) customAppearDrawingForRect: (CGRect) rect attribute: (ZCTextBlock *) attribute
{
    CGFloat scale = [ZCEasingUtil easeOutWithStartValue:5 endValue:1 time:attribute.progress];
    CGFloat alpha = [ZCEasingUtil easeOutWithStartValue:0 endValue:1 time:attribute.progress];
    //skip very low alpha
    if (alpha < 0.01) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGFloat flyDirectionOffset = (1-attribute.progress) * attribute.derivedFont.pointSize * 2;
    CGContextTranslateCTM(context, CGRectGetMidX(attribute.charRect), CGRectGetMidY(attribute.charRect));
    CGContextScaleCTM(context, scale, scale);
    UIColor *color = [attribute.derivedTextColor colorWithAlphaComponent:alpha];
    CGRect rotatedRect = CGRectMake(-attribute.charRect.size.width / 2 + flyDirectionOffset, - attribute.charRect.size.height / 2 + flyDirectionOffset, attribute.charRect.size.width, attribute.charRect.size.height);
    attribute.textColor = color;
    [attribute.derivedAttributedString drawInRect:rotatedRect];
    CGContextRestoreGState(context);
}


@end