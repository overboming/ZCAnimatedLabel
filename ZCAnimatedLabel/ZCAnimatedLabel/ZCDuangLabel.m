//
//  ZCDuangLabel.m
//  ZCAnimatedLabel
//
//  Created by Chen Zhang on 2/28/15.
//  Copyright (c) 2015 somewhere. All rights reserved.
//

#import "ZCDuangLabel.h"

@implementation ZCDuangLabel

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.onlyDrawDirtyArea = YES;
    }
    return self;
}

- (void) customAppearDrawingForRect: (CGRect) rect attribute: (ZCTextBlock *) attribute
{
    if (attribute.progress <= 0) {
        return;
    }
    CGFloat realProgress = [ZCEasingUtil bounceWithStiffness:ZCAnimatedLabelStiffnessMedium numberOfBounces:3 time:attribute.progress shake:YES shouldOvershoot:YES];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMidX(attribute.charRect), CGRectGetMaxY(attribute.charRect));
    CGContextScaleCTM(context, 1, realProgress);
    CGRect newRect = CGRectMake(-attribute.charRect.size.width / 2, -attribute.charRect.size.height, attribute.charRect.size.width, attribute.charRect.size.height);
    [attribute.derivedAttributedString drawInRect:newRect];
    CGContextRestoreGState(context);
}




@end
