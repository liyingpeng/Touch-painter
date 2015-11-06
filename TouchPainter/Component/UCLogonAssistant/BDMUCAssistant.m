//
//  BDMUCAssistant.m
//  iJobs
//
//  Created by bailu on 15-7-7.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDMUCAssistant.h"
#import "BDMUtility.h"
#import "BDMMacroDefine.h"
#import "BDMNetworkManager.h"
#import "BDMHTTPRequestModel.h"

#import "AppDef.h"
#import "NSData+GZip.h"
#import "IJRSAWrapper.h"
#import "UIDevice+serialNumber.h"

/*!
 * @brief  UC的一些基础配置信息, 在请求UC服务器时使用。
 */
@interface BDMUCConfiguration : NSObject

+ (BDMUCConfiguration *)configuration;

/*!
 * @brief  UC分配的，表示访问来源。
 */
@property(nonatomic) NSInteger clientID;

/*!
 * @brief  加密类型。
 */
@property(nonatomic) NSInteger encryptType;

/*!
 * @brief  用户类型。
 */
@property(nonatomic) NSInteger userType;

/*!
 * @brief  UC分配的应用程序ID。
 */
@property(nonatomic) NSInteger appID;

/*!
 * @brief  加密时的公钥。
 */
@property(nonatomic, copy) NSString *rsaPublicKey;

@end

@implementation BDMUCConfiguration

+ (BDMUCConfiguration *)configuration {
    BDMUCConfiguration *configuration = [[BDMUCConfiguration alloc] init];
    configuration.clientID = kClientId;
    configuration.encryptType = kEncryptType;
    configuration.userType = kUserType;
    configuration.appID = kAppClientID;
    configuration.rsaPublicKey = kRSAPubliKey;
    return configuration;
}

@end

@implementation BDMUCResponseModel
@end

@implementation BDMUCAccount
@end

// 登录状态改变时的通知。
NSString * const BDMUCLogonSuccessNotification = @"com.baidu.cid.uc.logon.success";
NSString * const BDMUCLogonFailureNotification = @"com.baidu.cid.uc.logon.failure";
NSString * const BDMUCWillLogoutNotification = @"com.baidu.cid.uc.will.logout";
NSString * const BDMUCDidLogoutNotification = @"com.baidu.cid.uc.did.logout";

@implementation BDMUCLogonAssistant

#pragma mark - public methods
+ (void)verificationCode:(BDMUCAccount *)account
                 success:(BDMUCSuccessBlock)success
                 failure:(BDMUCFailureBlock)failure {
    if ([BDMUtility isEmptyString:account.username]) {
        return;
    }
    
    BDMUCConfiguration *configuration = [BDMUCConfiguration configuration];
    
    NSString *deviceModel = [UIDevice currentDevice].model;
    NSDictionary* parameters = @{@"osVersion" : kSystemVersion,
                                 @"deviceType" : deviceModel,
                                 @"clientVersion": kAppVersion};
    
    NSData *requestData = [self buildRequestData:configuration
                                        username:account.username
                                        function:@"preLogin"
                                      parameters:parameters];
    
    [self sendRequest:requestData parameters:parameters success:^(id data) {
        NSDictionary* dict = data;
        BDMUCResponseModel *responseModel = [[BDMUCResponseModel alloc] init];
        responseModel.returnCode = BDMUCCodeOK;
        
        NSInteger needAuth = [[dict objectForKey:@"needAuthCode"] integerValue];
        if (needAuth) {
            
            NSDictionary* authCode = [dict objectForKey:@"authCode"];
            if (authCode && [authCode isKindOfClass:[NSDictionary class]]) {
                NSString *imageString = [authCode objectForKey:@"imgdata"];
                NSString *imageSSID = [authCode objectForKey:@"imgssid"];
                
                account.imageData = imageString;
                account.imageSSID = imageSSID;
            }
        }
        
        if (success) {
            success(responseModel);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error,nil);
        }
    }];
}


