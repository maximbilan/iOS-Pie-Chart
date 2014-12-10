//
//  ChartData.h
//  ios_pie_chart
//
//  Created by Maxim Bilan on 11/3/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartItem : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) float value;

@end

@interface ChartItemDerived : ChartItem

@property (nonatomic) float percent;

@end

@interface ChartData : NSObject

+ (NSArray *)colors;

@end