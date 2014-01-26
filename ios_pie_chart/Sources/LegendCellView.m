//
//  LegendCellView.m
//  wymg
//
//  Created by Maxim Bilan on 11/3/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import "LegendCellView.h"
#import "NSString+Chart.h"

#import <CoreText/CoreText.h>

static			NSString * const	LegendCellViewFontFamily		= @"TrebuchetMS";
static const	CGFloat				LegendCellViewFontSize			= 8.0f;
static const	int					LegendCellViewMaxCharacter		= 14;
static const    CGFloat             LegendCellViewNameOffset        = 3.0f;
static const    CGFloat             LegendCellViewPercentOffset     = 50.0f;

@implementation LegendCellView

@synthesize text = _text;
@synthesize color = _color;
@synthesize percent = _percent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
    {
        fontColor = [UIColor blackColor];
        _color = [UIColor whiteColor];
        _text = @"";
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect( context, rect );
    
    CGContextSetFillColorWithColor( context, _color.CGColor );
	CGContextFillRect( context, rect );
    
    const BOOL reduce = ( _text.length > LegendCellViewMaxCharacter );
	NSString *finalText = ( !reduce ) ? _text : [NSString stringWithFormat:@"%@...", [_text substringToIndex:LegendCellViewMaxCharacter]] ;
    
    NSDictionary *attributesName = [NSString generateAttributes:LegendCellViewFontFamily
                                                        withFontSize:LegendCellViewFontSize
                                                           withColor:fontColor
                                                       withAlignment:NSTextAlignmentFromCTTextAlignment(kCTTextAlignmentLeft)];
    NSDictionary *attributesPercent = [NSString generateAttributes:LegendCellViewFontFamily
                                                         withFontSize:LegendCellViewFontSize
                                                            withColor:fontColor
                                                        withAlignment:NSTextAlignmentFromCTTextAlignment(kCTTextAlignmentRight)];
    
    CTFontRef font = CTFontCreateWithName( (CFStringRef)LegendCellViewFontFamily, LegendCellViewFontSize, NULL );
	CGRect fontBoundingBox = CTFontGetBoundingBox( font );
    
    CGFloat nameX = LegendCellViewNameOffset + CGRectGetMinX( rect );
    CGFloat nameY = ( CGRectGetHeight( rect ) - CGRectGetHeight( fontBoundingBox ) ) * 0.5f;
    CGFloat nameW = CGRectGetWidth( rect );
    CGFloat nameH = CGRectGetHeight( fontBoundingBox );
    [finalText drawInRect:CGRectMake( nameX, nameY, nameW, nameH ) withAttributes:attributesName];
    
    NSString *percentStr = [NSString stringWithFormat:(_percent == 100)?@"%.0f%@":@"%.01f%@", _percent, @"%"];
    [percentStr drawInRect:CGRectMake( nameX + LegendCellViewPercentOffset - LegendCellViewNameOffset, nameY, nameW - LegendCellViewPercentOffset - LegendCellViewNameOffset, nameH ) withAttributes:attributesPercent];
    
    CFRelease( font );
}

@end
