import 'package:budget_app/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model.dart';

class ExpenseViewMobile extends HookConsumerWidget {
  const ExpenseViewMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    double deviceWidth = MediaQuery.of(context).size.width;

    useEffect(() {
      viewModelProvider.expensesStream();
      viewModelProvider.incomesStream();
      return null;
    }, []);

    return SafeArea(
      child: Scaffold(
        drawer: DrawerExpense(),
        appBar: AppBar(
          backgroundColor: Color(0xFF6C63FF),
          iconTheme: IconThemeData(color: Colors.white, size: 30.0),
          centerTitle: true,
          title: Poppins(
            text: "Dashboard",
            size: 25.0,
            color: Colors.white,
          ),
          actions: [
            IconButton(
              onPressed: () async {
                viewModelProvider.reset();
              },
              icon: Icon(Icons.refresh),
            )
          ],
        ),
        body: ListView(
          children: [
            SizedBox(height: 40.0),
            Column(
              children: [
                Container(
                  height: 240.0,
                  width: deviceWidth / 1.5,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF6C63FF),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                  child: TotalCalculation(15.0),
                )
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Add expense
                AddExpense(),
                SizedBox(
                  width: 10.0,
                ),
                AddIncome()
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Expenses List
                  Column(
                    children: [
                      Poppins(
                          text: "Expenses",
                          size: 15.0,
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.bold),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(7.0),
                        height: 210.0,
                        width: 180.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          border:
                              Border.all(width: 1.0, color: Color(0xFF6C63FF)),
                        ),
                        child: ListView.builder(
                            itemCount: viewModelProvider.expenses.length,
                            itemBuilder: (BuildContext context, int index) {
                              return IncomeExpenseRowMobile(
                                name: viewModelProvider.expenses[index].name,
                                amount:
                                    viewModelProvider.expenses[index].amount,
                              );
                            }),
                      )
                    ],
                  ),
                  //Incomes List
                  Column(
                    children: [
                      Poppins(
                        text: "Incomes",
                        size: 15.0,
                        color: Color(0xFF6C63FF),
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(7.0),
                        height: 210.0,
                        width: 180.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          border:
                              Border.all(width: 1.0, color: Color(0xFF6C63FF)),
                        ),
                        child: ListView.builder(
                            itemCount: viewModelProvider.incomes.length,
                            itemBuilder: (BuildContext context, int index) {
                              return IncomeExpenseRowMobile(
                                name: viewModelProvider.incomes[index].name,
                                amount: viewModelProvider.incomes[index].amount,
                              );
                            }),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
