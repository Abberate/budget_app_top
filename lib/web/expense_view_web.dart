import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components.dart';
import '../view_model.dart';

class ExpenseViewWeb extends HookConsumerWidget {
  const ExpenseViewWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;

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
            size: 30.0,
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
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/login_image.png",
                  width: deviceWidth / 3.0,
                ),
                //add incomes & expenses
                SizedBox(
                  height: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //add expense
                      AddExpense(),
                      SizedBox(
                        height: 30.0,
                      ),
                      //add income
                      AddIncome()
                    ],
                  ),
                ),
                SizedBox(
                  width: 30.0,
                ),
                Container(
                  height: 380.0,
                  width: 450.0,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF6C63FF),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                  child: TotalCalculation(17.0),
                ),
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            Divider(
              indent: deviceWidth / 4,
              endIndent: deviceWidth / 4,
              color: Color(0xFF6C63FF),
              thickness: 3.0,
            ),
            SizedBox(
              height: 50.0,
            ),
            //Expense & incomes list
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Expenses List
                Container(
                  padding: EdgeInsets.all(15.0),
                  height: 320.0,
                  width: 260.0,
                  decoration: BoxDecoration(
                    color: Color(0xFF6C63FF),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                    border: Border.all(width: 1.0, color: Color(0xFF6C63FF)),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Poppins(
                          text: "Expenses",
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      Divider(
                        indent: 30.0,
                        endIndent: 30.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        height: 210.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          border: Border.all(width: 1.0, color: Colors.white),
                        ),
                        child: ListView.builder(
                            itemCount: viewModelProvider.expenses.length,
                            itemBuilder: (BuildContext context, int index) {
                              return IncomeExpenseRowWeb(
                                name: viewModelProvider.expenses[index].name,
                                amount:
                                    viewModelProvider.expenses[index].amount,
                              );
                            }),
                      )
                    ],
                  ),
                ),
                //Incomes List
                Container(
                  padding: EdgeInsets.all(15.0),
                  height: 320.0,
                  width: 260.0,
                  decoration: BoxDecoration(
                    color: Color(0xFF6C63FF),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                    border: Border.all(width: 1.0, color: Color(0xFF6C63FF)),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Poppins(
                          text: "Incomes",
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      Divider(
                        indent: 30.0,
                        endIndent: 30.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        height: 210.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          border: Border.all(width: 1.0, color: Colors.white),
                        ),
                        child: ListView.builder(
                          itemCount: viewModelProvider.incomes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return IncomeExpenseRowWeb(
                              name: viewModelProvider.incomes[index].name,
                              amount: viewModelProvider.incomes[index].amount,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
