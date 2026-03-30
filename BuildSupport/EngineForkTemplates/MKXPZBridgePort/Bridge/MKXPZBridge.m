#import "MKXPZBridge.h"

@protocol MKXPZCoreRuntime <NSObject>

@optional
+ (nullable UIViewController *)createViewControllerWithLaunchContext:(NSDictionary<NSString *, id> *)context;

@required
+ (nullable UIViewController *)createViewControllerWithGamePath:(NSString *)path;
+ (void)sendInputWithButton:(NSString *)button pressed:(BOOL)pressed;
+ (void)shutdownEngine;

@end

static Class<MKXPZCoreRuntime> MKXPZCoreClass(void) {
    NSArray<NSString *> *candidates = @[
        @"MKXPZCore",
        @"MKXPZBridge.MKXPZCore"
    ];

    for (NSString *candidate in candidates) {
        Class cls = NSClassFromString(candidate);
        if (cls != Nil) {
            return (Class<MKXPZCoreRuntime>)cls;
        }
    }

    return Nil;
}

static NSDictionary<NSString *, id> *MKXPZLaunchContextFromGamePath(NSString *path) {
    return @{
        RPGPlayerNativeLaunchContextGamePathKey: path,
        RPGPlayerNativeLaunchContextEngineIdentifierKey: @"mkxpz"
    };
}

static UIViewController * _Nullable MKXPZCreateViewController(Class<MKXPZCoreRuntime> cls, NSDictionary<NSString *, id> *context) {
    if ([cls respondsToSelector:@selector(createViewControllerWithLaunchContext:)]) {
        return [cls createViewControllerWithLaunchContext:context];
    }

    NSString *path = context[RPGPlayerNativeLaunchContextGamePathKey];
    if (path.length > 0) {
        return [cls createViewControllerWithGamePath:path];
    }

    return nil;
}

@interface MKXPZPlaceholderViewController : UIViewController

@property (nonatomic, copy) NSString *message;

@end

@implementation MKXPZPlaceholderViewController

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

@implementation MKXPZBridge

+ (nullable UIViewController *)createViewControllerWithLaunchContext:(NSDictionary<NSString *, id> *)context {
    Class<MKXPZCoreRuntime> cls = MKXPZCoreClass();
    if (cls != Nil) {
        return MKXPZCreateViewController(cls, context);
    }

    MKXPZPlaceholderViewController *controller = [[MKXPZPlaceholderViewController alloc] init];
    controller.message = @"MKXPZCore chua duoc noi vao framework. Hay hoan tat port native trong repo MKXPZBridge.";
    return controller;
}

+ (nullable UIViewController *)createViewControllerWithGamePath:(NSString *)path {
    return [self createViewControllerWithLaunchContext:MKXPZLaunchContextFromGamePath(path)];
}

+ (void)sendInputWithButton:(NSString *)button pressed:(BOOL)pressed {
    Class<MKXPZCoreRuntime> cls = MKXPZCoreClass();
    if (cls != Nil) {
        [cls sendInputWithButton:button pressed:pressed];
    }
}

+ (void)shutdownEngine {
    Class<MKXPZCoreRuntime> cls = MKXPZCoreClass();
    if (cls != Nil) {
        [cls shutdownEngine];
    }
}

@end
