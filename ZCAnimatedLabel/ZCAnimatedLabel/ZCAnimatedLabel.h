//
//  ZCAnimatedLabel.h
//  ZCAnimatedLabel
//
//  Created by Chen Zhang on 2/13/15.
//  Copyright (c) 2015 somewhere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#import "ZCCoreTextLayout.h"


typedef NS_ENUM(NSInteger, ZCAnimatedLabelAppearDirection)
{
    ZCAnimatedLabelAppearDirectionFromBottom,
    ZCAnimatedLabelAppearDirectionFromCenter,
    ZCAnimatedLabelAppearDirectionFromTop,
    ZCAnimatedLabelAppearDirectionFromTopLeft,
};


@interface ZCAnimatedLabel : UIView

/*
 * time for one text attribute to do completion animation
 */
@property (nonatomic, assign) CGFloat animationDuration;

/*
 * start time offset for each group
 */
@property (nonatomic, assign) CGFloat animationDelay;

/*
 * duration for the label to finish animation on screen
 */
@property (nonatomic, readonly) CGFloat totoalAnimationDuration;

/*
 * font, text, textColor, attributedString
 * similar to how it works in UILabel
 */
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, strong) NSAttributedString *attributedString;

@property (nonatomic, assign) BOOL debugRedraw;

/**
 * if set to NO, whole rect will be redrawn on displayLinkTick
 * default to YES
 */
@property (nonatomic, assign) BOOL onlyDrawDirtyArea;

/*
 * appear direction only works in default implemention
 * add your own option in subclass implemention
 */
@property (nonatomic, assign) ZCAnimatedLabelAppearDirection appearDirection;
@property (nonatomic, readonly) ZCCoreTextLayout *layoutTool;

/**
 * animatingAppear = NO means it's in animate disappear mode
 */
@property (nonatomic, readonly) BOOL animatingAppear;

- (void) sizeToFit;

- (void) startAppearAnimation;

- (void) startDisappearAnimation;

- (void) stopAnimation;

/*
 * custom drawing
 */
- (void) customAppearDrawingForRect: (CGRect) rect attribute: (ZCTextBlock *) attribute;

- (void) customDisappearDrawingForRect: (CGRect) rect attribute: (ZCTextBlock *) attribute;

- (void) customAttributeInit: (ZCTextBlock *) attribute;

/*
 * override this to decide which part of the rect needs redraw
 */
- (CGRect) customRedrawAreaWithRect: (CGRect) rect attribute: (ZCTextBlock *) attribute;


@end
