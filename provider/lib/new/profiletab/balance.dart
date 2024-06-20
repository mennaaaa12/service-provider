import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker/controller/BalanceController.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  late Timer _timer;
  final BalanceController _controller = Get.put(BalanceController());

  @override
  void initState() {
    super.initState();
    _fetchBalance();
    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      _fetchBalance();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchBalance() async {
    try {
      await _controller.fetchBalance();
    } catch (e) {
      print('Error fetching balance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        return Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: _fetchBalance,
            child: _buildBalanceView(),
          ),
        );
      }
    });
  }

  Widget _buildBalanceView() {
    print('Current balance: ${_controller.balance}');
    return Column(
      children: [
        AppBar(
          title: Text('اعرف رصيدك'),
        ),
        SizedBox(height: 20,),
        Container(
          child: Resubale(
            title: 'الرصيد',
            value: _controller.balance.toString(),
            iconData: Icons.account_balance_wallet_outlined,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'تنبيه : رصيدك يجب ان لا يتعدى -500 جنيه ويجب عليك ان تسدد حتى لا يتم وقف حسابك',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'يمكن ان تتواصل مع احد ممثلين الشركه من خلال الرقم 012345678912',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Resubale extends StatelessWidget {
  final String title, value;
  final IconData iconData;

  const Resubale({
    Key? key,
    required this.title,
    required this.iconData,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            leading: Icon(iconData, color: Colors.black),
          ),
          Divider(color: Colors.black.withOpacity(0.4)),
        ],
      ),
    );
  }
}
