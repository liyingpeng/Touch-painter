//
//  SigletonMarco.h
//  iJobs
//
//  Created by chenzhilei on 14/7/22.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

/**
 *  单例方法声明宏，用于头文件
 */
#define SINGLETON_FOR_HEADER \
\
+ (instancetype)sharedInstance;


/**
 *  单例文件实现宏定义
 */
#define SINGLETON_FOR_CLASS(className) \
\
static id shared##className = nil; \
+ (instancetype)sharedInstance { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        shared##className = [[self alloc] init]; \
    }); \
    return shared##className; \
}\
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
    @synchronized(self) \
    { \
        if (shared##className == nil) \
        { \
            shared##className = [super allocWithZone:zone]; \
            return shared##className; \
        } \
    } \
    \
    return nil; \
} \
\
-(id)copy \
{ \
    return self; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return self; \
}

