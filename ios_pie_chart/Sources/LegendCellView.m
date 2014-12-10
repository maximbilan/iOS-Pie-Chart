//
//  LegendCellView.m
//  ios_pie_chart
//
//  Created by Maxim Bilan on 11/3/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import "LegendCellView.h"
#import "NSString+Chart.h"

#import <CoreText/CoreText.h>

static			NSString * const	LegendCellViewFontFamily		= @"TrebuchetMS";
static const	CGFloat				LegendCellViewFontSize			= 8.0;
static const	int					LegendCellViewMaxCharacter		= 14;
static const    CGFloat             LegendCellViewNameOffset        = 3.0;
static const    CGFloat             LegendCellViewPercentOffset     = 50.0;

@interface LegendCellView ()
{
    UIColor *fontColor;
}

@end

@implementation LegendCellView

@synthesize text = _text;
@synthesize color = _color;
@synthesize percent = _percent;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        fontColor = [UIColor blackColor];
        self.color = [UIColor whiteColor];
        self.text = @"";
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
    
    CGContextSetFillColorWithColor(context, self.color.CGColor);
	CGContextFillRect(context, rect);
    
    const BOOL reduce = (self.text.length > LegendCellViewMaxCharacter);
	NSString *finalText = (!reduce) ? self.text : [NSString stringWithFormat:@"%@...", [self.text substringToIndex:LegendCellViewMaxCharacter]];
    
    NSDictionary *attributesName = [NSString generateAttributes:LegendCellViewFontFamily
                                                   withFontSize:LegendCellViewFontSize
                                                      withColor:fontColor
                                                  withAlignment:NSTextAlignmentFromCTTextAlignment(kCTTextAlignmentLeft)];
    NSDictionary *attributesPercent = [NSString generateAttributes:LegendCellViewFontFamily
                                                      withFontSize:LegendCellViewFontSize
                                                         withColor:fontColor
                                                     withAlignment:NSTextAlignmentFromCTTextAlignment(kCTTextAlignmentRight)];
    
    CTFontRef font = CTFontCreateWithName((CFStringRef)LegendCellViewFontFamily, LegendCellViewFontSize, NULL);
	CGRect fontBoundingBox = CTFontGetBoundingBox(font);
    
    CGFloat nameX = LegendCellViewNameOffset + CGRectGetMinX(rect);
    CGFloat nameY = (CGRectGetHeight(rect) - CGRectGetHeight(fontBoundingBox)) * 0.5;
    CGFloat nameW = CGRectGetWidth(rect);
    CGFloat nameH = CGRectGetHeight(fontBoundingBox);
    [finalText drawInRect:CGRectMake(nameX, nameY, nameW, nameH) withAttributes:attributesName];
    
    NSString *percentStr = [NSString stringWithFormat:(self.percent == 100)?@"%.0f%@":@"%.01f%@", self.percent, @"%"];
    [percentStr drawInRect:CGRectMake(nameX + LegendCellViewPercentOffset - LegendCellViewNameOffset, nameY, nameW - LegendCellViewPercentOffset - LegendCellViewNameOffset, nameH)
            withAttributes:attributesPercent];
    
    CFRelease(font);
}

@end
