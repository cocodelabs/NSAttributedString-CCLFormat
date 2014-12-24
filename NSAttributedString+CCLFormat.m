//
//  NSAttributedString+CCLFormat.m
//  Cocode
//
//  Created by Kyle Fuller on 06/11/2012.
//  Copyright (c) 2012-2014 Cocode. All rights reserved.
//

#import "NSAttributedString+CCLFormat.h"

@implementation NSAttributedString (CCLFormat)

+ (instancetype)attributedStringWithFormat:( NSString* )format, ...
{
    va_list args;
    va_start(args, format);
    NSAttributedString* result = [self attributedStringWithFormat: format arguments: args];
    va_end(args);
    return result;
}

+ (instancetype)attributedStringWithFormat:(NSString *)format
                                 arguments:(va_list)args {

    NSMutableArray *attributes = [NSMutableArray array];

    NSString *string = [format stringByReplacingOccurrencesOfString:@"%@" withString:@""];
    NSUInteger count = ([format length] - [string length]) / [@"%@" length];

    for (NSUInteger index = 0; index < count; index++) {
        id argument = va_arg(args, id);
        [attributes addObject:argument];
    }

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:format];
    [attributedString beginEditing];

    NSRange range = [format rangeOfString:@"%@" options:NSBackwardsSearch];
    for (NSUInteger index = 0; range.location != NSNotFound; index++) {
        id attribute = [attributes lastObject];
        [attributes removeLastObject];

        if ([attribute isKindOfClass:[NSAttributedString class]]) {
            [attributedString replaceCharactersInRange:range withAttributedString:attribute];
        } else {
            [attributedString replaceCharactersInRange:range withString:[attribute description]];
        }

        range = NSMakeRange(0, range.location);
        range = [format rangeOfString:@"%@" options:NSBackwardsSearch range:range];
    }

    [attributedString endEditing];
    return [[[self class] alloc] initWithAttributedString: attributedString];
}

@end

