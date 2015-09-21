//
//  NSAttributedString+CCLFormat.m
//  Cocode
//
//  Created by Kyle Fuller on 06/11/2012.
//  Copyright (c) 2012-2014 Cocode. All rights reserved.
//

#import "NSAttributedString+CCLFormat.h"

@implementation NSAttributedString (CCLFormat)

+ (instancetype)attributedStringWithFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSAttributedString *result = [[self alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    return result;
}

+ (instancetype)attributedStringWithFormat:(NSString *)format arguments:(va_list)arguments {
    return [[self alloc] initWithFormat:format arguments:arguments];
}

- (instancetype)initWithFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    self = [self initWithFormat:format arguments:args];
    va_end(args);
    
    return self;
}

- (instancetype)initWithFormat:(NSString *)format arguments:(va_list)args {
    NSMutableArray *attributes = [NSMutableArray array];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?:%@)|(?:%(\\d+)\\$@)"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:format
                                      options:0
                                        range:NSMakeRange(0, [format length])];
    
    NSTextCheckingResult *firstMatch = [matches objectAtIndex:0];
    
    BOOL positional = firstMatch.range.length > 2; //%@ (non-positional) has 2 characters, %1$@ (positional) has more than 2
    
    if (!positional) {
        NSString *string = [format stringByReplacingOccurrencesOfString:@"%@" withString:@""];
        NSUInteger count = ([format length] - [string length]) / [@"%@" length];
        
        for (NSUInteger index = 0; index < count; ++index) {
            id argument = va_arg(args, id);
            [attributes addObject:argument];
        }
    } else {
        NSInteger count = 0;
        for (NSTextCheckingResult *match in matches) {
            NSInteger currentArgIndex = [[format substringWithRange:[match rangeAtIndex:1]] integerValue];
            if (count < currentArgIndex) {
                count = currentArgIndex;
            }
        }
        for (NSUInteger index = 0; index < count; ++index) {
            id argument = va_arg(args, id);
            [attributes addObject:argument];
        }
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:format];
    [attributedString beginEditing];
    
    for(NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        
        if (!positional) {
            // %@, non-positional arguments needs assumed index
            NSRange range = [match range];
            
            id attribute = [attributes lastObject];
            [attributes removeLastObject];
            
            if ([attribute isKindOfClass:[NSAttributedString class]]) {
                [attributedString replaceCharactersInRange:range withAttributedString:attribute];
            } else {
                [attributedString replaceCharactersInRange:range withString:[attribute description]];
            }
            
            range = NSMakeRange(0, range.location);
            range = [format rangeOfString:@"%@" options:NSBackwardsSearch range:range];
            
        } else {
            // %1$@, index included in match
            NSInteger index = [[format substringWithRange:[match rangeAtIndex:1]] integerValue] - 1;
            id attribute = [attributes objectAtIndex:index];
            if ([attribute isKindOfClass:[NSAttributedString class]]) {
                [attributedString replaceCharactersInRange:match.range withAttributedString:attribute];
            } else {
                [attributedString replaceCharactersInRange:match.range withString:attribute];
            }
        }
    };
    
    [attributedString endEditing];
    
    return [self initWithAttributedString:attributedString];
}

@end
