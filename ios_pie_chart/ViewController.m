//
//  ViewController.m
//  ios_pie_chart
//
//  Created by Maxim Bilan on 1/26/14.
//  Copyright (c) 2014 Maxim Bilan. All rights reserved.
//

#import "ViewController.h"

#import "Chart.h"
#import "ChartData.h"
#import "LegendView.h"

#define RAND_FROM_TO(min,max) (min + arc4random_uniform(max - min + 1))

@interface ViewController ()

@property (weak, nonatomic) IBOutlet Chart *chart;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    float total;
    for (NSInteger groupIndex = 0; groupIndex < 5; ++groupIndex) {
        
        [array removeAllObjects];
        total = 0.0;
		
		for (NSInteger itemIndex = 0; itemIndex < 10; ++itemIndex) {
            ChartItem *item = [[ChartItem alloc] init];
            item.name = [NSString stringWithFormat:@"Item %@", @(itemIndex)];
            item.value = RAND_FROM_TO(1, 500);
            total += item.value;
            [array addObject:item];
        }
        
        [self.chart setData:array withKey:[NSString stringWithFormat:@"Group %@", @(groupIndex + 1)] withTotal:total];
    }
}

@end
