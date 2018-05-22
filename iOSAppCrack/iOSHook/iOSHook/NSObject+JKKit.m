//
//  NSObject+JKKit.m
//  insertDynamic
//
//  Created by lixy on 2018/3/9.
//

#import "NSObject+JKKit.h"
#import <objc/runtime.h>

@implementation NSObject (JKKit)

- (NSMutableDictionary *)dictionaryForPropertysWithNil:(BOOL)flag
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) {
            [props setObject:propertyValue forKey:propertyName];
        } else if (flag) {
            [props setObject:@"" forKey:propertyName];
        }
    }
    
    //    u_int count;
    //    Ivar* ivars = class_copyIvarList([self class], &count);
    //    for (const Ivar*p = ivars; p < ivars+count; ++p) {
    //        Ivar const ivar = *p;
    //        NSString* propertyName = [NSString stringWithUTF8String:ivar_getName(ivar)];
    //        id propertyValue = [self valueForKey:(NSString *)propertyName];
    //        if (propertyValue) {
    //            [props setObject:propertyValue forKey:propertyName];
    //        } else if (flag) {
    //            [props setObject:@"" forKey:propertyName];
    //        }
    //    }
    
    free(properties);
    //    free(ivars);
    
    return props;
}

- (NSMutableDictionary *)dictionaryForPropertys
{
    return [self dictionaryForPropertysWithNil:YES];
}

- (NSMutableArray *)arrayForMethods
{
    NSMutableArray *methodsArray = [NSMutableArray array];
    u_int count;
    Method* methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i ++) {
        SEL name = method_getName(methods[i]);
        NSString* strName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        [methodsArray addObject:strName];
    }
    return methodsArray;
}

@end
