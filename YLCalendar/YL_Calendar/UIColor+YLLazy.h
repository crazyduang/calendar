//
//  UIColor+YLLazy.h
//  YLCalendar
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 YL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YLLazy)

+ (UIColor *)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/**
 *  16进制转uicolor
 *
 *  @param color @"#FFFFFF" ,@"OXFFFFFF" ,@"FFFFFF"
 *
 *  @return uicolor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;


@end
