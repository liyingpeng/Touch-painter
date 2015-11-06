//
//  BDMUtility.h
//  iJobs
//
//  Created by Li Xiaopeng on 15/1/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//
#import <Foundation/Foundation.h>
#include <CoreMedia/CMTime.h>
/*!
 @class
 @abstract 通用工具类
 */
@interface BDMUtility : NSObject

#pragma mark 字符串相关
/**
 *  @brief  当前对象是否是字符串
 *
 *  @param string  待验证字符串
 *
 *  @return BOOL值
 */
+ (BOOL)isStringValidated:(NSString *)string;

/**
 *  @brief  当前对象是否是字典
 *
 *  @param dictionary  待验证字典
 *
 *  @return BOOL值
 */
+ (BOOL)isDictionaryValidated:(NSDictionary *)dictionary;

/**
 *  @brief  当前对象是否是数组
 *
 *  @param array  待验证数组
 *
 *  @return BOOL值
 */
+ (BOOL)isArrayValidated:(NSArray *)array;

/*!
 @method
 @abstract 判断字符串是否为空
 @discussion
 */
+ (BOOL)isEmptyString:(NSString *)string;

/*!
 @method
 @abstract 判断判断字典是否为空
 @discussion
 */
+ (BOOL)isEmptyDictionary:(NSDictionary *)dictionary;

/*!
 @method
 @abstract 判断数组是否为空
 @discussion
 */
+ (BOOL)isEmptyArray:(NSArray *)array;

/*!
 @method
 @abstract 判断集合是否为空
 @discussion
 */
+ (BOOL)isEmptySet:(NSSet *)set;

/*!
 @method
 @abstract 获取随机数
 @discussion
 */
+ (int)getRandomNumber:(int)from to:(int)to;

/*!
 @method
 @abstract 四舍五入
 @discussion
 */
+ (double)notRounding:(double)price afterPoint:(int)position mode:(NSRoundingMode)roundingMode;

/*!
 @method
 @abstract 去掉空格
 @discussion
 */
+ (NSString *)stringTrimming:(NSString *)str;

/*!
 @method
 @abstract 生成唯一标识符
 @discussion
 */
+ (NSString*)createCFUUID;

/*!
 @method
 @abstract 生成JSON字符串
 @discussion
 */
+ (NSString *)toJSONString:(id)theData;

#pragma mark 加密相关
/*!
 @method
 @abstract MD5加密
 @discussion
 */
+ (NSString *)md5Hash:(NSString *)content;

/*!
 @method
 @abstract AES加密
 @discussion
 */
+ (NSString *)requestAESStringWithUserID:(NSString *)uid AESKey:(NSString *)key;

/*!
 @method
 @abstract urlEncoded编码
 @discussion
 */
+ (NSString*)urlEncoded:(NSString*)strTxt;

/*!
 @method
 @abstract urlEncoded编码
 @discussion 中文输入法输入时文本框先出现拼音，而这个拼音会伴有"%E2%80%86"占位符(类似于空格)，该接口可过滤掉该字符
 */
+ (NSString*)urlEncoded1:(NSString*)strTxt;

/*!
 @method
 @abstract base64编码
 @discussion
 */
+(NSData *)encodeData:(NSData *)aData;

/*!
 @method
 @abstract base64解码
 @discussion
 */
+(NSData *)decodeData:(NSData *)aData;

#pragma mark 图片相关
/*!
 @method
 @abstract 加载图片
 @discussion
 */
+ (UIImage *)imageWithName:(NSString *)name;

/*!
 @method
 @abstract 加载图片
 @discussion
 */
+ (UIImage *)imageWithName:(NSString *)name ofType:(NSString *)type;

/*!
 @method
 @abstract 获取颜色
 @discussion
 */
+ (UIColor*)colorWithRgbHexString:(NSString*)hexString;

/*!
 @method
 @abstract view to image
 @discussion
 */
+ (UIImage *)getImageFromView:(UIView *)theView;

#pragma mark 时间相关
/*!
 @method
 @abstract 获取相对时间
 @discussion
 */
+ (NSString *)formatRelativeTime:(NSDate *)date;

/*!
 @method
 @abstract 转换时间为字符
 @discussion
 */
