//
//  ZCEasingUtil.h
//  ZCAnimatedLabel
//
//  Created by Chen Zhang on 2/15/15.
//  Copyright (c) 2015 somewhere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

static const CGFloat ZCAnimatedLabelStiffnessLight  = 5.f;
static const CGFloat ZCAnimatedLabelStiffnessMedium = .1f;
static const CGFloat ZCAnimatedLabelStiffnessHeavy  = .001f;

@interface ZCEasingUtil : NSObject

+ (CGFloat) bounceWithStartValue: (CGFloat) startValue endValue: (CGFloat) endValue time: (CGFloat) progress;
+ (CGFloat) bounceWithStiffness: (CGFloat) stiffness numberOfBounces: (CGFloat) numberOfBounces time: (CGFloat) progress shake: (BOOL) shake shouldOvershoot: (BOOL) shouldOvershoot;
+ (CGFloat) bounceWithStiffness: (CGFloat) stiffness numberOfBounces: (CGFloat) numberOfBounces time: (CGFloat) progress shake: (BOOL) shake shouldOvershoot: (BOOL) shouldOvershoot startValue: (CGFloat) startValue endValue: (CGFloat) endValue;

+ (CGFloat) easeInWithStartValue: (CGFloat) startValue endValue: (CGFloat) endValue time:(CGFloat) progress;
+ (CGFloat) easeOutWithStartValue: (CGFloat) startValue endValue: (CGFloat) endValue time:(CGFloat) progress;

@end
