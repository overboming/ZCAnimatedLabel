//
//  ZCFallLabel.m
//  ZCAnimatedLabel
//
//  Created by Chen Zhang on 2/28/15.
//  Copyright (c) 2015 somewhere. All rights reserved.
//

#import "ZCFallLabel.h"

#import "ZCDuangLabel.h"

@implementation ZCFallLabel

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.onlyDrawDirtyArea = YES;
    }
    return self;
}

- (void) customAttributeInit: (ZCTextBlock *) attribute
{
    attribute.customValue = @((int)(arc4random() % 7) - 3);
    
}

- (CGRect) customRedrawAreaWithRect:(CGRect)rect attribute:(ZCTextBlock *)attribute
{
    CGRect charRect = attribute.charRect;
    return CGRectMake(charRect.origin.x - attribute.derivedFont.pointSize / 2, charRect.origin.y - attribute.derivedFont.pointSize * 5, charRect.size.width + attribute.derivedFont.pointSize, charRect.size.height + attribute.derivedFont.pointSize * 5);
}

- (void) customAppearDrawingForRect: (CGRect) rect attribute: (ZCTextBlock *) attribute
{
    CGFloat height = [ZCEasingUtil bounceWithStiffness:0.01 numberOfBounces:1 time:attribute.progress shake:NO shouldOvershoot:NO startValue:CGRectGetMaxY(attribute.charRect) - attribute.derivedFont.pointSize * 5  endValue:CGRectGetMaxY(attribute.charRect)];
    
    CGFloat alpha = attribute.progress < 0.2 ? [ZCEasingUtil easeInWithStartValue:0 endValue:1 time:attribute.progress * 5] : 1;
    //skip very low alpha
    if (alpha < 0.01 || attribute.progress <= 0) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMidX(attribute.charRect), height);
    CGFloat rotateValue = 0;
    CGFloat segment = 0.2;
    CGFloat maxRotate = [attribute.customValue integerValue] * M_PI / 32;
    if (attribute.progress <= segment) {
        rotateValue = maxRotate;
    }
    else {
        CGFloat newTime = (attribute.progress - segment)/(1 - segment);
        rotateValue = [ZCEasingUtil bounceWithStiffness:0.01 numberOfBounces:2 time:newTime shake:NO shouldOvershoot:YES startValue:maxRotate endValue:0];
    }
    CGContextRotateCTM(context, rotateValue);

    UIColor *color = [attribute.derivedTextColor colorWithAlphaComponent:alpha];
    CGRect newRect = CGRectMake(-attribute.charRect.size.width / 2, -attribute.charRect.size.height, attribute.charRect.size.width, attribute.charRect.size.height);
    attribute.textColor = color; //override color
    [attribute.derivedAttributedString drawInRect:newRect];
    CGContextRestoreGState(context);
}



@end
