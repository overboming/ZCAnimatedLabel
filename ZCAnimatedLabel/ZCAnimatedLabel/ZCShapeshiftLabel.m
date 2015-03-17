//
//  ZCShapeshiftLabel.m
//  ZCAnimatedLabel
//
//  Created by Chen Zhang on 2/26/15.
//  Copyright (c) 2015 somewhere. All rights reserved.
//

#import "ZCShapeshiftLabel.h"

@implementation ZCShapeshiftLabel

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.onlyDrawDirtyArea = NO;
    }
    return self;
}

- (void) customAppearDrawingForRect: (CGRect) rect attribute: (ZCTextBlock *) attribute
{
    CGFloat alpha = [ZCEasingUtil easeInWithStartValue:0 endValue:1 time:attribute.progress];
    if (alpha < 0.01) {
        return;
    }
    CGFloat realProgress = [ZCEasingUtil bounceWithStiffness:ZCAnimatedLabelStiffnessMedium numberOfBounces:1 time:attribute.progress shake:YES shouldOvershoot:NO];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMidX(attribute.charRect), CGRectGetMidY(attribute.charRect));
    CGContextRotateCTM(context, M_PI / 2 * (1 - realProgress));
    
    CGFloat scaleY = attribute.progress < 0.5 ? 0.3 : [ZCEasingUtil bounceWithStartValue:0.3 endValue:1 time:(attribute.progress-0.5)/0.7];
    CGContextScaleCTM(context, 1, scaleY);
    UIColor *color = [attribute.derivedTextColor colorWithAlphaComponent:alpha];
    CGRect rotatedRect = CGRectMake(-attribute.charRect.size.width / 2, - attribute.charRect.size.height / 2, attribute.charRect.size.width, attribute.charRect.size.height);
    attribute.textColor = color;
    [attribute.derivedAttributedString drawInRect:rotatedRect];
    CGContextRestoreGState(context);
}



@end
