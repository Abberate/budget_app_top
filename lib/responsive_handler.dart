import 'package:budget_app/mobile/expense_view_mobile.dart';
import 'package:budget_app/view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'mobile/login_view_mobile.dart';
import 'web/expense_view_web.dart';
import 'web/login_view_web.dart';

class ResponsiveHandler extends HookConsumerWidget {
  const ResponsiveHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authStateProvider);

    return _authState.when(data: (data) {
      if (data != null) {
        return LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return ExpenseViewWeb();
          } else {
            return ExpenseViewMobile();
          }
        });
      } else {
        return LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return LoginViewWeb();
          } else {
            return LoginViewMobile();
          }
        });
      }
    }, error: (e, trace) {
      return LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return LoginViewWeb();
        } else {
          return LoginViewMobile();
        }
      });
    }, loading: () {
      return LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return LoginViewWeb();
        } else {
          return LoginViewMobile();
        }
      });
    });
  }
}
