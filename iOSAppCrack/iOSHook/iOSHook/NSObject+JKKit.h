//
//  NSObject+JKKit.h
//  insertDynamic
//
//  Created by lixy on 2018/3/9.
//

#import <Foundation/Foundation.h>

@interface NSObject (JKKit)
- (NSMutableDictionary*)dictionaryForPropertys;
- (NSMutableDictionary*)dictionaryForPropertysWithNil:(BOOL)flag;
- (NSMutableArray*)arrayForMethods;
@end
