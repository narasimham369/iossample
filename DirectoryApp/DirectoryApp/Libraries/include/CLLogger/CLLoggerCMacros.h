//
//  CLLoggerCMacros.h
//  Codelynks Logger Framework
//
//  Created by Timmi on 3/18/15.
//  Copyright (c) 2015 Codelynks. All rights reserved.
//

/*
 * This file contains all the macro definitions required 
 * for logging C-style message
 *
 */

#import "CLLoggerConstants.h"
#import "CLLogManager.h"

#pragma mark - Activity logging (C variants)
//
// Standard application activity logging functions - C variants
//
#define CLLOG_CriticalError_C(source,fmt,...) \
CLLOG_logMessage_C(source, CLLOG_MSG_CRITICAL, CLLOG_LOG_TYPE_ACTIVITY, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#define CLLOG_Error_C(source,fmt,...) \
CLLOG_logMessage_C(source, CLLOG_MSG_ERROR, CLLOG_LOG_TYPE_ACTIVITY, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#define CLLOG_Warn_C(source,fmt,...) \
CLLOG_logMessage_C(source, CLLOG_MSG_WARNING, CLLOG_LOG_TYPE_ACTIVITY, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#define CLLOG_Info_C(source,fmt,...) \
CLLOG_logMessage_C(source, CLLOG_MSG_INFO, CLLOG_LOG_TYPE_ACTIVITY, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#define CLLOG_Detail_C(source,fmt,...) \
CLLOG_logMessage_C(source, CLLOG_MSG_DETAIL, CLLOG_LOG_TYPE_ACTIVITY, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#pragma mark - Diagnostic logging

//
// Diagnostic tracing functions - C variants
//   - requires CLLOG_DEFAULT_MODULE_C to be defined (trace module/component name)
//
#define CLLOG_Diag_C(level,fmt,...) \
CLLOG_logMessage_C(CLLOG_DEFAULT_MODULE_C, level, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

//Variants
#define CLLOG_Diag1_C(fmt,...) \
CLLOG_logMessage_C(CLLOG_DEFAULT_MODULE_C, CLLOG_LVL_DEBUG1, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag2_C(fmt,...) \
CLLOG_logMessage_C(CLLOG_DEFAULT_MODULE_C, CLLOG_LVL_DEBUG2, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag3_C(fmt,...) \
CLLOG_logMessage_C(CLLOG_DEFAULT_MODULE_C, CLLOG_LVL_DEBUG3, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag4_C(fmt,...) \
CLLOG_logMessage_C(CLLOG_DEFAULT_MODULE_C, CLLOG_LVL_DEBUG4, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag5_C(fmt,...) \
CLLOG_logMessage_C(CLLOG_DEFAULT_MODULE_C, CLLOG_LVL_DEBUG5, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag6_C(fmt,...) \
CLLOG_logMessage_C(CLLOG_DEFAULT_MODULE_C, CLLOG_LVL_DEBUG6, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag7_C(fmt,...) \
CLLOG_logMessage_C(CLLOG_DEFAULT_MODULE_C, CLLOG_LVL_DEBUG7, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag8_C(fmt,...) \
CLLOG_logMessage_C(CLLOG_DEFAULT_MODULE_C, CLLOG_LVL_DEBUG8, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag9_C(fmt,...) \
CLLOG_logMessage_C(CLLOG_DEFAULT_MODULE_C, CLLOG_LVL_DEBUG9, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#define CLLOG_Diag10_C(fmt,...) \
CLLOG_logMessage_C(CLLOG_DEFAULT_MODULE_C, CLLOG_LVL_DEBUG10, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

// Diag log variants where trace module/component is defined explicitly inline - C variants
#define CLLOG_Diag_ForModule_C(module,level,fmt,...) \
CLLOG_logMessage_C(module, level, CLLOG_LOG_TYPE_DIAGNOSTIC, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#pragma mark - Secure logging

#if defined(DEBUG) || defined(_DEBUG) || defined(ENABLE_CLLOG_Secure)

//
// Diagnostic logging of potentially sensitive info.  Same as CLLOG_Diag(),
// but only enabled if DEBUG, _DEBUG, or ENABLE_CLLOG_Secure is defined.
// C variants
//
#define CLLOG_Secure_C(level,fmt,...) \
CLLOG_logMessage_C(CLLOG_DEFAULT_MODULE_C, level, CLLOG_LOG_TYPE_SECURE, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

//
// Secure log variants where trace module/component is defined explicitly inline.
// C variants
//
#define CLLOG_Secure_ForModule_C(module,level,fmt,...) \
CLLOG_logMessage_C(module, level, CLLOG_LOG_TYPE_SECURE, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#else

#define CLLOG_Secure_C(level,fmt,...)
#define CLLOG_Secure_ForModule_C(module,level,fmt,...)

#endif

#pragma mark - Performance logging (C variants)
//
// Performance event logging - C variants
//
// module   - Module name
// level    - Logging level

// name     - Event name
// type     - Event type (start, stop, timestamp)
// context  - Context or transaction ID (64 bit int/address)
// fmt, ... - Printf style message payload
//
#define CLLOG_PerfEvent_C(module,level,name,type,context) \
CLLOG_logPerfEvent_C(module, level, name, type, context, __FILE__, __FUNCTION__, __LINE__)

#define CLLOG_PerfEventWithMsg_C(module,level,name,type,context,fmt,...) \
CLLOG_logPerfEventWithMsg_C(module, level, name, type, context, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__)
