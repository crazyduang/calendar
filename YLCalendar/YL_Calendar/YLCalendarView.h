//
//  YLCalendarView.h
//  YLCalendar
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 YL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLCalendarCell.h"
#import "UIColor+YLLazy.h"

typedef void(^CalendarBlock)(NSInteger day, NSInteger month, NSInteger year);

@interface YLCalendarView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *today;
@property (nonatomic, copy) CalendarBlock calendarBlock;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UIButton *previousBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) NSArray *weekDayArray;
@property (nonatomic, strong) UIView *mask;



@end
