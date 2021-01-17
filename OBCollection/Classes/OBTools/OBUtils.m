//
//  OBUtils.m
//  ForORTest
//
//  Created by orange on 2020/11/23.
//

#import "OBUtils.h"
#import <objc/runtime.h>

@implementation OBUtils

+ (SEL)makeNewSelectorFromSelector:(SEL)selector {
    return NSSelectorFromString([NSString stringWithFormat:@"_ob_swizzle_%x_%@",arc4random(),NSStringFromSelector(selector)]);
}

+ (void)replaceSelector:(SEL)originalSelector onClass:(Class)class withBlock:(id)block newSelector:(SEL)newSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    if (!originalSelector) {
        return;
    }
    IMP implementation = imp_implementationWithBlock(block); //将block里面的方法转为IMP
    class_addMethod(class, newSelector, implementation, method_getTypeEncoding(originalMethod)); //给class添加新的方法
    Method newMethod = class_getInstanceMethod(class, newSelector); //获取新添加的方法
    method_exchangeImplementations(originalMethod, newMethod); //交换新旧方法
}

+ (NSString *)timeFromDate:(NSDate *)date Format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd HH:mm:ss";
    if (format.length) {
        formatString = format;
    }
    [dateFormatter setDateFormat:formatString];
    NSString *timgString = [dateFormatter stringFromDate:date];
    return timgString.length ? timgString : @"";
}

+ (NSInteger)currentSeconds {
    NSInteger seconds = [[NSDate date] timeIntervalSince1970] * 1000;
    return seconds;
}

+ (NSString *)currentTime {
    return [self timeFromDate:[NSDate date] Format:@""];
}

