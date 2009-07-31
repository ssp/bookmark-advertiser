//
//  NSString+Truncation.m
//  Service Advertiser
//
//  Created by  Sven on 31.07.09.
//  Copyright 2009 earthlingsoft. All rights reserved.
//

#import "NSString+Truncation.h"


@implementation NSString (Truncation)


- (NSUInteger) UTF8DataLength {
  NSUInteger result = 0;
  NSData * UTF8Data = [self dataUsingEncoding:NSUTF8StringEncoding];
  if ( UTF8Data != nil ) {
    result = [UTF8Data length];
  }
  
  return result;
}


- (NSString*) truncateToUTF8Length: (NSUInteger) maxLength {
  NSMutableString * s = [NSMutableString stringWithString:[self substringToIndex:MIN([self length], maxLength)]];
  NSInteger dataLength = [s UTF8DataLength];

  while ( dataLength > maxLength ) {
    /* 1 UTF-8 char can be 4 bytes, so delete 1 char for each 4 bytes over the maximum length */
    NSInteger charsToDelete = ceil((dataLength - maxLength) / 4);
    NSRange deleteRange = NSMakeRange([s length] - charsToDelete, charsToDelete);
    [s deleteCharactersInRange:deleteRange];
    dataLength = [s UTF8DataLength];
  }
  
  return s;  
}


- (NSString*) truncateWithEllipsisToUTF8Length: (NSUInteger) maxLength {
  NSString * result;
  
  if ([self UTF8DataLength] <= maxLength) {
    result = self;
  }
  else {
    // Ellipsis is 3 UTF-8 bytes
    NSString * s = [self truncateToUTF8Length:maxLength - 3];
    s = [s stringByAppendingString:@"…"];
    result = s;
  }
  
  return result;
}


@end
