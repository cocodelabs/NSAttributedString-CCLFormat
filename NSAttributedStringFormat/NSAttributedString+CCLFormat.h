@import Foundation;

/** Attributed string extension for creating attributed strings from a format string. */
@interface NSAttributedString (CCLFormat)

/** Returns an attributed string created by using a given format string as a template into which the remaining argument values are substituted.
 @param format A format string. This value must not be nil.
 @param ... A comma-separated list of arguments to substitute into format.
 @return An attributed string created by using format as a template into which the remaining argument values are substituted.
 */
+ (instancetype)attributedStringWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

/** Returns an attributed string created by using a given format string as a template into which the remaining argument values are substituted.
 @param attributes A dictionary of attributes for the format string. May be nil.
 @param format A format string. This value must not be nil.
 @param arguments list of arguments to substitute into format.
 @return An attributed string created by using format as a template into which the remaining argument values are substituted.
 */
+ (instancetype)attributedStringWithAttributes:(NSDictionary *)attributes format:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);

/** Returns an attributed string created by using a given format string as a template into which the remaining argument values are substituted.
 @param format A format string. This value must not be nil.
 @param arguments list of arguments to substitute into format.
 @return An attributed string created by using format as a template into which the remaining argument values are substituted.
 */
+ (instancetype)attributedStringWithFormat:(NSString *)format arguments:(va_list)arguments NS_FORMAT_FUNCTION(1,0);

/** Returns an attributed string created by using a given format string as a template into which the remaining argument values are substituted.
 @param attributes A dictionary of attributes for the format string. May be nil.
 @param format A format string. This value must not be nil.
 @param arguments list of arguments to substitute into format.
 @return An attributed string created by using format as a template into which the remaining argument values are substituted.
 */
+ (instancetype)attributedStringWithAttributes:(NSDictionary *)attributes format:(NSString *)format arguments:(va_list)arguments NS_FORMAT_FUNCTION(2,0);

/** Returns an attributed string created by using a given format string as a template into which the remaining argument values are substituted.
 @param format A format string. This value must not be nil.
 @param ... A comma-separated list of arguments to substitute into format.
 @return An attributed string created by using format as a template into which the remaining argument values are substituted.
 */
- (instancetype)initWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

/** Returns an attributed string created by using a given format string as a template into which the remaining argument values are substituted.
 @param attributes A dictionary of attributes for the format string. May be nil.
 @param format A format string. This value must not be nil.
 @param ... A comma-separated list of arguments to substitute into format.
 @return An attributed string created by using format as a template into which the remaining argument values are substituted.
 */
- (instancetype)initWithAttributes:(NSDictionary *)attributes format:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);

/** Returns an attributed string created by using a given format string as a template into which the remaining argument values are substituted.
 @param format A format string. This value must not be nil.
 @param arguments list of arguments to substitute into format.
 @return An attributed string created by using format as a template into which the remaining argument values are substituted.
 */
- (instancetype)initWithFormat:(NSString *)format arguments:(va_list)arguments NS_FORMAT_FUNCTION(1,0);

/** Returns an attributed string created by using a given format string as a template into which the remaining argument values are substituted.
 @param attributes A dictionary of attributes for the format string. May be nil.
 @param format A format string. This value must not be nil.
 @param arguments list of arguments to substitute into format.
 @return An attributed string created by using format as a template into which the remaining argument values are substituted.
 */
- (instancetype)initWithAttributes:(NSDictionary *)attributes format:(NSString *)format arguments:(va_list)arguments NS_FORMAT_FUNCTION(2,0);


@end
