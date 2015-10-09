//
//  LongPressButton.h
//  UIButtonLongPressed
//
//  Created by qiulei on 12-4-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    ControlEventTouchLongPress       = 1 <<  0,      //长按事件
    ControlEventTouchCancel          = 1 <<  1         //抬起以后的事件
    
};
typedef NSUInteger LongPressEvents;


@interface LongPressButton : UIView
{
    @private
    UIButton        *__button;
    NSMutableDictionary  *__targetDictonary;
}
@property (nonatomic) CFTimeInterval minimumPressDuration; //默认是0.5



- (void)addTarget:(id)target action:(SEL)action forControlEvents:(LongPressEvents)controlEvents;

- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;

- (void)setTitle:(NSString *)title forState:(UIControlState)state;           
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;        
- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state;
//修改button的文字对齐方式
- (void)setTextAlignment:(NSString *)textAlignment;

@end
