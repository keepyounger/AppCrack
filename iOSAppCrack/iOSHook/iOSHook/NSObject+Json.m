//
//  NSObject+Json.m
//  iOSHook
//
//  Created by lixy on 2018/6/22.
//  Copyright © 2018年 lixy. All rights reserved.
//

#import "NSObject+Json.h"

@implementation NSJSONSerialization (Json)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self jr_swizzleClassMethod:@selector(JSONObjectWithData:options:error:) withClassMethod:@selector(xy_JSONObjectWithData:options:error:) error:nil];
    });
}

+ (id)xy_JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError * _Nullable __autoreleasing *)error
{
    id obj = [self xy_JSONObjectWithData:data options:opt error:nil];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [self modifyWithDic:obj];
    }
    if ([obj isKindOfClass:[NSArray class]]) {
        return [self modifyWithArray:obj];
    }
    return obj;
}

+ (NSDictionary *)modifyWithDic:(NSDictionary *)dic
{
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            temp[key] = [self modifyWithArray:obj];
        }
        if ([obj isKindOfClass:[NSDictionary class]]) {
            temp[key] = [self modifyWithDic:obj];
        }
    }];
    return temp;
}

+ (NSArray *)modifyWithArray:(NSArray *)array
{
    NSMutableArray *temp = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[self modifyWithDic:obj]];
        } else {
            [temp addObject:obj];
        }
    }];
    return temp;
}

@end
