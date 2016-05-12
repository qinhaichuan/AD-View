//
//  ADModel.h
//  AD_View
//
//  Created by QHC on 5/11/16.
//  Copyright © 2016 秦海川. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADModel : NSObject
// 广告图片
@property (nonatomic, strong) NSString *w_picurl;

// 广告图片尺寸
@property (nonatomic, assign) CGFloat w;

// 广告图片尺寸
@property (nonatomic, assign) CGFloat h;

// 点击广告跳转的界面
@property (nonatomic, strong) NSString *ori_curl;
@end
