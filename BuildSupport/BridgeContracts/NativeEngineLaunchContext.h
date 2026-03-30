#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *RPGPlayerNativeLaunchContextKey NS_STRING_ENUM;

static RPGPlayerNativeLaunchContextKey const RPGPlayerNativeLaunchContextGameIDKey = @"gameId";
static RPGPlayerNativeLaunchContextKey const RPGPlayerNativeLaunchContextGameNameKey = @"gameName";
static RPGPlayerNativeLaunchContextKey const RPGPlayerNativeLaunchContextGameTypeKey = @"gameType";
static RPGPlayerNativeLaunchContextKey const RPGPlayerNativeLaunchContextGamePathKey = @"gamePath";
static RPGPlayerNativeLaunchContextKey const RPGPlayerNativeLaunchContextEngineIdentifierKey = @"engineIdentifier";
static RPGPlayerNativeLaunchContextKey const RPGPlayerNativeLaunchContextRuntimePathKey = @"runtimePath";
static RPGPlayerNativeLaunchContextKey const RPGPlayerNativeLaunchContextSavesPathKey = @"savesPath";
static RPGPlayerNativeLaunchContextKey const RPGPlayerNativeLaunchContextCachePathKey = @"cachePath";

NS_ASSUME_NONNULL_END
