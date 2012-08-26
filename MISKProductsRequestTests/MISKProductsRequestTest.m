//
//  MISKProductsRequest - MISKProductsRequestTest.m
//  Copyright 2012年 Masaru Ichikawa. All rights reserved.
//
//  Created by: Masaru Ichikawa
//

#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>
#import "MISKProductsRequest.h"

@interface MISKProductsRequest(Privates)
@property (nonatomic, retain) SKProductsRequest *request;
@end

@interface MISKProductsRequestTest : GHAsyncTestCase
{
}
@end

@implementation MISKProductsRequestTest

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
    return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    // Run before each test method

}

- (void)tearDown {
    // Run after each test method
}

- (void)testStartSuccess {
    id mock = [OCMockObject niceMockForClass:[SKProductsRequest class]];
    MISKProductsRequest* request = [MISKProductsRequest requestWihtProductIdentifiers:[NSSet set]];
    request.request = mock;
    
    SKProductsRequest *mock2 = [[mock stub] andDo:^(NSInvocation *block) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [request productsRequest:mock didReceiveResponse:nil];
        });
    }];
    [mock2 start];
    
    [self prepare];
    __block BOOL called = NO;
    [request startWithCompletionHandler:^(SKProductsRequest *request, SKProductsResponse *response, NSError *error) {
        called = YES;
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:2.0];
    GHAssertTrue(called, @"must called");
}

- (void)testStartFail {
    id mock = [OCMockObject niceMockForClass:[SKProductsRequest class]];
    MISKProductsRequest* request = [MISKProductsRequest requestWihtProductIdentifiers:[NSSet set]];
    request.request = mock;
    
    SKProductsRequest *mock2 = [[mock stub] andDo:^(NSInvocation *block) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [request request:mock didFailWithError:nil];
        });
    }];
    [mock2 start];
    
    [self prepare];
    __block BOOL called = NO;
    [request startWithCompletionHandler:^(SKProductsRequest *request, SKProductsResponse *response, NSError *error) {
        called = YES;
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:2.0];
    GHAssertTrue(called, @"must called");
}

@end
