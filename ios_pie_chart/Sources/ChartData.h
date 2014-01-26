//
//  ChartData.h
//  wymg
//
//  Created by Maxim Bilan on 11/3/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartItem : NSObject

@property NSString	*name;
@property float		value;

@end

@interface ChartItemDerived : ChartItem

@property float		percent;

@end

@interface ChartData : NSObject

+ (NSArray*)colors;

@end