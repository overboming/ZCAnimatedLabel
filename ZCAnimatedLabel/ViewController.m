//
//  ViewController.m
//  ZCAnimatedLabel
//
//  Created by Chen Zhang on 2/13/15.
//  Copyright (c) 2015 ;. All rights reserved.
//

#import "ViewController.h"

#import "ZCThrownLabel.h"
#import "ZCShapeshiftLabel.h"
#import "ZCDuangLabel.h"
#import "ZCFallLabel.h"
#import "ZCTransparencyLabel.h"
#import "ZCFlyinLabel.h"
#import "ZCFocusLabel.h"
#import "ZCRevealLabel.h"

#import <objc/runtime.h>

@interface ViewController ()<UIActionSheetDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.label = [[ZCAnimatedLabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.debugRedraw.frame) + 15, self.view.frame.size.width - 30, CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.debugRedraw.frame))];
    [self.view addSubview:self.label];
}

- (IBAction) changeEffect: (id) sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Throw", @"Shapeshift", @"Default", @"Duang", @"Fall", @"Alpha", @"Flyin", @"Blur", @"Reveal", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.label.onlyDrawDirtyArea = YES;
    if (buttonIndex == 0) {
        object_setClass(self.label, [ZCThrownLabel class]);
    }
    else if (buttonIndex == 1) {
        object_setClass(self.label, [ZCShapeshiftLabel class]);
    }
    else if (buttonIndex == 2) {
        object_setClass(self.label, [ZCAnimatedLabel class]);
    }
    else if (buttonIndex == 3) {
        object_setClass(self.label, [ZCDuangLabel class]);
    }
    else if (buttonIndex == 4) {
        object_setClass(self.label, [ZCFallLabel class]);
    }
    else if (buttonIndex == 5) {
        object_setClass(self.label, [ZCTransparencyLabel class]);
    }
    else if (buttonIndex == 6) {
        object_setClass(self.label, [ZCFlyinLabel class]);
    }
    else if (buttonIndex == 7) {
        object_setClass(self.label, [ZCFocusLabel class]);
    }
    else if (buttonIndex == 8) {
        object_setClass(self.label, [ZCRevealLabel class]);
    }
    
    if (buttonIndex < 9) {
        [self.effectButton setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
    }
    
    [self.label setNeedsDisplay];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.label setAttributedString:self.label.attributedString];
        [self.label startAppearAnimation];
    });
}

- (IBAction) breakSegmentChanged: (id) sender
{
    [self.label stopAnimation];
    [self.label.layoutTool cleanLayout];
    self.label.layoutTool.groupType = (NSInteger)self.breakSegment.selectedSegmentIndex;
}


- (IBAction) durationChanged: (id) sender
{
    [self.label stopAnimation];
    self.durationLabel.text = [NSString stringWithFormat:@"%.2f", self.durationSlider.value];
}

- (IBAction) diffChanged: (id) sender
{
    [self.label stopAnimation];
    self.diffLabel.text = [NSString stringWithFormat:@"%.2f", self.diffSlider.value];
}

- (IBAction) debugRedrawChanged: (id) sender
{
    [self.label stopAnimation];
    self.label.debugRedraw = self.debugRedraw.isOn;
}

- (void) animateLabelAppear: (BOOL) appear
{
    self.label.animationDuration = self.durationSlider.value;
    self.label.animationDiff = self.diffSlider.value;
    self.label.text = @"When lilacs last in the door-yard bloom’d,\nAnd the great star early droop’d in the western sky in the night,\nI mourn’d—and yet shall mourn with ever-returning spring.";
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 4;
    style.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString *mutableString = [[[NSAttributedString alloc] initWithString:self.label.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:22], NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor blackColor]}] mutableCopy];
    [mutableString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[mutableString.string rangeOfString:@"sky"]];
    [mutableString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:[mutableString.string rangeOfString:@"sky"]];
    [mutableString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.7843 green:0.6352 blue:0.7843 alpha:1] range:[mutableString.string rangeOfString:@"lilacs"]];
    [mutableString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[mutableString.string rangeOfString:@"spring"]];
    self.label.attributedString = mutableString;
    
    if (appear) {
        [self.label startAppearAnimation];
    }
    else {
        [self.label startDisappearAnimation];
    }
}

- (IBAction) animateAppear: (id) sender
{
    [self animateLabelAppear:YES];
}

- (IBAction) animateDisappear: (id) sender
{
    [self animateLabelAppear:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
