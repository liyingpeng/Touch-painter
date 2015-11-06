//
//  BDMLocationUtil.h
//  iJobs
//
//  Created by Li Xiaopeng on 15/2/10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GetPositionSuccessBlock)(double aLatitude, double alongitude);
typedef void(^GetPositionFailureBlock)(NSString* aError);

@interface BDMLocationUtil : NSObject

SINGLETON_FOR_HEADER

- (void)getCurrentPosition;

- (void)getCurrentPositionSuccess:(GetPositionSuccessBlock) aSuccessBlock
                          Failure:(GetPositionFailureBlock) aFailureBlock;
@end
