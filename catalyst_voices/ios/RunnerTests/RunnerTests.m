//
//  RunnerTests.m
//  RunnerTests
//
//  Created by minikin on 2023-10-31.
//

@import XCTest;
@import integration_test;

#pragma mark - Dynamic tests

INTEGRATION_TEST_IOS_RUNNER(RunnerTests)

@interface RunnerTests (DynamicTests)
@end

@implementation RunnerTests (DynamicTests)

- (void)setUp {
}

@end