+ (void)logon:(BDMUCAccount *)account
      success:(BDMUCSuccessBlock)success
      failure:(BDMUCFailureBlock)failure {
    
    if ([BDMUtility isEmptyString:account.username]
        || [BDMUtility isEmptyString:account.password]) {
        return;
    }
    
    BDMUCConfiguration *configuration = [BDMUCConfiguration configuration];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:account.password forKey:@"password"];
    
    if (account.imageSSID && account.imageCode) {
        [parameters setObject:account.imageCode forKey:@"imageCode"];
        [parameters setObject:account.imageSSID forKey:@"imageSsid"];
    }
    
    NSData *requestData = [self buildRequestData:configuration
                                        username:account.username
                                        function:@"doLogin"
                                      parameters:parameters];
    
    [self sendRequest:requestData parameters:parameters success:^(id data) {
        //立刻清空登录密码。
        account.password = nil;
        BDMUCResponseModel *responseModel = [[BDMUCResponseModel alloc] init];
        responseModel.returnCode = [[data objectForKey:@"retcode"] integerValue];
        responseModel.returnMessage = [data objectForKey:@"retmsg"];
        if (responseModel.returnCode == BDMUCCodeOK) {
            account.logonTime = [NSDate date];
            account.imageData = nil;
            account.imageSSID = nil;
            account.sessionTicket = [data objectForKey:@"st"];
            account.ucid = [[data objectForKey:@"ucid"] integerValue];
            
            if (success) {
                success(responseModel);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center postNotificationName:BDMUCLogonSuccessNotification object:nil];
            });
        } else {
            if (failure) {
                failure(nil,responseModel);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center postNotificationName:BDMUCLogonFailureNotification object:nil];
            });
        }
        
    } failure:^(NSError *error) {
        //立刻清空登录密码。
        account.password = nil;
        if (failure) {
            failure(error,nil);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:BDMUCLogonFailureNotification object:nil];
        });
    }];
}

+ (void)verificationLogon:(BDMUCAccount *)account
                  success:(BDMUCSuccessBlock)success
                  failure:(BDMUCFailureBlock)failure {
    if (!account.ucid
        || [BDMUtility isEmptyString:account.sessionTicket]
        || [BDMUtility isEmptyString:account.username]) {
        return;
    }
    
    BDMUCConfiguration *configuration = [BDMUCConfiguration configuration];
    
    NSDictionary *parameters = @{@"ucid" : @(account.ucid), @"st" : account.sessionTicket};
    NSData *requestData = [self buildRequestData:configuration
                                        username:account.username
                                        function:@"validate"
                                      parameters:parameters];
    
    [self sendRequest:requestData parameters:parameters success:^(id data) {
        BDMUCResponseModel *responseModel = [[BDMUCResponseModel alloc] init];
        responseModel.returnCode = [[data objectForKey:@"retcode"] integerValue];
        responseModel.returnMessage = [data objectForKey:@"retmsg"];
        
        if (responseModel.returnCode == BDMUCCodeOK) {
            account.logonTime = [NSDate date];
        } else {
            account.logonTime = nil;
        }
        
        if (success) {
            success(responseModel);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error,nil);
        }
    }];
}

+ (void)logout:(BDMUCAccount *)account
       success:(BDMUCSuccessBlock)success
       failure:(BDMUCFailureBlock)failure {
    if (!account.ucid
        || [BDMUtility isEmptyString:account.sessionTicket]
        || [BDMUtility isEmptyString:account.username]) {
        return;
    }
    
    BDMUCConfiguration *configuration = [BDMUCConfiguration configuration];
    
    NSDictionary *parameters = @{@"ucid" : @(account.ucid), @"st" : account.sessionTicket};
    NSData *requestData = [self buildRequestData:configuration
                                        username:account.username
                                        function:@"doLogout"
                                      parameters:parameters];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:BDMUCWillLogoutNotification object:nil];
    });
    
    [self sendRequest:requestData parameters:parameters success:^(id data) {
        BDMUCResponseModel *responseModel = [[BDMUCResponseModel alloc] init];
        responseModel.returnCode = [[data objectForKey:@"retcode"] integerValue];
        responseModel.returnMessage = [data objectForKey:@"retmsg"];
        if (responseModel.returnCode == BDMUCCodeOK) {
            account.imageData = nil;
            account.imageSSID = nil;
            account.sessionTicket = nil;
            account.ucid = 0;
            account.logonTime = nil;
        }
        
        if (success) {
            success(responseModel);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:BDMUCDidLogoutNotification object:nil];
        });
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error,nil);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:BDMUCDidLogoutNotification object:nil];
        });
    }];
}

+ (NSData *)generateACSValidateData:(BDMUCAccount *)account {
    BDMUCConfiguration *configuration = [BDMUCConfiguration configuration];
    
    NSDictionary *parameters = @{@"ucid" : @(account.ucid), @"st" : account.sessionTicket};
    NSData *requestData = [self buildRequestData:configuration
                                        username:account.username
                                        function:@"validate"
                                      parameters:parameters];
    NSData *validateData = [BDMUtility encodeData:requestData];

    return validateData;
}
#pragma mark - private methods

