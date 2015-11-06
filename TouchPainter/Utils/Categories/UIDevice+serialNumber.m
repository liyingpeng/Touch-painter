/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "UIDevice+serialNumber.h"
#import <dlfcn.h>
#import <mach/port.h>
#import <mach/kern_return.h>
#import <AdSupport/AdSupport.h>
#import "UICKeyChainStore.h"
#import "SSKeychain.h"

static NSString* const kKeyChainDeviceNumberService = @"com.baidu.opmd.jobs.deviceNumber";
static NSString* const kKeyChainGroup = @"com.opmd.jobs";

@implementation UIDevice (serialNumber)

- (NSString *) serialNumber
{
    
    NSString *serialNumber = [SSKeychain passwordForService:kKeyChainDeviceNumberService account:kKeyChainGroup];
    if (!serialNumber) {
        serialNumber = [BDMUtility createCFUUID];
        [SSKeychain setPassword:serialNumber forService:kKeyChainDeviceNumberService account:kKeyChainGroup];
    }
//    void *IOKit = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW);
//    if (IOKit)
//    {
//        mach_port_t *kIOMasterPortDefault = dlsym(IOKit, "kIOMasterPortDefault");
//        CFMutableDictionaryRef (*IOServiceMatching)(const char *name) = dlsym(IOKit, "IOServiceMatching");
//        mach_port_t (*IOServiceGetMatchingService)(mach_port_t masterPort, CFDictionaryRef matching) = dlsym(IOKit, "IOServiceGetMatchingService");
//        CFTypeRef (*IORegistryEntryCreateCFProperty)(mach_port_t entry, CFStringRef key, CFAllocatorRef allocator, uint32_t options) = dlsym(IOKit, "IORegistryEntryCreateCFProperty");
//        kern_return_t (*IOObjectRelease)(mach_port_t object) = dlsym(IOKit, "IOObjectRelease");
//        
//        if (kIOMasterPortDefault && IOServiceGetMatchingService && IORegistryEntryCreateCFProperty && IOObjectRelease)
//        {
//            mach_port_t platformExpertDevice = IOServiceGetMatchingService(*kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
//            if (platformExpertDevice)
//            {
//                CFTypeRef platformSerialNumber = IORegistryEntryCreateCFProperty(platformExpertDevice, CFSTR("IOPlatformSerialNumber"), kCFAllocatorDefault, 0);
//                if (platformSerialNumber && CFGetTypeID(platformSerialNumber) == CFStringGetTypeID())
//                {
//                    serialNumber = [NSString stringWithString:(__bridge NSString*)platformSerialNumber];
//                    CFRelease(platformSerialNumber);
//                }
//                IOObjectRelease(platformExpertDevice);
//            }
//        }
//        dlclose(IOKit);
//    }
//    
//    // PATCH：解决iOS 8 获取不了设备序列号问题。
//    // SOLUTION： 生成UDID并保存在keychain中。keychain中标记kSecAttrSynchronizable和kSecAttrAccessibleAlwaysThisDeviceOnly来防止iCloud 恢复和同步以及iTunes恢复和同步造成的多设备同UDID的情况。
//    if (!serialNumber) {
//        
//        NSString* udid = [UICKeyChainStore stringForKey:@"udid" service:@"com.baidu.opmd.jobs.device"];
//        if (!udid) {
//            serialNumber = [[self identifierForVendor] UUIDString];
//            [UICKeyChainStore setString:serialNumber forKey:@"udid" service:@"com.baidu.opmd.jobs.device"];
//        }else{
//            serialNumber = udid;
//        }
//    }
//    // PATCH END
    
    return serialNumber;
}


@end
