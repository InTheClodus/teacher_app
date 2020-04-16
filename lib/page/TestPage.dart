import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:teacher_app/base/api_response.dart';
import 'package:teacher_app/module/employee.dart';
import 'package:teacher_app/repositorries/contract_provider_employee.dart';

class TestPage extends StatefulWidget {
  const TestPage(this.employeeProvideContract);
  final EmployeeProvideContract employeeProvideContract;
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<Emloyee> randomDietPlans = <Emloyee>[];
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showDietList(),
    );
  }

  Widget _showDietList() {
    return FutureBuilder<ApiResponse>(
        future: widget.employeeProvideContract.getByUser(),
        builder: (BuildContext context, AsyncSnapshot<ApiResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.success) {
              if (snapshot.data.results == null ||
                  snapshot.data.results.isEmpty) {
                return const Center(
                  child: Text('No Data'),
                );
              }
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.results.length,
                itemBuilder: (BuildContext context, int index) {
                  final Emloyee dietPlan = snapshot.data.results[index];
                  final String id = dietPlan.objectId;
                  final String name = dietPlan.displayName;
                  final String description = dietPlan.email;
                  final String status = dietPlan.address;
                  return Dismissible(
                    key: Key(id),
                    background: Container(color: Colors.red),
                    onDismissed: (DismissDirection direction) async {
                      widget.employeeProvideContract.remove(dietPlan);
                    },
                    child: ListTile(
                      title: Text(
                        name,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      subtitle: Text(snapshot.data.results.first['branch']['remark']),
                      trailing: Text(status),
                    ),
                  );
                });


          } else {
            return const Center(
              child: Text('No Data'),
            );
          }
        });
  }
}
