//
//  NSAttributedString+CCLFormat.h
//  Cocode
//
//  Created by Kyle Fuller on 06/11/2012.
//  Copyright (c) 2012-2014 Cocode. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Attributed string extension for creating attributed strings from a format string. */
@interface NSAttributedString (CCLFormat)

/** Returns an attributed string created by using a given format string as a template into which the remaining argument values are substituted.
 @param format A format string. This value must not be nil.
 @param ... A comma-separated list of arguments to substitute into format.
 @return An attributed string created by using format as a template into which the remaining argument values are substituted.
 */
+ (instancetype)attributedStringWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

/** Returns an attributed string created by using a given format string as a template into which the remaining argument values are substituted.
 @param format A format string. This value must not be nil.
 @param args list of arguments to substitute into format.
 @return An attributed string created by using format as a template into which the remaining argument values are substituted.
 */
+ (instancetype)attributedStringWithFormat:(NSString *)format arguments:(va_list)args NS_FORMAT_FUNCTION(1,0);

@end
