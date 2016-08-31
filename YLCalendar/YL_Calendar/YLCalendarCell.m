//
//  YLCalendarCell.m
//  YLCalendar
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLCalendarCell.h"

@implementation YLCalendarCell





- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}


@end
