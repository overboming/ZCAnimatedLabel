//
//  ZCRevealLabel.m
//  ZCAnimatedLabel
//
//  Created by Chen Zhang on 3/2/15.
//  Copyright (c) 2015 somewhere. All rights reserved.
//

#import "ZCRevealLabel.h"
#import "ZCEasingUtil.h"

@implementation ZCRevealLabel

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.onlyDrawDirtyArea = NO;
    }
    return self;
}

- (void) customAttributeInit:(ZCTextBlock *)attribute
{
}

- (void) customAppearDrawingForRect: (CGRect) rect attribute: (ZCTextBlock *) attribute
{
    if (attribute.progress <= 0.0f) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGRect boundingBox = attribute.charRect;
    
    CGFloat maxRadius = boundingBox.size.width > boundingBox.size.height ? boundingBox.size.width : boundingBox.size.height;
    CGFloat radius = [ZCEasingUtil easeOutWithStartValue:0 endValue:maxRadius time:attribute.progress];

    CGFloat centerX = CGRectGetMidX(boundingBox);
    CGFloat centerY = CGRectGetMidY(boundingBox);
    CGContextAddEllipseInRect(context, CGRectMake(centerX - radius, centerY - radius, 2 * radius, 2 * radius));
    CGContextEOClip(context);
    
    [attribute.derivedAttributedString drawInRect:attribute.charRect];
    CGContextRestoreGState(context);
}
@end
