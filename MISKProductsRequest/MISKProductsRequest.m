//
//  MISKProductsRequest.m
//  MISKProductsRequest
//
//  Created by Masaru Ichikawa on 2012/08/26.
//  Copyright (c) 2012年 Masaru Ichikawa. All rights reserved.
//

#import "MISKProductsRequest.h"

@interface MISKProductsRequest()

@property (nonatomic, retain) SKProductsRequest *request;

@end

@implementation MISKProductsRequest

@synthesize completionHandler = _completionHandler;
@synthesize request = _request;

+ (id)requestWihtProductIdentifiers:(NSSet *)productIdentifiers {
    return [[[self alloc] initWithProductIdentifiers:productIdentifiers] autorelease];
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    self = [super init];
    if (self) {
        self.request = [[[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers] autorelease];
        self.request.delegate = self;
    }
    return self;
}

- (void)dealloc {
    self.request = nil;
    [super dealloc];
}

- (void)startWithCompletionHandler:(MISKProductsRequestCompletionHandler)completionHandler {
    self.completionHandler = completionHandler;
    [self retain];
    [self.request start];
    
}

- (void)cancel {
    [self.request cancel];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    self.completionHandler(request, response, nil);
    [self autorelease];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    self.completionHandler((SKProductsRequest*)request, nil, error);
    [self autorelease];
}

@end
