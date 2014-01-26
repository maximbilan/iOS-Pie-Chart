//
//  ChartData.m
//  ios_pie_chart
//
//  Created by Maxim Bilan on 11/3/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import "ChartData.h"
#import "UIColor+Chart.h"

@implementation ChartItem

@synthesize name;
@synthesize value;

@end

@implementation ChartItemDerived

@synthesize percent;

@end

@implementation ChartData

+ (NSArray *)colors
{
    static NSArray *colors = nil;
    if (!colors) {
        colors = [NSArray arrayWithObjects:[UIColor greenChartColor], [UIColor yellowChartColor], [UIColor orangeChartColor], [UIColor redChartColor], [UIColor navyBlueChartColor], [UIColor blueChartColor], [UIColor pinkChartColor], [UIColor redChartColor], [UIColor purpleChartColor], [UIColor beigeChartColor], [UIColor brownChartColor], nil];
    }
    
    return colors;
}

@end