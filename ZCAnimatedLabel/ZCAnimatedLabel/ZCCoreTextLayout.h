//
//  ZCCoreTextLayout.h
//  ZCAnimatedLabel
//
//  Core Text based layout
//
//
//  Created by Chen Zhang on 3/2/15.
//  Copyright (c) 2015 somewhere. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZCLayoutGroupType)
{
    ZCLayoutGroupChar,
    ZCLayoutGroupWord,
    ZCLayoutGroupLine,
};


@interface ZCTextAttribute : NSObject

@property (nonatomic, assign) CGRect charRect;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSRange textRange;

@property (nonatomic, readonly) UIColor *derivedTextColor;
@property (nonatomic, readonly) UIFont *derivedFont;
@property (nonatomic, readonly) NSAttributedString *derivedAttributedString;

/*if wanted to override default value from attributedString*/
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) BOOL ended;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat startDelay;
@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, assign) CGFloat customValue;

- (void) updateBaseAttributedString: (NSAttributedString *) attributedString;

@end



@interface ZCCoreTextLayout : NSObject

- (void) cleanLayout;
- (void) layoutWithAttributedString: (NSAttributedString *) attributedString constainedToSize: (CGSize) size;
- (CGFloat) estimatedHeight;


@property (nonatomic, strong) NSArray *textAttributes;
@property (nonatomic, assign) ZCLayoutGroupType groupType;


@end
