//
//  BDMPathManager.m
//  iJobs
//
//  Created by bailu on 15-3-24.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDMPathManager.h"
#import "BDMUtility.h"
#include <sys/stat.h>
#include <dirent.h>

#pragma mark 宏定义

#define PROPERTY_READONLY_GETTER_IMPL(propertyName, parentPath, subPath) \
@synthesize propertyName = _##propertyName; \
- (NSString* )propertyName \
{ \
if ([BDMUtility isEmptyString:_##propertyName]) { \
_##propertyName = [NSString stringWithFormat:@"%@/%@", parentPath, subPath]; \
} \
[self createPath:_##propertyName]; \
return _##propertyName;\
}

@interface BDMPathManager ()
- (void)createPath:(NSString *)path;
- (uint64_t)calcFolderSize:(const char *)path;
- (NSString *)generalMD5URL:(NSString *)user signature:(NSString *)signture;
@end

@implementation BDMPathManager

PROPERTY_READONLY_GETTER_IMPL(appRootDocumentPath, PATH_OF_DOCUMENT, @"AppLevel");
PROPERTY_READONLY_GETTER_IMPL(appConfigPath, self.appRootDocumentPath, @"Config");
PROPERTY_READONLY_GETTER_IMPL(appDatabasePath, self.appRootDocumentPath, @"Database");
PROPERTY_READONLY_GETTER_IMPL(appLogPath, self.appRootDocumentPath, @"Log");
PROPERTY_READONLY_GETTER_IMPL(appCrashReporterPath, self.appRootDocumentPath, @"CrashReporter");
PROPERTY_READONLY_GETTER_IMPL(userRootDocumentPath, PATH_OF_DOCUMENT, @"UserLevel");

PROPERTY_READONLY_GETTER_IMPL(appRootCachePath, PATH_OF_CACHE, @"AppLevel");
PROPERTY_READONLY_GETTER_IMPL(appImagesCachePath, self.appRootCachePath, @"Images");
PROPERTY_READONLY_GETTER_IMPL(appSoundsCachePath, self.appRootCachePath, @"Sounds");
PROPERTY_READONLY_GETTER_IMPL(appVideosCachePath, self.appRootCachePath, @"Videos");
PROPERTY_READONLY_GETTER_IMPL(userRootCachePath, PATH_OF_CACHE, @"UserLevel");

+ (BDMPathManager *)sharedInstance
{
    static BDMPathManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BDMPathManager alloc] init];
    });
    
    return instance;
}

/**
 *  @brief  获取已下载的文件大小
 *
 *  @param path 文件路径
 *
 *  @return 文件大小
 */
- (unsigned long long)fileSizeForPath:(NSString *)path
{
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

- (NSString *)cacheSize
{
    uint64_t totalSize = [self calcFolderSize:[PATH_OF_CACHE UTF8String]];
    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:totalSize
                                                             countStyle:NSByteCountFormatterCountStyleFile];
    return folderSizeStr;
}

- (void)clearAllCaches
{
    NSArray *items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:PATH_OF_CACHE error:nil];
    for (NSString *file in items) {
        NSString* fullPath = [NSString stringWithFormat:@"%@/%@", PATH_OF_CACHE, file];
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
    }
}

- (void)clearAppCaches
{
    [[NSFileManager defaultManager] removeItemAtPath:self.appRootCachePath error:nil];
    [self createPath:self.appRootCachePath];
}

- (void)clearUserCaches
{
    [[NSFileManager defaultManager] removeItemAtPath:self.userRootCachePath error:nil];
    [self createPath:self.userRootCachePath];
}

- (NSString *)userDocumentPath:(NSString *)user signature:(NSString *)signature
{
    NSString *md5 = [self generalMD5URL:user signature:signature];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", self.userRootDocumentPath, md5];
    [self createPath:fullPath];
    return fullPath;
}

- (NSString *)userCachePath:(NSString *)user signature:(NSString *)signature
{
    NSString *md5 = [self generalMD5URL:user signature:signature];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", self.userRootCachePath, md5];
    [self createPath:fullPath];
    return fullPath;
}

- (void)clearUserCache:(NSString *)user signature:(NSString *)signature
{
    NSString *md5 = [self generalMD5URL:user signature:signature];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", self.userRootCachePath, md5];
    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
    [self createPath:fullPath];
}

#pragma mark 私有方法
- (void)createPath:(NSString *)path
{
    if ([BDMUtility isEmptyString:path]) {
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (uint64_t) calcFolderSize: (const char*)folderPath{
   
    uint64_t folderSize = 0;
    DIR* dir = opendir(folderPath);
    
    if (dir == NULL) {
        return 0;
    }
    
    struct dirent* child;
    while ((child = readdir(dir)) != NULL) {
        if (child->d_type == DT_DIR
            && ((child->d_name[0] == '.' && child->d_name[1] == 0)
                || (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0))) {
            continue;
        }
        
        char childPath[1024];
        int folderPathLength = strlen(folderPath);
        stpcpy(childPath, folderPath);
        
        if (folderPath[folderPathLength - 1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        
        stpcpy(childPath + folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        
        struct stat st;
        if (child->d_type == DT_DIR) {
            folderSize += [self calcFolderSize:childPath];
            if(lstat(childPath, &st) == 0) {
                folderSize += st.st_size;
            }
        } else if (child->d_type == DT_REG || child->d_type == DT_LNK) {
            if(stat(childPath, &st) == 0) {
                folderSize += st.st_size;
            }
        }
    }
    
    closedir(dir);
    return folderSize;
}

- (NSString *)generalMD5URL:(NSString *)user signature:(NSString *)signture
{
    NSString *catURL = [NSString stringWithFormat:@"%@_|_%@", user, signture];
    return [BDMUtility md5Hash:catURL];
}
@end
