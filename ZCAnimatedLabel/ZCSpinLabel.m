//
//  ZCSpinLabel.m
//  ZCAnimatedLabel
//
//  Created by Chen Zhang on 3/17/15.
//  Copyright (c) 2015 alipay. All rights reserved.
//
//  3d transform renderer from AGGeometryKit
//  http://stackoverflow.com/questions/1949003/how-do-i-create-render-a-uiimage-from-a-3d-transformed-uiimageview
//
//  3d transform on image doesn't seem practical in real time on images better than a dime
//  use viewBased implementation isntead
//

#import "ZCSpinLabel.h"
#import "CGImageRef+AGK+CATransform3D.h"

@implementation ZCSpinLabel

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.onlyDrawDirtyArea = NO;
        self.viewBased = YES;
    }
    return self;
}

- (void) customAttributeInit:(ZCTextBlock *)attribute
{
    if (self.viewBased) {
        ZCTextBlockView *view = attribute.textBlockView;
        view.backgroundColor = [UIColor clearColor];
        view.layer.transform = CATransform3DMakeRotation((M_PI / 2), 0, 1, 0);
    }
    else {
        UIGraphicsBeginImageContextWithOptions(attribute.charRect.size, NO, [UIScreen mainScreen].scale);
        UIColor *color = [attribute.derivedTextColor colorWithAlphaComponent:1];
        attribute.textColor = color;
        [attribute.derivedAttributedString drawInRect:CGRectMake(0, 0, attribute.charRect.size.width, attribute.charRect.size.height)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        attribute.customValue = image;
    }
}

- (void) customAppearDrawingForRect: (CGRect) rect attribute: (ZCTextBlock *) attribute
{
    if (attribute.progress <= 0) {
        return;
    }
    CGFloat realProgress = [ZCEasingUtil easeOutWithStartValue:0 endValue:1 time:attribute.progress];
    UIImage *image = (UIImage *)attribute.customValue;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGImageRef newImage = CGImageDrawWithCATransform3D_AGK(image.CGImage, CATransform3DMakeRotation(M_PI / 2 * (1 - realProgress), 0, 1, 0), CGPointMake(0, 0), image.size, [UIScreen mainScreen].scale);
    UIImage *uiImage = [[UIImage alloc] initWithCGImage:newImage];
    [uiImage drawInRect:attribute.charRect];
    CGImageRelease(newImage);
    CGContextRestoreGState(context);
}

- (void) customViewAppearChangesForAttribute: (ZCTextBlock *) attribute
{
    if (attribute.progress <= 0) {
        return;
    }
    CGFloat realProgress = [ZCEasingUtil easeOutWithStartValue:0 endValue:1 time:attribute.progress];
    attribute.textBlockView.layer.transform = CATransform3DMakeRotation(M_PI / 2 * (1 - realProgress), 0, 1, 0);
}



@end
