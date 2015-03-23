//
//  ZCSpinLabel.m
//  ZCAnimatedLabel
//
//  Created by Chen Zhang on 3/17/15.
//  Copyright (c) 2015 alipay. All rights reserved.
//
//  3d transform on image doesn't seem practical in real time on images bigger than a dime
//  use layerBased implementation instead
//
//  duration should be longer to notice full rotation
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

- (void) customTextBlockInit:(ZCTextBlock *)textBlock
{
    ZCTextBlockLayer *layer = textBlock.textBlockLayer;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.transform = CATransform3DMakeRotation((M_PI / 2), 0, 1, 0);
    [layer setNeedsDisplay];
}


- (void) customViewAppearChangesForTextBlock: (ZCTextBlock *) textBlock
{
    if (textBlock.progress <= 0) {
        return;
    }
    CGFloat realProgress = [ZCEasingUtil bounceWithStiffness:ZCAnimatedLabelStiffnessMedium numberOfBounces:1 time:textBlock.progress shake:NO shouldOvershoot:YES];
    textBlock.textBlockLayer.transform = CATransform3DMakeRotation(2 * M_PI * (1 - realProgress), 0, 1, 0);
}



@end
