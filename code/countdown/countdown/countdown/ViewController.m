//
//  ViewController.m
//  countdown
//
//  Created by lbp on 17/4/21.
//  Copyright © 2017年 lbp. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController (){
    UILabel *_countdown;
}

@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _countdown = ({
        UILabel *view = [[UILabel alloc] init];
        [view setText:@"倒计时"];
        [view setTextColor:[UIColor redColor]];
        [view setTextAlignment:NSTextAlignmentLeft];
        [self.view addSubview:view];
        view;
    });
    
    UIView *superView = self.view;
    [_countdown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.top.equalTo(superView).offset(100);
        make.height.equalTo(@(50));
//        make.width.equalTo(@(100));
    }];
    
//    [self testDispathAfterCountdownWithTime:5];
    [self testDispathSourceCountdownWithTime:5];
}


#pragma mark - public methods

#pragma mark - private methods
- (void)testDispathSourceCountdownWithTime:(NSTimeInterval)time{
    __block NSTimeInterval timeCount = time;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeCount <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_countdown setText:@"倒计时结束"];
            });
            dispatch_source_cancel(timer);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_countdown setText:[NSString stringWithFormat:@"倒计时 : %.0fS",timeCount]];
            });
        }
        timeCount--;
    });
    dispatch_resume(timer);
}


- (void)testDispathAfterCountdownWithTime:(NSTimeInterval)time{
    [_countdown setText:[NSString stringWithFormat:@"倒计时 : %.0fS",time]];
    time--;
    if (time < 0) {
        [_countdown setText:@"倒计时结束"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf testDispathAfterCountdownWithTime:time];
    });
}





#pragma mark - event response


#pragma mark - xxxxdelegate


#pragma mark - getters and setters




@end