+ (NSData *)buildRequestHeader:(Byte)clientID
                   encryptType:(Byte)encrypt
                      userType:(Byte)userType {
    NSMutableData* data = [NSMutableData data];
    
    Byte byte = clientID >> 8;
    [data appendBytes:&byte length:1];
    
    byte = clientID;
    [data appendBytes:&byte length:1];
    
    byte = encrypt >> 8;
    [data appendBytes:&byte length:1];
    
    byte = encrypt;
    [data appendBytes:&byte length:1];
    
    byte = userType >> 8;
    [data appendBytes:&byte length:1];
    
    byte = userType;
    [data appendBytes:&byte length:1];
    
    byte = 0;
    [data appendBytes:&byte length:2];
    
    return data;
}

+ (NSData *)buildRequestBody:(BDMUCConfiguration *)configuration
                    username:(NSString *)username
                    function:(NSString *)function
                  parameters:(NSDictionary *)parameters {
    
    NSMutableString* result = [NSMutableString string];
    [result appendFormat:@"%@|", username];
    [result appendFormat:@"%d|", configuration.appID];
    [result appendFormat:@"%@|", function];

    // 封装UUID
    [result appendFormat:@"%@asdf|",[[UIDevice currentDevice] serialNumber]];

    NSMutableData* resultData = [NSMutableData data];
    [resultData appendData:[result dataUsingEncoding:NSUTF8StringEncoding]];

    NSData* jsonData = nil;
    if (parameters) {
        jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        if (jsonData) {
            [resultData appendData:jsonData];
        }
    }

    // resultData需要:
    // 1.GZip压缩.
    NSData* gzipData = [resultData gzippedData];
    [[IJRSAWrapper sharedInstance] setIdentifierForPublicKey:@"publicKey"
                                                  privateKey:nil
                                             serverPublicKey:@"serverKey"];

    IJRSAWrapper *rsaWrapper = [IJRSAWrapper sharedInstance];
    BOOL success = [rsaWrapper setPublicKeyFromJavaServer:configuration.rsaPublicKey];

    if (success) {
        NSData* encryptyData = [rsaWrapper encryptUsingServerPublicKeyWithData:gzipData];
        return encryptyData;
    }
    return nil;
}

+ (NSData *)buildRequestData:(BDMUCConfiguration *)configuration
                    username:(NSString *)username
                    function:(NSString *)function
                  parameters:(NSDictionary *)parameters {
    
    NSData *header = [self buildRequestHeader:configuration.clientID
                                  encryptType:configuration.encryptType
                                     userType:configuration.userType];
    
    NSData *body = [self buildRequestBody:configuration
                                 username:username
                                 function:function
                               parameters:parameters];
    
    NSMutableData *data = [NSMutableData dataWithData:header];
    [data appendData:body];
    
    return data;
}

+ (NSDictionary *)parseResponse:(NSData *)data error:(NSError **)error {
    
    // 长度不足以解析返回码。
    if (data.length <= 2) {
        return nil;
    }
    
    const char *charPtr = (const char*)[data bytes];
    NSInteger code = charPtr[0] << 8 | charPtr[1];
    
    // 有业务错误发生。
    if (code != 0) {
        NSString *reason = [self ucCodeToReadableString:code];
        NSDictionary* userInfo = @{NSLocalizedDescriptionKey:reason};
        *error = [[NSError alloc] initWithDomain:@"com.baidu.cid.mobile"
                                            code:code
                                        userInfo:userInfo];
        return nil;
    }
    
    // 没有消息体。
    if (data.length <= 8) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"没有消息体"};
        *error = [[NSError alloc] initWithDomain:@"com.baidu.cid.mobile" code:88 userInfo:userInfo];
        return nil;
    }

    // 取消息体。
    const char *msgPtr = charPtr + 8 * sizeof(char);
    NSUInteger msgLen = data.length - 8;
    NSMutableData* zippedData = [NSMutableData dataWithBytes:msgPtr length:msgLen];
    
    // 解压失败。
    NSData* unzipped = [zippedData gunzippedData];
    if (!unzipped) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"解压失败"};
        *error = [[NSError alloc] initWithDomain:@"com.baidu.cid.mobile" code:99 userInfo:userInfo];
        return nil;
    }
    
    return [NSJSONSerialization JSONObjectWithData:unzipped options:0 error:error];
}

