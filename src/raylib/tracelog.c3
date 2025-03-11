
module pleroma::raylib;


<* Trace log level
  NOTE: Organized by priority level
 *>
enum TraceLogLevel : int {
  ALL,            // Display all logs (0)
  TRACE,          // Trace logging, intended for internal use only
  DEBUG,          // Debug logging, used for internal debugging, it should be disabled on release builds
  INFO,           // Info logging, used for program execution info
  WARNING,        // Warning logging, used on recoverable failures
  ERROR,          // Error logging, used on unrecoverable failures
  FATAL,          // Fatal logging, used to abort program: exit(EXIT_FAILURE)
  NONE            // Disable logging
}
