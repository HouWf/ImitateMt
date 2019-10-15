//
//  NSObject+Extension.m
//  BFPlus
//
//  Created by hzhy001 on 2018/12/18.
//  Copyright © 2018 hzhy001. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

-(BOOL)canRunToSelector:(SEL)aSelector{
    unsigned int methodCount =0;
    Method  *methodList = class_copyMethodList([self class],&methodCount);
    NSString *selectorStr = NSStringFromSelector(aSelector);
    
    BOOL result = NO;
    for (int i = 0; i < methodCount; i++) {
        Method temp = methodList[i];
        const char* selectorName =sel_getName(method_getName(temp));
        NSString *tempSelectorString = [NSString stringWithUTF8String:selectorName];
//        NSLog(@"%@",tempSelectorString);
        if ([tempSelectorString isEqualToString:selectorStr]) {
            result = YES;
            break;
        }
    }
    free(methodList);
    return result;
}

- (id)runSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    NSUInteger i = 1;
    
    if (objects.count) {
        for (id object in objects) {
            id tempObject = object;
            [invocation setArgument:&tempObject atIndex:++i];
        }
    }
    [invocation invoke];
    
    if (methodSignature.methodReturnLength) {
        id value;
        [invocation getReturnValue:&value];
        return value;
    }
    return nil;
}
@end
