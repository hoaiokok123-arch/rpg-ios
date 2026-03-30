#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EasyRPGCore : NSObject

+ (nullable UIViewController *)createViewControllerWithLaunchContext:(NSDictionary<NSString *, id> *)context;
+ (nullable UIViewController *)createViewControllerWithGamePath:(NSString *)path;
+ (void)sendInputWithButton:(NSString *)button pressed:(BOOL)pressed;
+ (void)shutdownEngine;

@end

NS_ASSUME_NONNULL_END
