//
//  NSString+Chart.h
//  wymg
//
//  Created by Maxim Bilan on 11/10/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Chart)

+ (NSDictionary *)generateAttributes:(NSString *)fontName withFontSize:(CGFloat)fontSize withColor:(UIColor *)color withAlignment:(NSTextAlignment)textAlignment;

@end
