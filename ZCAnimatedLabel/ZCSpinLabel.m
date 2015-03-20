//
//  ZCSpinLabel.m
//  ZCAnimatedLabel
//
//  Created by Chen Zhang on 3/17/15.
//  Copyright (c) 2015 alipay. All rights reserved.
//
//  3d transform on image doesn't seem practical in real time on images better than a dime
//  use layerBased implementation isntead
//
//  duration should be longer to see the full rotation
//

#import "ZCSpinLabel.h"

@implementation ZCSpinLabel

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.onlyDrawDirtyArea = NO;
        self.layerBased = YES;
    }
    return self;
}

- (void) customAttributeInit:(ZCTextBlock *)attribute
{
    ZCTextBlockLayer *layer = attribute.textBlockLayer;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.transform = CATransform3DMakeRotation((M_PI / 2), 0, 1, 0);
    [layer setNeedsDisplay];
}


- (void) customViewAppearChangesForAttribute: (ZCTextBlock *) attribute
{
    if (attribute.progress <= 0) {
        return;
    }
    CGFloat realProgress = [ZCEasingUtil bounceWithStiffness:ZCAnimatedLabelStiffnessMedium numberOfBounces:1 time:attribute.progress shake:NO shouldOvershoot:YES];
    attribute.textBlockLayer.transform = CATransform3DMakeRotation(2 * M_PI * (1 - realProgress), 0, 1, 0);
}



@end
