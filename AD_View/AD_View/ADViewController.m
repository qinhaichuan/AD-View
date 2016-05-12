//
//  ADViewController.m
//  AD_View
//
//  Created by QHC on 5/11/16.
//  Copyright © 2016 秦海川. All rights reserved.
//

#import "ADViewController.h"
#import "ViewController.h"
#import <UIImageView+WebCache.h>
#import <MJExtension/MJExtension.h>
#import <AFNetworking/AFNetworking.h>
#import "ADModel.h"

#define CODE @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

#define URL @"http://mobads.baidu.com/cpro/ui/mads.php"

@interface ADViewController()

@property(nonatomic, strong) UIImageView *adView;
@property(nonatomic, weak) UIButton *jumpBtn;
@property(nonatomic, strong) ADModel *adModel;
@property(nonatomic, weak) NSTimer *timer;
@end

@implementation ADViewController

- (UIImageView *)adView
{
    if (!_adView) {
        _adView = [[UIImageView alloc] init];
        [self.view insertSubview:_adView atIndex:0];
    }
    return _adView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setView];
    [self getDate];
}

- (void)setView
{
    
    UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.jumpBtn = jumpBtn;
    jumpBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    jumpBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    jumpBtn.titleLabel.textColor = [UIColor whiteColor];
    [jumpBtn setTitle:@"跳过(3S)" forState:UIControlStateNormal];
    jumpBtn.backgroundColor = [UIColor lightGrayColor];
    [jumpBtn addTarget:self action:@selector(jumpToMainVc) forControlEvents:UIControlEventTouchUpInside];
    jumpBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - 10, 64, 50, 20);
    [self.view addSubview:jumpBtn];
}

- (void)jumpToMainVc
{
    [self.timer invalidate];
    
   ViewController *VC = [[ViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = VC;
}

- (void)getDate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"code2"] = CODE;
    
    __weak typeof (self) weakSelf = self;
    AFHTTPSessionManager *mang = [AFHTTPSessionManager manager];
    [mang GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        if (responseObject) {
            NSDictionary *dict = [responseObject[@"ad"] lastObject];
            weakSelf.adModel = [ADModel mj_objectWithKeyValues:dict context:nil];
            
            if (weakSelf.adModel.w > 0) {
                CGFloat adViewH = [UIScreen mainScreen].bounds.size.width * weakSelf.adModel.h / weakSelf.adModel.w;
                weakSelf.adView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, adViewH);
                [weakSelf.adView sd_setImageWithURL:[NSURL URLWithString:weakSelf.adModel.w_picurl]];
            }
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@", error);
        
    }];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange:) userInfo:nil repeats:YES];
}

- (void)timeChange:(id)timer
{
    static NSInteger timeCount = 3;
    
    NSString *btnText = [NSString stringWithFormat:@"跳过(%zdS)", timeCount];
    [self.jumpBtn setTitle:btnText forState:UIControlStateNormal];
    
    if (timeCount < 0) {
        [self jumpToMainVc];
    }
    
    timeCount --;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.adModel.ori_curl]];
}





@end
