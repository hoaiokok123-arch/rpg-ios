#import "MKXPZCore.h"
#import "NativeEngineLaunchContext.h"

@interface MKXPZCorePlaceholderViewController : UIViewController

@property (nonatomic, copy) NSString *message;

@end

@implementation MKXPZCorePlaceholderViewController

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

static NSString *MKXPZValueOrFallback(NSDictionary<NSString *, id> *context, NSString *key) {
    NSString *value = context[key];
    return value.length > 0 ? value : @"<missing>";
}

@implementation MKXPZCore

+ (nullable UIViewController *)createViewControllerWithLaunchContext:(NSDictionary<NSString *, id> *)context {
    MKXPZCorePlaceholderViewController *controller = [[MKXPZCorePlaceholderViewController alloc] init];
    controller.message = [NSString stringWithFormat:
        @"MKXPZCore stub dang chay.\n\nGame path:\n%@\n\nSave path:\n%@\n\nCache path:\n%@\n\nThay file MKXPZCore.* bang engine port that.",
        MKXPZValueOrFallback(context, RPGPlayerNativeLaunchContextGamePathKey),
        MKXPZValueOrFallback(context, RPGPlayerNativeLaunchContextSavesPathKey),
        MKXPZValueOrFallback(context, RPGPlayerNativeLaunchContextCachePathKey)
    ];
    return controller;
}

+ (nullable UIViewController *)createViewControllerWithGamePath:(NSString *)path {
    return [self createViewControllerWithLaunchContext:@{
        RPGPlayerNativeLaunchContextGamePathKey: path,
        RPGPlayerNativeLaunchContextEngineIdentifierKey: @"mkxpz"
    }];
}

+ (void)sendInputWithButton:(NSString *)button pressed:(BOOL)pressed {
    (void)button;
    (void)pressed;
}

+ (void)shutdownEngine {
}

@end
