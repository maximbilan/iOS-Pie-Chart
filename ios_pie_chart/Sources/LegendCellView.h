//
//  LegendCellView.h
//  wymg
//
//  Created by Maxim Bilan on 11/3/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LegendCellView : UIView
{
    UIColor *fontColor;
}

@property (nonatomic, strong) NSString	*text;
@property (nonatomic, strong) UIColor	*color;

@property float percent;

@end
