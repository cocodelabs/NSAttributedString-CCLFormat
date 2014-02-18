//
//  NSAttributedString+CCLFormatTests.m
//  Cocode
//
//  Created by Kyle Fuller on 06/11/2012.
//  Copyright (c) 2012-2014 Cocode. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AppKit/AppKit.h>
#import <NSAttributedString+CCLFormat.h>


@interface NSAttributedStringTests : XCTestCase

@end

@implementation NSAttributedStringTests

- (void)testAttributedFormatStringCanFormatAttributedString {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Hi" attributes:@{
        NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
    }];

    NSAttributedString *formattedAttributedString = [NSAttributedString attributedStringWithFormat:@"%@", attributedString];

    XCTAssertEqualObjects(formattedAttributedString, attributedString);
}

- (void)testAttributedFormatStringCanFormatString {
    NSAttributedString *attributedString = [NSAttributedString attributedStringWithFormat:@"%@", @"Hello World"];
    XCTAssertEqualObjects([attributedString string], @"Hello World");
}

- (void)testAttributedFormatStringCanFormatDescription {
    NSAttributedString *attributedString = [NSAttributedString attributedStringWithFormat:@"%@", @1337];
    XCTAssertEqualObjects([attributedString string], @"1337");
}

- (void)testAttributedFormatString {
    // Format Attributed String
    NSAttributedString *blue = [[NSAttributedString alloc] initWithString:@"Blue" attributes:@{
        NSFontAttributeName: [NSFont boldSystemFontOfSize:16.0f],
        NSForegroundColorAttributeName: [NSColor blueColor],
    }];

    NSAttributedString *green = [[NSAttributedString alloc] initWithString:@"Green" attributes:@{
        NSFontAttributeName: [NSFont boldSystemFontOfSize:16.0f],
        NSForegroundColorAttributeName: [NSColor greenColor],
    }];

    NSAttributedString *never = [[NSAttributedString alloc] initWithString:@"never" attributes:@{
        NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
    }];

    NSAttributedString *attributedString = [NSAttributedString attributedStringWithFormat:@"%@ and %@ must %@ be %@", blue, green, never, @"seen"];

    // Fixture
    NSMutableAttributedString *fixtureAttributedString = [[NSMutableAttributedString alloc] initWithString:@"Blue and Green must never be seen"];
    NSRange blueRange = [[fixtureAttributedString string] rangeOfString:@"Blue"];
    NSRange greenRange = [[fixtureAttributedString string] rangeOfString:@"Green"];
    NSRange neverRange = [[fixtureAttributedString string] rangeOfString:@"never"];
    
    [fixtureAttributedString setAttributes:@{
        NSFontAttributeName: [NSFont boldSystemFontOfSize:16.0f],
        NSForegroundColorAttributeName: [NSColor blueColor],
    } range:blueRange];

    [fixtureAttributedString setAttributes:@{
        NSFontAttributeName: [NSFont boldSystemFontOfSize:16.0f],
        NSForegroundColorAttributeName: [NSColor greenColor],
    } range:greenRange];

    [fixtureAttributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:neverRange];
    
    XCTAssertEqualObjects(attributedString, fixtureAttributedString, "");
}

@end

