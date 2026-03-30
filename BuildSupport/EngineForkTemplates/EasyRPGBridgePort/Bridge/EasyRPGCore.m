#import "EasyRPGCore.h"
#import "NativeEngineLaunchContext.h"

@interface EasyRPGCorePlaceholderViewController : UIViewController

@property (nonatomic, copy) NSString *message;

@end

@implementation EasyRPGCorePlaceholderViewController

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

static NSString *EasyRPGValueOrFallback(NSDictionary<NSString *, id> *context, NSString *key) {
    NSString *value = context[key];
    return value.length > 0 ? value : @"<missing>";
}

@implementation EasyRPGCore

+ (nullable UIViewController *)createViewControllerWithLaunchContext:(NSDictionary<NSString *, id> *)context {
    EasyRPGCorePlaceholderViewController *controller = [[EasyRPGCorePlaceholderViewController alloc] init];
    controller.message = [NSString stringWithFormat:
        @"EasyRPGCore stub dang chay.\n\nGame path:\n%@\n\nSave path:\n%@\n\nCache path:\n%@\n\nThay file EasyRPGCore.* bang engine port that.",
        EasyRPGValueOrFallback(context, RPGPlayerNativeLaunchContextGamePathKey),
        EasyRPGValueOrFallback(context, RPGPlayerNativeLaunchContextSavesPathKey),
        EasyRPGValueOrFallback(context, RPGPlayerNativeLaunchContextCachePathKey)
    ];
    return controller;
}

+ (nullable UIViewController *)createViewControllerWithGamePath:(NSString *)path {
    return [self createViewControllerWithLaunchContext:@{
        RPGPlayerNativeLaunchContextGamePathKey: path,
        RPGPlayerNativeLaunchContextEngineIdentifierKey: @"easyrpg"
    }];
}

+ (void)sendInputWithButton:(NSString *)button pressed:(BOOL)pressed {
    (void)button;
    (void)pressed;
}

+ (void)shutdownEngine {
}

@end
