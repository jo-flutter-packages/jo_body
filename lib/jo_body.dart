library jo_body;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jo_buttons/jo_buttons.dart';
import 'package:jo_loading/jo_loading.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class JOBody extends StatefulWidget {
  const JOBody({
    Key? key,
    required this.rtl,
    required this.body,
    this.actions,
    this.title,
    required this.inProgress,
    this.padding,
    this.margin,
    this.displayAds = false,
    this.authorized = true,
    this.onPopPushReplacement,
    this.bottomNavigation,
  }) : super(key: key);
  final bool rtl;
  final Widget body;
  final List<JOSmallButton>? actions;
  final String? title;
  final bool inProgress;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool displayAds;
  final bool authorized;
  final String? onPopPushReplacement;
  final Widget? bottomNavigation;

  @override
  State<JOBody> createState() => _JOBodyState();
}

class _JOBodyState extends State<JOBody> with WidgetsBindingObserver {
  List<JOFloatingButton>? activeActions;
  bool inProgress = false;

  final controller = StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get stream => controller.stream;

  @override
  void initState() {
    super.initState();

    inProgress = widget.inProgress;

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // user returned to our app
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await goBack(widget.title ?? "");
      },
      child: Scaffold(
        appBar: widget.title != null && widget.title!.isNotEmpty
            ? AppBar(
                title: Text(
                  widget.title ?? "",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            : null,
        body: SafeArea(
          child: Container(
            padding: widget.padding,
            margin: widget.margin,
            height: MediaQuery.of(context).size.height,
            child: widget.inProgress
                ? const JOLoading()
                : Directionality(
                    textDirection:
                        widget.rtl ? TextDirection.rtl : TextDirection.ltr,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 6,
                          child: SingleChildScrollView(
                            child: widget.body,
                          ),
                        ),
                        widget.actions != null
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.all(10.0),
                                height: 60.0,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: widget.actions!.toList(),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
          ),
        ),
        bottomNavigationBar: widget.bottomNavigation,
      ),
    );
  }

  Future<bool> goBack(String ttl) async {
    if (widget.onPopPushReplacement != null) {
      Navigator.of(context).pushNamed(widget.onPopPushReplacement ?? "");
    } else {
      Navigator.of(context).pop();
    }
    return true;
  }
}
