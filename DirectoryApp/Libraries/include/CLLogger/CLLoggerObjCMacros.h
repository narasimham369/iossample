//
//  CLLoggerObjCMacros.h
//  Codelynks Logger Framework
//
//  Created by Timmi on 3/18/15.
//  Copyright (c) 2015 Codelynks. All rights reserved.
//

/*
 * This file contains all the macro definitions required for 
 * logging Objective C-style message
 *
 */

#import "CLLogManager.h"
#import "CLLoggerConstants.h"

#pragma mark - Activity logging
//
// Standard application activity logging functions
//
#define CLLOG_CriticalError(source,fmt,...) \
CLLOG_logMessage(source, CLLOG_MSG_CRITICAL, CLLOG_LOG_TYPE_ACTIVITY, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#define CLLOG_Error(source,fmt,...) \
CLLOG_logMessage(source, CLLOG_MSG_ERROR, CLLOG_LOG_TYPE_ACTIVITY, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#define CLLOG_Warn(source,fmt,...) \
CLLOG_logMessage(source, CLLOG_MSG_WARNING, CLLOG_LOG_TYPE_ACTIVITY, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#define CLLOG_Info(source,fmt,...) \
CLLOG_logMessage(source, CLLOG_MSG_INFO, CLLOG_LOG_TYPE_ACTIVITY, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#define CLLOG_Detail(source,fmt,...) \
CLLOG_logMessage(source, CLLOG_MSG_DETAIL, CLLOG_LOG_TYPE_ACTIVITY, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#pragma mark - Diagnostic logging
//
// Diagnostic tracing functions
//   - requires CLLOG_DEFAULT_MODULE to be defined (trace module/component name) in compiler flags
//
#define CLLOG_Diag(level,fmt,...) \
CLLOG_logMessage(CLLOG_DEFAULT_MODULE, level, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

// Diagnostic tracing variants
#define CLLOG_Diag1(fmt,...) \
CLLOG_logMessage(CLLOG_DEFAULT_MODULE, CLLOG_LVL_DEBUG1, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag2(fmt,...) \
CLLOG_logMessage(CLLOG_DEFAULT_MODULE, CLLOG_LVL_DEBUG2, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag3(fmt,...) \
CLLOG_logMessage(CLLOG_DEFAULT_MODULE, CLLOG_LVL_DEBUG3, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag4(fmt,...) \
CLLOG_logMessage(CLLOG_DEFAULT_MODULE, CLLOG_LVL_DEBUG4, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag5(fmt,...) \
CLLOG_logMessage(CLLOG_DEFAULT_MODULE, CLLOG_LVL_DEBUG5, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag6(fmt,...) \
CLLOG_logMessage(CLLOG_DEFAULT_MODULE, CLLOG_LVL_DEBUG6, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag7(fmt,...) \
CLLOG_logMessage(CLLOG_DEFAULT_MODULE, CLLOG_LVL_DEBUG7, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag8(fmt,...) \
CLLOG_logMessage(CLLOG_DEFAULT_MODULE, CLLOG_LVL_DEBUG8, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag9(fmt,...) \
CLLOG_logMessage(CLLOG_DEFAULT_MODULE, CLLOG_LVL_DEBUG9, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag10(fmt,...) \
CLLOG_logMessage(CLLOG_DEFAULT_MODULE, CLLOG_LVL_DEBUG10, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);


//
// Diag log variant where trace module/component is defined explicitly inline
//
// NOTE: We should prefer to use variants above since it makes code less verbose and more portable
//
#define CLLOG_Diag_ForModule(module, level, fmt, ...) \
CLLOG_logMessage(module, level, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#pragma mark - Secure logging

#if defined(DEBUG) || defined(_DEBUG) || defined(ENABLE_CLLOG_Secure)

// Diagnostic logging of potentially sensitive info.  Same as CLLOG_Diag(),
// but only enabled if DEBUG, _DEBUG, or ENABLE_CLLOG_Secure is defined
#define CLLOG_Secure(level,fmt,...) \
CLLOG_logMessage(CLLOG_DEFAULT_MODULE, level, CLLOG_LOG_TYPE_SECURE, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

// Secure log variants where trace module/component is defined explicitly inline
#define CLLOG_Secure_ForModule(module, level, fmt,...) \
CLLOG_logMessage(module, level, CLLOG_LOG_TYPE_SECURE, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#else

#define CLLOG_Secure(level,fmt,...)
#define CLLOG_Secure_ForModule(module, level, fmt,...)

#endif

#pragma mark - Performance logging
//
// Performance event logging
//
// module   - Module name
// level    - Logging level

// name     - Event name
// type     - Event type (start, stop, timestamp)
// context  - Context or transaction ID (64 bit int/address)
// fmt, ... - Printf style message payload
//
#define CLLOG_PerfLogInit(level) \
CLPerfLoggerInitializeWithLevel(level)

#define CLLOG_PerfEvent(module,level,name,type,context) \
CLLOG_logPerfEvent(module, level, name, type, context, __FILE__, __FUNCTION__, __LINE__)

#define CLLOG_PerfEventWithMsg(module, level, name, type, context, fmt, ...) \
CLLOG_logPerfEventWithMsg(module, level, name, type, context, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__)
