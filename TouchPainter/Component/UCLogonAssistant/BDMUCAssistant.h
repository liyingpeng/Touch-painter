//
//  BDMUCAssistant.h
//  iJobs
//
//  Created by bailu on 15-7-7.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 返回码的定义
typedef NS_ENUM(NSInteger, BDMUCCode) {
    
    /*!
     * @brief  正常。
     */
    BDMUCCodeOK,
    /*!
     * @brief  CLIENT ID错误.
     */
    BDMUCCodeClientIDIncorrect = 1,
    
    /*!
     * @brief  加密方法错误。
     */
    BDMUCCodeEncryptTypeIncorrect = 2,
    
    /*!
     * @brief  数据体损坏。
     */
    BDMUCCodeDataIncorrect = 3,
    
    /*!
     * @brief  数据太大（超过2K）。
     */
    BDMUCCodeDataIsTooLarge = 4,
    
    /*!
     * @brief  数据太小。
     */
    BDMUCCodeDataIsTooSmall = 5,
    
    /*!
     * @brief  请求消息体格式不正确.
     */
    BDMUCCodeMessageFormatIncorrect = 6,
    
    /*!
     * @brief  访问的方法不存在.
     */
    BDMUCCodeMethodNotExist = 7,
    
    /*!
     * @brief  方法处理出错.
     */
    BDMUCCodeMethodProcessFailure = 8,
    
    /*!
     * @brief  TOKEN错误.
     */
    BDMUCCodeTokenIncorrect = 9,
    
    /*!
     * @brief  用户名错误.
     */
    BDMUCCodeUsernameIncorrect = 10,
    
    /*!
     * @brief  执行过程中出现错误.
     */
    BDMUCCodeMethodExecuteFailure = 11,
    
    /*!
     * @brief  错误的USERTYPE.
     */
    BDMUCCodeUserTypeIncorrect = 12,
    
    /*!
     * @brief  登录信息不完整。
     */
    BDMUCCodeInformationIncompelete = 130,
    
    /*!
     * @brief  验证码错误。
     */
    BDMUCCodeVerificationCodeIncorrect = 131,
    
    /*!
     * @brief  用户名或密码错误。
     */
    BDMUCCodeUsernamePasswordIncorrect = 132,
    
    /*!
     * @brief  找不到用户.
     */
    BDMUCCodeUsernameNotFound = 133,
    
    /*!
     * @brief  强制修改密码.
     */
    BDMUCCodeNeedModifyPassword = 134,
    
    /*!
     * @brief  账户被锁定。
     */
    BDMUCCodeAccountLocked = 135,
    
    /*!
     * @brief  需要验证码。
     */
    BDMUCCodeNeedVerificationCode = 137,
    
    /*!
     * @brief  会话无效
     */
    BDMUCCodeSessionInvalid = 190,
    
    /*!
     * @brief  需要回答密保问题。
     */
    BDMUCCodeNeedAnswerProtectQuestion = 191,
    
    /*!
     * @brief  回答密保问题错误.
     */
    BDMUCCodeProtectQuestionAnswerIncorrect = 192,
    
    /*!
     * @brief  回答密保问题错误超限。
     */
    BDMUCCodeProtectQuestionAnswerOverrun = 193,
    
    /*!
     * @brief  未登录.
     */
    BDMUCCodeNotLogon = 194,
    
    /*!
     * @brief  需要短信验证。
     */
    BDMUCCodeNeedSMSVerification = 195,
    
    /*!
     * @brief  验证短信错误超限。
     */
    BDMUCCodeSMSVerificationOverrun = 196,
    
    /*!
     * @brief  手机输入错误.
     */
    BDMUCCodeMobileNumberIncorrect = 197,
    
    /*!
     * @brief  短信发送失败.
     */
    BDMUCCodeSMSSendFailure = 198,
    
    /*!
     * @brief  验证短信错误.
     */
    BDMUCCodeSMSVerificationError = 199,
    
    /*!
     * @brief  登出错误.
     */
    BDMUCCodeLogoutError = 200,
    
    /*!
     * @brief  未知错误。
     */
    BDMUCCodeUnknownError = 500,
    
    /*!
     * @brief  参数错误。
     */
    BDMUCCodeParameterError = 502,
    
    /*!
     * @brief  功能未实现.
     */
    BDMUCCodeNotImplement = 503,
    
    /*!
     * @brief  数据为空.
     */
    BDMUCCodeEmptyData = 504,
    
    /*!
     * @brief  业务系统不允许登录。
     */
    BDMUCCodeLogonNotAllowed = 600,
    
    /*!
     * @brief  应用系统注册信息不完整.
     */
    BDMUCCodeRegisterInformationIncompelete = 601,
};