+ (NSDate*)convertDateFromString:(NSString *)strDate;

/*!
 @method
 @abstract 转换字符为时间
 @discussion
 */
+ (NSDate *)formatDateFromString:(NSString *)strDate;

/*!
 @method
 @abstract 转换时间为星期几
 @discussion
 */
+ (NSString *)weekdayForDate:(NSDate *)date;

/*!
 @method
 @abstract 转换时间为星期几返回整数
 @discussion
 */
+ (NSInteger)weekdayNumForDate:(NSDate *)date;

/*!
 @method
 @abstract 获取CMTime
 @discussion
 */
+ (NSString *)stringByCMTime:(CMTime)time;

/*!
 @method
 @abstract 获取时间通过秒
 @discussion
 */
+ (NSString *)stringBySecond:(CGFloat)duration;

/*!
 @method
 @abstract 获取当前
 @discussion
 */
+ (NSDate *)getCurrentDate;

/*!
 @method
 @abstract 获取1970年到当前时间的时间间隔
 @discussion 精确到秒，返回NSNumber类型
 */
+ (NSNumber *)getTimeIntervalStringSince1970;

/*!
 @method
 @abstract 指定format转换string到date
 @discussion
 */
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format;

/*!
 @method
 @abstract  默认标准format转换string到date
 @discussion
 */
+ (NSDate *)dateFromString:(NSString *)dateString;

/*!
 @method
 @abstract 指定format转换date到string
 @discussion
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;

/*!
 @method
 @abstract 转换日期string的format
 @discussion
 */
+ (NSString *)changeFormat:(NSString *)string from:(NSString *)fromFormat to:(NSString *)toFormat;

/*!
 @method
 @abstract 转换日期string的format
 @discussion
 */
+ (NSString *)changeFormat:(NSString *)string toFormat:(NSString *)toFormat;

/*!
 @method
 @abstract 获取系统键盘
 @discussion
 */
+ (UIWindow *)systemKeyboardWindow;

/*!
 @method
 @abstract 自动适配屏幕
 @discussion
 */
+ (CGRect)calculateFrameToFitScreenBySize:(CGSize)size;

/*!
 @method
 @abstract 从共享内容获取连接
 @discussion
 */
+ (NSString *)getLinkFromShareContent:(NSString *)content;

#pragma mark 正则表达式校验相关
/*!
 @method
 @abstract 手机号码格式校验
 @discussion
 */
+ (BOOL)isMobileNumber:(NSString *)mobile;
/*!
 @method
 @abstract 电话号码格式校验
 @discussion
 */
+ (BOOL)isPhoneNumber:(NSString *)phone;

/**
 *  @brief  邮箱判断
 *
 *  @param email 邮箱地址
 *
 *  @return 布尔值
 */
+ (BOOL) validateEmail:(NSString *)email;

/**
 *  @brief  网址判读
 *
 *  @param value url
 *
 *  @return 布尔值
 */
+ (BOOL) isValidUrl:(NSString*)url;

/**
 *  @brief  邮编判读
 *
 *  @param value 邮编值
 *
 *  @return 布尔值
 */
+ (BOOL) isValidZipcode:(NSString*)value;

@end

#pragma mark - AES Encrypt/Decrypt (Optional)
@interface NSData (AES256)

/*!
 @method
 @abstract 加密方法,参数需要加密的内容
 @discussion
*/
+ (NSString *)AES256EncryptWithPlainText:(NSString *)plain AESKey:(NSString *)aeskey;

/*!
 @method
 @abstract 解密方法，参数数密文
 @discussion
 */
+ (NSString *)AES256DecryptWithCiphertext:(NSString *)ciphertexts  AESKey:(NSString *)aeskey;

- (NSString *)base64Encoding;

@end

#pragma mark - AES Encrypt/Decrypt (Basic)
@interface NSData (AESAdditions)

- (NSData*)AES256EncryptWithKey:(NSString*)key;

- (NSData*)AES256DecryptWithKey:(NSString*)key;

@end

@interface NSString (AESAdditions)

- (NSString *)AES256EncryptWithKey:(NSString *)key;

- (NSString *)AES256DecryptWithKey:(NSString *)key;

@end
