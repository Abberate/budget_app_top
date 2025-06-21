import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components.dart';
import '../view_model.dart';

class ExpenseViewWeb extends HookConsumerWidget {
  const ExpenseViewWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;

    int totalExpense = 0;
    int totalIncome = 0;

    useEffect(() {
      viewModelProvider.expensesStream();
      viewModelProvider.incomesStream();
      return null;
    }, []);

    void calculate() {
      for (int i = 0; i < viewModelProvider.expensesName.length; i++) {
        totalExpense += int.parse(viewModelProvider.expensesAmount[i]);
      }
      for (int i = 0; i < viewModelProvider.incomesName.length; i++) {
        totalIncome += int.parse(viewModelProvider.incomesAmount[i]);
      }
    }

    calculate();
    int budgetLeft = totalIncome - totalExpense;

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DrawerHeader(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF6C63FF), width: 1.0),
                  ),
                  child: CircleAvatar(
                    radius: 180.0,
                    backgroundColor: Colors.white,
                    child: Image(
                      height: 100.0,
                      image: AssetImage("assets/logo.png"),
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              MaterialButton(
                color: Color(0xFF6C63FF),
                height: 50.0,
                minWidth: 200.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 20.0,
                child: Poppins(
                  text: "Logout",
                  size: 20.0,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await viewModelProvider.logout();
                },
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      await launchUrl(Uri.parse("https://instagram.com"));
                    },
                    icon: SvgPicture.asset(
                      'assets/instagram.svg',
                      width: 35.0,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await launchUrl(Uri.parse("https://twitter.com"));
                    },
                    icon: SvgPicture.asset(
                      'assets/twitter.svg',
                      width: 35.0,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
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
                      SizedBox(
                        height: 50.0,
                        width: 180.0,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            overlayColor: Colors.grey,
                            backgroundColor: Color(0xFF6C63FF),
                            iconColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10.0),
                            ),
                          ),
                          label: Poppins(
                            text: "Add Expense",
                            size: 15.0,
                            color: Colors.white,
                          ),
                          icon: Icon(
                            Icons.add,
                            size: 15.0,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await viewModelProvider.addExpense(context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      //add income
                      SizedBox(
                        height: 50.0,
                        width: 180.0,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            overlayColor: Colors.grey,
                            backgroundColor: Color(0xFF6C63FF),
                            iconColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10.0),
                            ),
                          ),
                          label: Poppins(
                            text: "Add Income",
                            size: 15.0,
                            color: Colors.white,
                          ),
                          icon: Icon(
                            Icons.add,
                            size: 15.0,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await viewModelProvider.addIncome(context);
                          },
                        ),
                      ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Poppins(
                              text: "Budget left",
                              size: 15.0,
                              color: Colors.white),
                          Poppins(
                              text: "Total expense",
                              size: 15.0,
                              color: Colors.white),
                          Poppins(
                              text: "Total Incomes",
                              size: 15.0,
                              color: Colors.white),
                        ],
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: Divider(
                          color: Colors.white,
                          indent: 40.0,
                          endIndent: 40.0,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Poppins(
                              text: budgetLeft.toString(),
                              size: 15.0,
                              color: Colors.white),
                          Poppins(
                              text: totalExpense.toString(),
                              size: 15.0,
                              color: Colors.white),
                          Poppins(
                              text: totalIncome.toString(),
                              size: 15.0,
                              color: Colors.white),
                        ],
                      )
                    ],
                  ),
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
                            itemCount: viewModelProvider.expensesAmount.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Poppins(
                                    text: viewModelProvider.expensesName[index],
                                    size: 15.0,
                                    color: Colors.white,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Poppins(
                                      text: viewModelProvider
                                          .expensesAmount[index],
                                      size: 15.0,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
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
                          itemCount: viewModelProvider.incomesAmount.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Poppins(
                                  text: viewModelProvider.incomesName[index],
                                  size: 15.0,
                                  color: Colors.white,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Poppins(
                                    text:
                                        viewModelProvider.incomesAmount[index],
                                    size: 15.0,
                                    color: Colors.white,
                                  ),
                                )
                              ],
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
