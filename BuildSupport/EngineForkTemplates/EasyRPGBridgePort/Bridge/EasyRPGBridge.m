#import "EasyRPGBridge.h"

@protocol EasyRPGCoreRuntime <NSObject>

@optional
+ (nullable UIViewController *)createViewControllerWithLaunchContext:(NSDictionary<NSString *, id> *)context;

@required
+ (nullable UIViewController *)createViewControllerWithGamePath:(NSString *)path;
+ (void)sendInputWithButton:(NSString *)button pressed:(BOOL)pressed;
+ (void)shutdownEngine;

@end

static Class<EasyRPGCoreRuntime> EasyRPGCoreClass(void) {
    NSArray<NSString *> *candidates = @[
        @"EasyRPGCore",
        @"EasyRPGBridge.EasyRPGCore"
    ];

    for (NSString *candidate in candidates) {
        Class cls = NSClassFromString(candidate);
        if (cls != Nil) {
            return (Class<EasyRPGCoreRuntime>)cls;
        }
    }

    return Nil;
}

static NSDictionary<NSString *, id> *EasyRPGLaunchContextFromGamePath(NSString *path) {
    return @{
        RPGPlayerNativeLaunchContextGamePathKey: path,
        RPGPlayerNativeLaunchContextEngineIdentifierKey: @"easyrpg"
    };
}

static UIViewController * _Nullable EasyRPGCreateViewController(Class<EasyRPGCoreRuntime> cls, NSDictionary<NSString *, id> *context) {
    if ([cls respondsToSelector:@selector(createViewControllerWithLaunchContext:)]) {
        return [cls createViewControllerWithLaunchContext:context];
    }

    NSString *path = context[RPGPlayerNativeLaunchContextGamePathKey];
    if (path.length > 0) {
        return [cls createViewControllerWithGamePath:path];
    }

    return nil;
}

@interface EasyRPGPlaceholderViewController : UIViewController

@property (nonatomic, copy) NSString *message;

@end

@implementation EasyRPGPlaceholderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.blackColor;

    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.whiteColor;
    label.text = self.message;

    [self.view addSubview:label];

    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [label.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:24.0],
        [label.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.trailingAnchor constant:-24.0]
    ]];
}

@end

@implementation EasyRPGBridge

+ (nullable UIViewController *)createViewControllerWithLaunchContext:(NSDictionary<NSString *, id> *)context {
    Class<EasyRPGCoreRuntime> cls = EasyRPGCoreClass();
    if (cls != Nil) {
        return EasyRPGCreateViewController(cls, context);
    }

    EasyRPGPlaceholderViewController *controller = [[EasyRPGPlaceholderViewController alloc] init];
    controller.message = @"EasyRPGCore chua duoc noi vao framework. Hay hoan tat port native trong repo EasyRPGBridge.";
    return controller;
}

+ (nullable UIViewController *)createViewControllerWithGamePath:(NSString *)path {
    return [self createViewControllerWithLaunchContext:EasyRPGLaunchContextFromGamePath(path)];
}

+ (void)sendInputWithButton:(NSString *)button pressed:(BOOL)pressed {
    Class<EasyRPGCoreRuntime> cls = EasyRPGCoreClass();
    if (cls != Nil) {
        [cls sendInputWithButton:button pressed:pressed];
    }
}

+ (void)shutdownEngine {
    Class<EasyRPGCoreRuntime> cls = EasyRPGCoreClass();
    if (cls != Nil) {
        [cls shutdownEngine];
    }
}

@end
