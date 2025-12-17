import 'package:flutter/material.dart';

sealed class ProcessStatus {
  String message;
  ProcessStatus({this.message = ""});
}

class EnabledStatus extends ProcessStatus {
  EnabledStatus({String? message })
      : super(message: message ?? "Enabled");
}

class DisabledStatus extends ProcessStatus {
  DisabledStatus({String? message })
      : super(message: message ?? "Disabled");
}

class LoadingStatus extends ProcessStatus {
  LoadingStatus({String? message })
      : super(message: message ?? "Loading");
}

class ErrorStatus extends ProcessStatus {
  ErrorStatus({String? message })
      : super(message: message ?? "Error");
}

class SuccessStatus extends ProcessStatus {
  SuccessStatus({String? message })
      : super(message: message ?? "Success");
}

/// An observable ChangeNotifier that manages the status of a process, such as loading, success, error, enabled, and disabled.
///
/// Usage:
/// ```dart
/// // Create an instance of ProcessStatusNotifier
/// final processNotifier = ProcessStatusNotifier();
///
/// // Set the status to loading
/// processNotifier.setLoading(message: "Loading data...");
/// // Set the status to success
/// processNotifier.setSuccess(message: "Data loaded successfully!");
/// // Set the status to error
/// processNotifier.setError(message: "Failed to load data.");
/// // Set the status to enabled
/// processNotifier.setEnabled(message: "Ready to proceed.");
/// // Set the status to disabled
/// processNotifier.setDisabled(message: "Action not available.");
/// ```
/// 
/// This class is build to be used with widgets that need to reflect process states visually.
/// Normally, buttons that trigger async operations has to reflect the 
/// ### idle/disabled, enabled, loading, success, error states.
/// 
/// Widgets like [RProcessNotifierButton] and [RIcon] both utilize this notifier to reflect process states visually.
class ProcessStatusNotifier extends ChangeNotifier{

  /// By default the button status is set to DisabledStatus.
  /// If you want to set the initial button status to a different status, pass it in the constructor
  ProcessStatusNotifier({ProcessStatus? initialStatus}) {
    _status = initialStatus ?? DisabledStatus();
  }
  ProcessStatus _status = DisabledStatus();
  ProcessStatus get status => _status;

  void setLoading({String? message}) {
    _status = LoadingStatus(message: message);
    notifyListeners();
  }
  setSuccess({String? message}) {
    _status = SuccessStatus(message: message);
    notifyListeners();
  }
  setError({String? message}) {
    _status = ErrorStatus(message: message);
    notifyListeners();
  }
  setEnabled({String? message}) {
    if(_status is EnabledStatus) return;
    _status = EnabledStatus(message: message);
    notifyListeners();
  }
  setDisabled({String? message}) {
    _status = DisabledStatus(message: message);
    notifyListeners();
  }

  void reset(String? message) {
    _status = EnabledStatus(message: message);
    notifyListeners();
  }
}