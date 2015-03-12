//
//  ZCEasingUtil.m
//  ZCAnimatedLabel
//
//  Contains code from
//  https://github.com/khanlou/SKBounceAnimation
//
//  Created by Chen Zhang on 2/15/15.
//  Copyright (c) 2015 somewhere. All rights reserved.
//

#import "ZCEasingUtil.h"

CGFloat QuadraticEaseIn(CGFloat p)
{
    return p * p;
}

CGFloat QuadraticEaseOut(CGFloat p)
{
    return -(p * (p - 2));
}


@implementation ZCEasingUtil

+ (CGFloat) bounceWithStiffness: (CGFloat) stiffness numberOfBounces: (CGFloat) numberOfBounces time: (CGFloat) progress shake: (BOOL) shake shouldOvershoot: (BOOL) shouldOvershoot startValue: (CGFloat) start endValue: (CGFloat) end {
    
    CGFloat startValue = 0.0f;
    CGFloat endValue = 1.0f;
    CGFloat alpha = 0.0f;
    if (startValue == endValue) {
        alpha = log2f(stiffness);
    } else {
        alpha = log2f(stiffness / fabsf(endValue - startValue));
    }
    if (alpha > 0) {
        alpha = -1.0f * alpha;
    }
    CGFloat numberOfPeriods = numberOfBounces / 2 + 0.5;
    CGFloat omega = numberOfPeriods * 2 * M_PI;
    
    CGFloat t = progress;
    
    CGFloat oscillationComponent;
    CGFloat coefficient;
    
    //y = A * e ^ (-alpha * t) * cos(omega * t)
    
    if (shake) {
        oscillationComponent =  sin(omega * t);
    } else {
        oscillationComponent =  cos(omega * t);
    }
    
    coefficient =  (startValue - endValue);
    
    if (!shouldOvershoot) {
        oscillationComponent =  fabsf(oscillationComponent);
    }
    
    CGFloat value = coefficient * pow(2.71, alpha * t) * oscillationComponent + endValue;
    return (end - start) * value + start;
}

+ (CGFloat) bounceWithStartValue: (CGFloat) startValue endValue: (CGFloat) endValue time: (CGFloat) progress
{
    return [ZCEasingUtil bounceWithStiffness:5 numberOfBounces:1 time:progress shake:NO shouldOvershoot:YES startValue:startValue endValue:endValue];
}

+ (CGFloat) bounceWithStiffness: (CGFloat) stiffness numberOfBounces: (CGFloat) numberOfBounces time: (CGFloat) progress shake: (BOOL) shake shouldOvershoot: (BOOL) shouldOvershoot {
    return [ZCEasingUtil bounceWithStiffness:stiffness numberOfBounces:numberOfBounces time:progress shake:shake shouldOvershoot:shouldOvershoot startValue:0 endValue:1];
}

+ (CGFloat) easeInWithStartValue: (CGFloat) startValue endValue: (CGFloat) endValue time:(CGFloat) progress
{
    return startValue + (endValue - startValue) * QuadraticEaseIn(progress);
}

+ (CGFloat) easeOutWithStartValue: (CGFloat) startValue endValue: (CGFloat) endValue time:(CGFloat) progress
{
    return startValue + (endValue - startValue) * QuadraticEaseOut(progress);
}

@end