+ (void)sendRequest:(NSData *)data
         parameters:(NSDictionary *)parameters
            success:(void (^) (id data))success
            failure:(void (^) (NSError* error))failure {
    BDMHTTPRequestModel *requestModel = [[BDMHTTPRequestModel alloc] init];
    requestModel.requestMethod = HTTP_REQUEST_POST;
    requestModel.requestUrl = [BDMProxyProtocol loginWithAccountURL];
    requestModel.requestType = HTTP_REQUEST_TYPE_DATA_UCLOGIN;
    requestModel.returnType = HTTP_RETURN_TYPE_DATA;
    NSMutableDictionary *tempParamDict = [[NSMutableDictionary alloc] init];
    [tempParamDict setObject:data forKey:HTTP_REQUEST_POST];
    requestModel.postDict = tempParamDict;
    
    BDMNetworkManager *manager = [BDMNetworkManager sharedInstance];
    [manager sendHttpRequestWithModel:requestModel success:^(id responseObject) {
        NSError *error = nil;
        NSData *data = responseObject;
        NSDictionary *parsedData = [self parseResponse:data error:&error];
        
        if (!error) {
            if (success) {
                success(parsedData);
            }
        } else {
            if (failure) {
                failure(error);
            }
        }
    } failure:^(BDMError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (NSString *)ucCodeToReadableString:(NSInteger)code {
    
    NSString *reason = @"";
    switch (code) {
        case BDMUCCodeClientIDIncorrect:
            reason = @"CLIENT ID错误";
            break;
        case BDMUCCodeEncryptTypeIncorrect:
            reason = @"加密方法错误";
            break;
        case BDMUCCodeDataIncorrect:
            reason = @"数据体损坏";
            break;
        case BDMUCCodeDataIsTooLarge:
            reason = @"数据太大（超过2K）";
            break;
        case BDMUCCodeDataIsTooSmall:
            reason = @"数据太小";
            break;
        case BDMUCCodeMessageFormatIncorrect:
            reason = @"请求消息体格式不正确";
            break;
        case BDMUCCodeMethodNotExist:
            reason = @"访问的方法不存在";
            break;
        case BDMUCCodeMethodProcessFailure:
            reason = @"方法处理出错";
            break;
        case BDMUCCodeTokenIncorrect:
            reason = @"TOKEN错误";
            break;
        case BDMUCCodeUsernameIncorrect:
            reason = @"用户名错误";
            break;
        case BDMUCCodeMethodExecuteFailure:
            reason = @"执行过程中出现错误";
            break;
        case BDMUCCodeUserTypeIncorrect:
            reason = @"错误的USERTYPE";
            break;
        case BDMUCCodeInformationIncompelete:
            reason = @"登录信息不完整";
            break;
        case BDMUCCodeVerificationCodeIncorrect:
            reason = @"验证码错误";
            break;
        case BDMUCCodeUsernamePasswordIncorrect:
            reason = @"用户名或密码错误";
            break;
        case BDMUCCodeUsernameNotFound:
            reason = @"找不到用户";
            break;
        case BDMUCCodeNeedModifyPassword:
            reason = @"强制修改密码";
            break;
        case BDMUCCodeAccountLocked:
            reason = @"账户被锁定";
            break;
        case BDMUCCodeNeedVerificationCode:
            reason = @"需要验证码";
            break;
        case BDMUCCodeSessionInvalid:
            reason = @"会话无效";
            break;
        case BDMUCCodeNeedAnswerProtectQuestion:
            reason = @"需要回答密保问题";
            break;
        case BDMUCCodeProtectQuestionAnswerIncorrect:
            reason = @"回答密保问题错误";
            break;
        case BDMUCCodeProtectQuestionAnswerOverrun:
            reason = @"回答密保问题错误超限";
            break;
        case BDMUCCodeNotLogon:
            reason = @"未登录";
            break;
        case BDMUCCodeNeedSMSVerification:
            reason = @"需要短信验证";
            break;
        case BDMUCCodeSMSVerificationOverrun:
            reason = @"验证短信错误超限";
            break;
        case BDMUCCodeMobileNumberIncorrect:
            reason = @"手机输入错误";
            break;
        case BDMUCCodeSMSSendFailure:
            reason = @"短信发送失败";
            break;
        case BDMUCCodeSMSVerificationError:
            reason = @"验证短信错误";
            break;
        case BDMUCCodeLogoutError:
            reason = @"登出错误";
            break;
        case BDMUCCodeUnknownError:
            reason = @"未知错误";
            break;
        case BDMUCCodeParameterError:
            reason = @"参数错误";
            break;
        case BDMUCCodeNotImplement:
            reason = @"功能未实现";
            break;
        case BDMUCCodeEmptyData:
            reason = @"数据为空";
            break;
        case BDMUCCodeLogonNotAllowed:
            reason = @"业务系统不允许登录";
            break;
        case BDMUCCodeRegisterInformationIncompelete:
            reason = @"应用系统注册信息不完整";
            break;
    }
    return reason;
}

@end
