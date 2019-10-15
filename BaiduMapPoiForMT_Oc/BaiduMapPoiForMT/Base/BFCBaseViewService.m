//
//  BFCBaseViewService.m
//  BFCompetition
//
//  Created by hzhy001 on 2019/9/16.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "BFCBaseViewService.h"

@implementation BFCBaseViewService

+ (instancetype)initWithViewModel:(NSObject *)viewModel{
    
    return [[self alloc] initWithViewModel:viewModel];
}

- (instancetype)initWithViewModel:(NSObject *)viewModel{
    
    if (self = [super init]) {
        self.backgroundColor = UIColor.whiteColor;
        
    }
    return self;
}

@end
