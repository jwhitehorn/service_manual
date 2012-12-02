//http://stackoverflow.com/questions/3293499/detecting-if-an-nsstring-contains

#import <Foundation/Foundation.h>

@interface NSString (JRStringAdditions)

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions) options;

@end

