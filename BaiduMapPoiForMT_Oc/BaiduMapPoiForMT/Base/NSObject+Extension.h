//
//  NSObject+Extension.h
//  BFPlus
//
//  Created by hzhy001 on 2018/12/18.
//  Copyright © 2018 hzhy001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Extension)

-(BOOL)canRunToSelector:(SEL)aSelector;

- (id)runSelector:(SEL)aSelector withObjects:(NSArray *)objects;

@end

NS_ASSUME_NONNULL_END
