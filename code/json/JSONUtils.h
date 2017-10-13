
#import <Foundation/Foundation.h>

@interface JSONUtils : NSObject

+ (id)JSONObjectWithoutNull:(id)JSONObject;

+ (id)convertObject:(id)object toType:(Class)aClass;

@end

#define JSONToType(obj, type) [JSONUtils convertObject:obj toType:[type class]]
