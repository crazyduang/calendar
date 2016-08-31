//
//  YLCalendarView.m
//  YLCalendar
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLCalendarView.h"

#define kMaskHeight self.frame.size.height

@implementation YLCalendarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        [self addSubviews];
        [self addTap];
        [self addSwipe];
        [self show];
    }
    return self;
}

- (void)addSubviews{
    
    self.previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previousBtn.frame = CGRectMake(0, 0, kMaskHeight/8, kMaskHeight/8);
    [self.previousBtn setImage:[UIImage imageNamed:@"bt_previous"] forState:UIControlStateNormal];
    self.previousBtn.backgroundColor = [UIColor greenColor];
    [self.previousBtn addTarget:self action:@selector(previouseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.previousBtn];
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.previousBtn.frame), 0, (self.frame.size.width - kMaskHeight/4), kMaskHeight/8)];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel.font = [UIFont systemFontOfSize:17];
    self.monthLabel.textColor = [UIColor redColor];
    [self addSubview:self.monthLabel];
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.frame = CGRectMake(CGRectGetMaxX(self.monthLabel.frame), 0, kMaskHeight/8, kMaskHeight/8);
    [self.nextBtn setImage:[UIImage imageNamed:@"bt_next"] forState:UIControlStateNormal];
    self.nextBtn.backgroundColor = [UIColor greenColor];
    [self.nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextBtn];
}


- (void)setDate:(NSDate *)date
{
    _date = date;
    [_monthLabel setText:[NSString stringWithFormat:@"%.2d-%i",[self month:date],[self year:date]]];
    [_collectionView reloadData];
}

- (void)addSwipe
{
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextAction:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previouseAction:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
}

- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
//    [self addGestureRecognizer:tap];
    
    
}


- (void)show
{
    self.transform = CGAffineTransformTranslate(self.transform, 0, - kMaskHeight);
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
        [self customInterface];
    }];
}

- (void)customInterface
{
    CGFloat itemWidth = self.frame.size.width / 7;
    CGFloat itemHeight = kMaskHeight / 8;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kMaskHeight/8, self.frame.size.width, (kMaskHeight/8.0)*7) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
//    [_collectionView setCollectionViewLayout:layout animated:YES];
    
    [_collectionView registerClass:[YLCalendarCell class] forCellWithReuseIdentifier:@"Cell"];
    [self addSubview:_collectionView];
}
#pragma -mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _weekDayArray.count;
    } else {
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YLCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell.dateLabel setText:_weekDayArray[indexPath.row]];
        [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#15cc9c"]];
        
    } else {
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i < firstWeekday) {
            [cell.dateLabel setText:@""];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            [cell.dateLabel setText:@""];
        }else{
            day = i - firstWeekday + 1;
            [cell.dateLabel setText:[NSString stringWithFormat:@"%ld",day]];
//            [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#6f6f6f"]]; // 今天之前的日期
            [cell.dateLabel setTextColor:[UIColor blackColor]];
            
            NSLog(@"today == %@   date == %@", _today, _date);
            
            //this month  [_today isEqualToDate:_date]
            if ([self month:_today] == [self month:_date] && [self year:_today] == [self year:_date]) {
                if (day == [self day:_date]) {
                    [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#4898eb"]]; // 今天
                    [cell.dateLabel setTextColor:[UIColor redColor]];
                } else if (day > [self day:_date]) {
                    [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#cbcbcb"]]; // 这个月今天之后的日子
                    [cell.dateLabel setTextColor:[UIColor yellowColor]];
                }
            } else if ([_today compare:_date] == NSOrderedAscending) {
                [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#cbcbcb"]]; // 从下个月开始以后的日子
                [cell.dateLabel setTextColor:[UIColor blueColor]];
            }
        }
    }
    return cell;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i >= firstWeekday && i <= firstWeekday + daysInThisMonth - 1) {
            day = i - firstWeekday + 1;
            
            //this month
            if ([_today isEqualToDate:_date]) {
                if (day <= [self day:_date]) {
                    return YES;
                }
            } else if ([_today compare:_date] == NSOrderedDescending) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    day = i - firstWeekday + 1;
    if (self.calendarBlock) {
        self.calendarBlock(day, [comp month], [comp year]);
    }
//    [self hide];
}




- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformTranslate(self.transform, 0, - kMaskHeight);
        self.alpha = 0;
    } completion:^(BOOL isFinished) {
        [self removeFromSuperview];
        [self removeFromSuperview];
    }];
}


- (void)previouseAction:(UIButton *)sender
{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        self.date = [self lastMonth:self.date];
    } completion:nil];
}

- (void)nextAction:(UIButton *)sender
{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        self.date = [self nextMonth:self.date];
    } completion:nil];
}



#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    NSLog(@"day11 == %ld", [components day]);
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    NSLog(@"month == %ld", [components month]);
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    NSLog(@"year == %ld", [components year]);
    return [components year];
}

// 每月开始的第一周
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //设定每周的第一天从星期几开始
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSLog(@"calendar == %@", calendar);
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    NSLog(@"comp == %@", comp);
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSLog(@"firstDayOfMonthDate == %@", firstDayOfMonthDate);
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    NSLog(@"firstWeekday == %ld", firstWeekday);
    return firstWeekday - 1;
}

// 这个月有多少天
- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSLog(@"totaldaysInMonth == %ld  %ld", totaldaysInMonth.location, totaldaysInMonth.length);
    return totaldaysInMonth.length;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSLog(@"daysInLastMonth == %ld  %ld", daysInLastMonth.location, daysInLastMonth.length);
    return daysInLastMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSLog(@"dateComponents1 == %@", dateComponents);
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    NSDate *sureDate = [self dateWithDate:newDate];
    return sureDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSLog(@"dateComponents2 == %@", dateComponents);
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    NSDate *sureDate = [self dateWithDate:newDate];
    return sureDate;
}

- (NSDate*)dateWithDate:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    NSLog(@"luyilin == %@", dateComponents);
    dateComponents.day = [self totaldaysInThisMonth:date];
    NSLog(@"luyilin == %@", dateComponents);
    NSDate *newdate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    return newdate;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