#pragma mark - 一些基础信息的定义

/*!
 * @brief  UC接口的返回码和信息。
 */
@interface BDMUCResponseModel : NSObject

/*!
 * @brief  返回码。
 */
@property(nonatomic) NSInteger returnCode;

/*!
 * @brief  一些其他信息。
 */
@property(nonatomic, copy) NSString *returnMessage;

@end

/*!
 * @brief  UC账户.
 */
@interface BDMUCAccount : NSObject

/*!
 * @brief  用户名。
 */
@property(nonatomic, copy) NSString *username;

/*!
 * @brief  密码。
 */
@property(nonatomic, copy) NSString *password;

/*!
 * @brief  验证码图片二进制数据。
 */
@property(nonatomic, copy) NSString *imageData;

/*!
 * @brief  验证码。
 */
@property(nonatomic, copy) NSString *imageCode;

/*!
 * @brief  验证码会话ID。
 */
@property(nonatomic, copy) NSString *imageSSID;

/*!
 * @brief  登录成功后的服务票据。
 */
@property(nonatomic, copy) NSString *sessionTicket;

/*!
 * @brief  登录成功后返回的用户ID。
 */
@property(nonatomic) NSInteger ucid;

/*!
 * @brief  登录成功的时间。
 */
@property(nonatomic, strong) NSDate *logonTime;

@end

#pragma mark - UC登录接口定义
/*!
 * @brief  UC接口成功时的回调。
 */
typedef void (^BDMUCSuccessBlock)(BDMUCResponseModel *responseModel);

//[sunshiwen][chg]回调包含uc错误编码信息
///*!
// * @brief  UC接口失败时的回调。
// *
// * @param message 错误信息。
// */
//typedef void (^BDMUCFailureBlock)(NSString *message);

/*!
 * @brief  UC接口失败时的回调。
 *
 * @param message 错误信息。
 */
typedef void (^BDMUCFailureBlock)(NSError *error, BDMUCResponseModel *responseModel);

/*!
 * @brief  定义UC登录的接口。主要包括获取验证码、登录、验证登录、登出4个功能。
 */
@interface BDMUCLogonAssistant : NSObject

/*!
 * @brief  验证码获取。
 *
 * @param account UC账户。
 * @param success UC接口成功的回调。
 * @param failure UC接口失败的回调。
 */
+ (void)verificationCode:(BDMUCAccount *)account
                 success:(BDMUCSuccessBlock)success
                 failure:(BDMUCFailureBlock)failure;


/*!
 * @brief  登录。
 *
 * @param account UC账户。
 * @param success UC接口成功的回调。
 * @param failure UC接口失败的回调。
 */
+ (void)logon:(BDMUCAccount *)account
      success:(BDMUCSuccessBlock)success
      failure:(BDMUCFailureBlock)failure;

/*!
 * @brief  验证登录。
 *
 * @param account UC账户。
 * @param success UC接口成功的回调。
 * @param failure UC接口失败的回调。
 */
+ (void)verificationLogon:(BDMUCAccount *)account
                  success:(BDMUCSuccessBlock)success
                  failure:(BDMUCFailureBlock)failure;

/*!
 * @brief  登出。
 *
 * @param account UC账户。
 * @param success UC接口成功的回调。
 * @param failure UC接口失败的回调。
 */
+ (void)logout:(BDMUCAccount *)account
       success:(BDMUCSuccessBlock)success
       failure:(BDMUCFailureBlock)failure;

/*!
 * @brief  生成新权限验证的请求包。
 *
 * @param account UC账户。
 */
+ (NSData *)generateACSValidateData:(BDMUCAccount *)account;

@end

/*!
 * @brief  用户登录成功时发出通知。
 */
extern NSString * const BDMUCLogonSuccessNotification;

/*!
 * @brief  用户登录失败时发出通知。
 */
extern NSString * const BDMUCLogonFailureNotification;

/*!
 * @brief  用户准备注销时发出通知。
 */
extern NSString * const BDMUCWillLogoutNotification;

/*!
 * @brief  用户注销成功时发出通知。
 */
extern NSString * const BDMUCDidLogoutNotification;
