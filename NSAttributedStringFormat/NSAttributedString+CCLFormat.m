//
//  NSAttributedString+CCLFormat.m
//  Cocode
//
//  Created by Kyle Fuller on 06/11/2012.
//  Copyright (c) 2012-2014 Cocode. All rights reserved.
//

#import "NSAttributedString+CCLFormat.h"

#pragma mark - Format String Parsing

/// Parsing State
typedef NS_ENUM(NSInteger, FormatStringState) {
    FormatStringStateUnknown,
    FormatStringStartFormat,
    FormatStringStatePositional,
    FormatStringStateEndPositional,
};

/// Structure to contain parsed format positions and ranges
@interface CCLFormatParseResult : NSObject

/// The range of the string in the format, for example the range of (%@ or %2$@)
@property (nonatomic, assign, readonly) NSRange range;

/// The index of the replacement, this would be the position of %@ or the position from a positional string (1 for %2$@).
@property (nonatomic, assign, readonly) NSUInteger index;

@end

@implementation CCLFormatParseResult

- (instancetype)initWithRange:(NSRange)range index:(NSUInteger)index {
    if (self = [super init]) {
        _range = range;
        _index = index;
    }

    return self;
}

@end

/// Parse replacements (%@ and positional %1$@) from a format string into CCLFormatParseResult instances
NSArray *CCLFormatStringParser(NSString *format, NSUInteger *maxPosition) {
    NSMutableArray *arguments = [NSMutableArray array];
    NSUInteger position = 0;  // Position is incrememented each time an %@ is found
    *maxPosition = 0;  // The maximum found format replacement
    NSUInteger start = NSNotFound;
    NSMutableString *positionString = nil;
    FormatStringState state = FormatStringStateUnknown;
    for (NSUInteger index = 0; index < format.length; ++index) {
        unichar character = [format characterAtIndex:index];

        if (character == '%') {
            start = index;
            state = FormatStringStartFormat;
        } else if (state != FormatStringStateUnknown) {
            if (character == '@') {
                NSUInteger currentPosition;
                if (positionString == nil) {
                    currentPosition = position;
                    ++position;
                } else {
                    currentPosition = [positionString integerValue] - 1;
                    positionString = nil;
                }
                CCLFormatParseResult *result = [[CCLFormatParseResult alloc] initWithRange:NSMakeRange(start, (index + 1) - start) index:currentPosition];
                [arguments addObject:result];
                *maxPosition = MAX(*maxPosition, currentPosition + 1);
                state = FormatStringStateUnknown;
            } else if ((state == FormatStringStartFormat || state == FormatStringStatePositional) && isdigit(character)) {
                if (positionString == nil) {
                    positionString = [[NSMutableString alloc] initWithCharacters:&character length:1];
                } else {
                    [positionString appendString:[[NSMutableString alloc] initWithCharacters:&character length:1]];
                }
                state = FormatStringStatePositional;
            } else if (state == FormatStringStatePositional && character == '$') {
                state = FormatStringStateEndPositional;
            } else {
                state = FormatStringStateUnknown;
            }
        }
    }

    return arguments;
}

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
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:format];
    [attributedString beginEditing];

    NSUInteger maxPosition;
    // We want to start at the back
    NSArray *parseResults = [CCLFormatStringParser(format, &maxPosition) sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(CCLFormatParseResult *lhs, CCLFormatParseResult *rhs) {
        return lhs.range.location < rhs.range.location;
    }];

    NSMutableArray *attributes = [NSMutableArray array];
    for (NSUInteger index = 0; index < maxPosition; ++index) {
        id argument = va_arg(args, id);
        [attributes addObject:argument];
    }

    for (CCLFormatParseResult *parseResult in parseResults) {
        id arg = [attributes objectAtIndex:parseResult.index];

        if ([arg isKindOfClass:[NSAttributedString class]]) {
            [attributedString replaceCharactersInRange:parseResult.range withAttributedString:arg];
        } else {
            [attributedString replaceCharactersInRange:parseResult.range withString:[arg description]];
        }
    }

    [attributedString endEditing];

    return [self initWithAttributedString:attributedString];
}

@end
