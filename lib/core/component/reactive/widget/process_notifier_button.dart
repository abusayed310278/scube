
import 'package:flutter/material.dart';
import '../../../common/widget/debouncer_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../process_notifier.dart';
import '../../../services/debug/debug_service.dart';

class RProcessNotifierButton extends StatefulWidget {

  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final TextStyle? style;
  final ProcessStatusNotifier? buttonStatusNotifier;
  /// This text is displayed when the button is in either enabled or disabled state.
  /// 
  /// By default, it is set to "Save".
  final String generalText;
  /// This text is displayed when the button is in loading state.
  /// 
  /// By default, it is set to "Saving".
  final String loadingText;
  /// This text is displayed when the button is in error state.
  /// 
  /// By default, it is set to "Error".
  final String errorText;
  /// This text is displayed when the button is in done state.
  /// 
  /// By default, it is set to "Done".
  final String doneText;
  final Function(ProcessStatusNotifier processNotifier) onSave;
  final VoidCallback onDone;
  const RProcessNotifierButton({
    required super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.style,
    this.generalText = "Save",
    this.loadingText = "Saving",
    this.errorText = "Error",
    this.doneText = "Done",
    this.buttonStatusNotifier,
    required this.onSave,
    required this.onDone,
  });

  @override
  State<RProcessNotifierButton> createState() => _RProcessNotifierButtonState();
}

class _RProcessNotifierButtonState extends State<RProcessNotifierButton> {
  Debugger debugger = UIDebugger();
  late ProcessStatusNotifier buttonStatusNotifier;

  @override
  void didChangeDependencies() {
    buttonStatusNotifier.addListener(_update);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    buttonStatusNotifier = widget.buttonStatusNotifier ?? ProcessStatusNotifier();
    super.initState();
  }

  @override
  dispose(){
    buttonStatusNotifier.removeListener(_update);
    if(widget.buttonStatusNotifier == null) buttonStatusNotifier.dispose();
    super.dispose();
  }

  _update() {
    debugger.dekhao("button status is ${buttonStatusNotifier.status}");
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      if (mounted && context.mounted) {
        setState(() {});
      }
    });
    if (buttonStatusNotifier.status is SuccessStatus) {
      debugger.dekhao("Successful save");
      Future.delayed(const Duration(milliseconds: 1000)).then((_) async {
        if (mounted && context.mounted) {
          widget.onDone();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          constraints: BoxConstraints(maxHeight: 52, maxWidth: constraints.maxWidth),
          decoration: BoxDecoration(
            color:
                (buttonStatusNotifier.status is DisabledStatus || buttonStatusNotifier.status is LoadingStatus)
                    ? AppColors.context(context).inActiveButtonColor
                    : AppColors.context(context).buttonColor,
            borderRadius: widget.borderRadius ??
                AppSizes.rectangleButtonRadius,
          ),
          child: DebouncerButton(
            borderRadius: widget.borderRadius ??
                AppSizes.rectangleButtonRadius,
            onTap: () async{
              if (buttonStatusNotifier.status is EnabledStatus) {
                widget.onSave(buttonStatusNotifier);
              }
            },
            child: Center(
              //key: UniqueKey(),
              child: _buttonText(),
            ),
          ),
        );
      },
    );
  }

  Widget _buttonText() {
    return LayoutBuilder(
      builder: (context, constraints) {
        debugger.dekhao("Button status: ${buttonStatusNotifier.status.runtimeType}");
        switch (buttonStatusNotifier.status.runtimeType) {
          case const (EnabledStatus):
            return Text(
              widget.generalText,
              style: widget.style ?? TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.context(context).buttonContentColor,
              ),
            );

          case const (DisabledStatus):
            debugger.dekhao("Button is disabled");
            return Text(
              widget.generalText,
              style: widget.style ?? TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.context(context).inActiveButtonContentColor,
              ),
            );

          case const (LoadingStatus):
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Text(
                  widget.loadingText,
                  style: widget.style ?? TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.context(context).buttonContentColor,
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 4, color: Colors.white),
                ),
              ],
            );

          case const (ErrorStatus):
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  size: AppSizes.mediumIconSize,
                  color: Colors.orange,
                ),
                SizedBox(width: 10),
                Text(
                  widget.errorText,
                  style: widget.style ?? TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.context(context).buttonContentColor,
                  ),
                ),
              ],
            );

          case const (SuccessStatus):
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.done,
                  size: AppSizes.mediumIconSize,
                  color: AppColors.context(context).buttonContentColor,
                ),
                SizedBox(width: 10),
                Text(
                  widget.doneText,
                  style: widget.style ?? TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                    color: AppColors.context(context).buttonContentColor,
                  ),
                ),
              ],
            );
          default:
            debugger.dekhao("Button status not found");
            return Text(
              "Save",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.context(context).inActiveButtonContentColor,
              ),
            );
        }
      },
    );
  }
}
