//
//  NSString+Chart.m
//  ios_pie_chart
//
//  Created by Maxim Bilan on 11/10/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import "NSString+Chart.h"

@implementation NSString (Chart)

+ (NSDictionary *)generateAttributes:(NSString *)fontName withFontSize:(CGFloat)fontSize withColor:(UIColor *)color withAlignment:(NSTextAlignment)textAlignment
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:textAlignment];
	[paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	
	NSDictionary * attrs = @{
							 NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize],
							 NSForegroundColorAttributeName : color,
							 NSParagraphStyleAttributeName : paragraphStyle
							 };
	
	return attrs;
}

@end