+ (NSString *)dictionaryToString:(NSDictionary *)dic {
    NSString *jsonString = nil;
    if (!dic) {
        return jsonString;
    }
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if (data) {
        jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSString *)deviceNameWithMachine:(NSString *)machine {
    static NSDictionary* deviceNamesByMachine = nil;
    if (!deviceNamesByMachine) {
        deviceNamesByMachine = @{@"iPod1,1"    :@"iPod Touch1",
                              @"iPod2,1"    :@"iPod Touch2",
                              @"iPod3,1"    :@"iPod Touch3",
                              @"iPod4,1"    :@"iPod Touch4",
                              @"iPod5,1"    :@"iPod Touch5",
                              @"iPod7,1"    :@"iPod Touch6",
                              @"iPod9,1"    :@"iPod Touch7",
                              
                              @"iPad1,1"    :@"iPad1 (Wi-Fi/3G/GPS(Original/1st Gen))",
                              @"iPad2,1"    :@"iPad2 (Wi-Fi Only)",
                              @"iPad2,2"    :@"iPad2 (Wi-Fi/GSM/GPS)",
                              @"iPad2,3"    :@"iPad2 (Wi-Fi/CDMA/GPS)",
                              @"iPad2,4"    :@"iPad2 (Wi-Fi Only)",
                              @"iPad2,5"    :@"iPad mini (Wi-Fi Only/1st Gen)",
                              @"iPad2,6"    :@"iPad mini (Wi-Fi/AT&T/GPS - 1st Gen)",
                              @"iPad2,7"    :@"iPad mini (Wi-Fi/VZ & Sprint/GPS - 1st Gen)",
                              @"iPad3,1"    :@"iPad3 (Wi-Fi Only)",
                              @"iPad3,2"    :@"iPad3 (Wi-Fi/Cellular Verizon/GPS)",
                              @"iPad3,3"    :@"iPad3 (Wi-Fi/Cellular AT&T/GPS)",
                              @"iPad3,4"    :@"iPad4 (Wi-Fi Only)",
                              @"iPad3,5"    :@"iPad4 (Wi-Fi/AT&T/GPS)",
                              @"iPad3,6"    :@"iPad4 (Wi-Fi/Verizon & Sprint/GPS)",
                              @"iPad4,1"    :@"iPad Air (Wi-Fi Only)",
                              @"iPad4,2"    :@"iPad Air (Wi-Fi/Cellular)",
                              @"iPad4,3"    :@"iPad Air (Wi-Fi/TD-LTE - China)",
                              @"iPad4,4"    :@"iPad mini (Retina/2nd Gen - Wi-Fi Only)",
                              @"iPad4,5"    :@"iPad mini (Retina/2nd Gen - Wi-Fi/Cellular)",
                              @"iPad4,6"    :@"iPad mini (Retina/2nd Gen - China)",
                              @"iPad4,7"    :@"iPad mini 3 (Wi-Fi Only)",
                              @"iPad4,8"    :@"iPad mini 3 (Wi-Fi/Cellular)",
                              @"iPad4,9"    :@"iPad mini 3",
                              @"iPad5,1"    :@"iPad mini 4",
                              @"iPad5,2"    :@"iPad mini 4",
                              @"iPad5,3"    :@"iPad Air 2 (Wi-Fi Only)",
                              @"iPad5,4"    :@"iPad Air 2 (Wi-Fi/Cellular)",
                              @"ipad6,3"    :@"iPad pro",
                              @"ipad6,4"    :@"iPad pro",
                              @"ipad6,7"    :@"iPad pro",
                              @"ipad6,8"    :@"iPad pro",
                              @"iPad6,11"   :@"iPad5",
                              @"iPad6,12"   :@"iPad5",
                              
                              @"iPad7,1"    :@"iPad pro2(12.9)",
                              @"iPad7,2"    :@"iPad pro2(12.9)",
                              @"iPad7,3"    :@"iPad pro(10.5)",
                              @"iPad7,4"    :@"iPad pro(10.5)",
                              @"iPad7,5"    :@"iPad 6 (WiFi)",
                              @"iPad7,6"    :@"iPad 6 (Cellular)",
                              @"iPad8,1"    :@"iPad Pro(11-inch)",
                              @"iPad8,2"    :@"iPad Pro (11-inch)",
                              @"iPad8,3"    :@"iPad Pro (11-inch)",
                              @"iPad8,4"    :@"iPad Pro (11-inch)",
                              @"iPad8,5"    :@"iPad Pro 3",
                              @"iPad8,6"    :@"iPad Pro 3",
                              @"iPad8,7"    :@"iPad Pro 3",
                              @"iPad8,8"    :@"iPad Pro 3",
                              @"iPad11,1"   :@"iPad Mini 5 WiFi",
                              @"iPad11,2"   :@"iPad Mini 5",
                              @"iPad11,3"   :@"iPad Air 3 WiFi",
                              @"iPad11,4"   :@"iPad Air 3",
                              
                              @"i386"       :@"iPhone Simulator",
                              @"x86_64"     :@"iPhone Simulator",
                              
                              @"iPhone1,1"  :@"iPhone 3GS",
                              @"iPhone1,2"  :@"iPhone 3GS",
                              @"iPhone2,1"  :@"iPhone 3GS",
                              @"iPhone3,1"  :@"iPhone 4 GSM",
                              @"iPhone3,2"  :@"iPhone 4",
                              @"iPhone3,3"  :@"iPhone 4 CDMA",
                              @"iPhone4,1"  :@"iPhone 4S",
                              @"iPhone5,1"  :@"iPhone 5",
                              @"iPhone5,2"  :@"iPhone 5",
                              @"iPhone5,3"  :@"iPhone 5c",
                              @"iPhone5,4"  :@"iPhone 5c",
                              @"iPhone6,1"  :@"iPhone 5s",
                              @"iPhone6,2"  :@"iPhone 5s",
                              @"iPhone7,1"  :@"iPhone 6 Plus",
                              @"iPhone7,2"  :@"iPhone 6",
                              @"iPhone8,1"  :@"iPhone 6S",
                              @"iPhone8,2"  :@"iPhone 6S Plus",
                              @"iPhone8,4"  :@"iPhone SE",
                              @"iPhone9,1"  :@"iPhone 7",
                              @"iPhone9,3"  :@"iPhone 7",
                              @"iPhone9,2"  :@"iPhone 7 Plus",
                              @"iPhone9,4"  :@"iPhone 7 Plus",
                              @"iPhone10,1" :@"iPhone 8",
                              @"iPhone10,4" :@"iPhone 8",
                              @"iPhone10,2" :@"iPhone 8 Plus",
                              @"iPhone10,5" :@"iPhone 8 Plus",
                              @"iPhone10,3" :@"iPhone X",
                              @"iPhone10,6" :@"iPhone X",
                              @"iPhone11,2" :@"iPhone XS",
                              @"iPhone11,4" :@"iPhone XS Max",
                              @"iPhone11,6" :@"iPhone XS Max",
                              @"iPhone11,8" :@"iPhone XR",
                              @"iPhone12,1" :@"iPhone 11",
                              @"iPhone12,3" :@"iPhone 11 Pro",
                              @"iPhone12,5" :@"iPhone 11 Pro Max"
                              };
    }
    NSString *unknownMachine = machine;
    if (unknownMachine.length) {
        unknownMachine = [deviceNamesByMachine objectForKey:unknownMachine];
    }
    return unknownMachine.length ? unknownMachine : @"";
}

@end
