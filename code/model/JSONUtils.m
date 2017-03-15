
#import "JSONUtils.h"

@interface JSONUtils()<NSKeyedArchiverDelegate, NSKeyedUnarchiverDelegate>

@end

@implementation JSONUtils

+ (instancetype)delegate {
    static JSONUtils *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}

+ (id)JSONObjectWithoutNull:(id)JSONObject {
    
    if ([JSONObject isKindOfClass:[NSDictionary class]] ||
        [JSONObject isKindOfClass:[NSArray class]]) {
        
        NSMutableData *data = [NSMutableData data];
        
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        archiver.delegate = [JSONUtils delegate];
        [archiver encodeObject:JSONObject forKey:@"json"];
        [archiver finishEncoding];
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        id JSONObjectWithoutNull = [unarchiver decodeObjectForKey:@"json"];
        [unarchiver finishDecoding];
        
        return JSONObjectWithoutNull;
    }
    
    return JSONObject;
}

- (id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object {
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = [(NSDictionary *)object allKeysForObject:[NSNull null]];
        if (keys.count > 0) {
            NSMutableDictionary *dict = [(NSMutableDictionary *)object mutableCopy];
            [dict removeObjectsForKeys:keys];
            return dict;
        }
        
    } else if ([object isKindOfClass:[NSArray class]]) {
        NSIndexSet *indexes = [(NSArray *)object indexesOfObjectsPassingTest:
                               ^BOOL(id  _Nonnull obj,
                                     NSUInteger idx,
                                     BOOL * _Nonnull stop) {
                                   return ![obj isEqual:[NSNull null]];
                               }];
        if (indexes.count != [(NSArray *)object count]) {
            return [(NSArray *)object objectsAtIndexes:indexes];
        }
    }
    return object;
}

#pragma mark - Type check

+ (id)convertObject:(id)object toType:(Class)aClass {
    
    if (!object || !aClass) {
        return nil;
    }
    
    if ([object isKindOfClass:aClass]) {
        return object;
    }
    
    NSString *(^toString)(NSNumber *) = ^(NSNumber *number) {
        NSString *doubleString        = [NSString stringWithFormat:@"%lf", [number doubleValue]];
        NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
        return [NSString stringWithFormat:@"%@", decNumber];
    };
    
    NSNumber *(^toNumber)(NSString *) = ^(NSString *string) {
        string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSNumber *integerValue = @(string.integerValue);
        NSString *stringValue = [NSString stringWithFormat:@"%@", integerValue];
        if ([string isEqualToString:stringValue]) {
            return integerValue;
        } else {
            return @(string.doubleValue);
        }
    };
    
    if ([object isKindOfClass:[NSString class]] &&
        [aClass isSubclassOfClass:[NSNumber class]]) {
        return toNumber(object);
        
    } else if ([object isKindOfClass:[NSNumber class]] &&
               [aClass isSubclassOfClass:[NSString class]]) {
        return toString(object);
    }
    
    return nil;
}

@end
