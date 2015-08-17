//
//  MyNetService.h
//  Service Advertiser
//
//  Created by Sven on 14.12.08.
//  Copyright 2008-2015 Sven-S. Porst.
//

#import <Cocoa/Cocoa.h>


@interface MyNetService : NSObject {
	NSNetService * netService;
	NSString * name;
	NSString * URLString;
	BOOL canActivate;
	NSInteger publishedState;
}

@property (strong) NSNetService * netService;
@property (strong) NSString * name;
@property (strong) NSString * URLString;
@property BOOL canActivate;
@property NSInteger publishedState;

@end
