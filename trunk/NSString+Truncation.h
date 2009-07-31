//
//  NSString+Truncation.h
//  Service Advertiser
//
//  Created by Sven on 31.07.09.
//  Copyright 2009 Sven-S. Porst.
//

/*
 
 Methods for truncating an NSString such that the result fits in a given number of UTF-8 bytes.
 
*/


#import <Foundation/Foundation.h>

@interface NSString (Truncation) 

- (NSUInteger) UTF8DataLength;
- (NSString*) truncateToUTF8Length: (NSUInteger) maxLength;
- (NSString*) truncateWithEllipsisToUTF8Length: (NSUInteger) maxLength;

@end

