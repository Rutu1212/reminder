import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder/core/model/home_model.dart';
import 'package:reminder/core/view_model/base_view.dart';

import '../core/model/home_model.dart';
import '../core/view_model/set_timer_model/set_timer_screen_model.dart';

class SetTimerScreen extends StatefulWidget {
  ScreenArguments? screenArguments;

  SetTimerScreen({Key? key, this.screenArguments}) : super(key: key);

  @override
  State<SetTimerScreen> createState() => _SetTimerScreenState();
}

class _SetTimerScreenState extends State<SetTimerScreen> {
  SetTimerViewModel? model;

  @override
  Widget build(BuildContext context) {
    return BaseView<SetTimerViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              widget.screenArguments!.isUpdate! ? "Update Reminder" : "Create Reminder",
              style: TextStyle(color: Colors.grey.shade800),
            ),
            elevation: 0.4,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.grey.shade800),
            ),
            actions: [
              Icon(Icons.more_vert, color: Colors.grey.shade800, size: 30),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          body: Form(
            key: model.formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 250,
                      width: 220,
                      child: CupertinoDatePicker(
                        use24hFormat: false,
                        initialDateTime: DateTime.now(),
                        /*minimumDate: DateTime.now(),
                        minuteInterval: 1,*/
                        mode: CupertinoDatePickerMode.time,
                        onDateTimeChanged: (value) {
                          if (value != model.time) {
                            model.time = value;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 20, bottom: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 200,
                          height: 37,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Colors.grey.shade200),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: Icon(Icons.date_range, color: Colors.grey.shade600),
                              ),
                              Text(
                                model.selectedDate == null
                                    ? model.formatter.format(DateTime.now()).toString()
                                    : model.formatter.format(model.selectedDate!).toString(),
                                style: TextStyle(fontSize: 17, color: Colors.grey.shade800),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext builder) {
                              return Container(
                                height: MediaQuery.of(context).copyWith().size.height * 0.25,
                                color: Colors.white,
                                child: CupertinoDatePicker(
                                  onDateTimeChanged: (value) {
                                    // DateTime.now();
                                    if (value != model.selectedDate) {
                                      model.selectedDate = value;
                                      setState(() {});
                                    }
                                  },
                                  initialDateTime: DateTime.now(),
                                  minimumYear: DateTime.now().year,
                                  maximumYear: 2025,
                                  minuteInterval: 1,
                                  minimumDate: DateTime.now().subtract(const Duration(seconds: 1)),
                                  mode: CupertinoDatePickerMode.date,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1.5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text('Title', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.grey.shade200,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Title.';
                              } else {
                                return null;
                              }
                            },
                            maxLines: 1,
                            controller: model.titleController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: const [
                          Text('Note', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.grey.shade200,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: TextField(
                            controller: model.noteController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Icon(Icons.notes_outlined),
                                  ],
                                ),
                              ),
                              prefixIconColor: Colors.grey.shade300,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        offset: const Offset(0, 1),
                        blurRadius: 10,
                        spreadRadius: 50,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 35, bottom: 42, right: 35, top: 18),
                    child: ElevatedButton(
                      onPressed: () async {
                        int tDiff = model.time == null ? 1 : model.time!.difference(DateTime.now()).inSeconds;
                        print("Abc=${model.time}");
                        if (tDiff < 0) {
                          tDiff = tDiff + 86400;
                        }
                        // print(tDiff);
                        print(model.titleController.text);
                        if (model.formKey.currentState!.validate()) {
                          if (widget.screenArguments!.isUpdate!) {
                            model.fltNotification!.cancel(model.uid);
                            // model.clearText();
                            model.updateData(widget.screenArguments!.reminderId);
                            // print(widget.screenArguments!.reminderId);
                            model.showNotification(
                              model.uid,
                              model.titleController.text,
                              model.noteController.text,
                              Duration(
                                seconds: tDiff,
                              ),
                            );
                          } else {
                            print("");
                            model.addData();
                            model.showNotification(
                              model.uid,
                              model.titleController.text,
                              model.noteController.text,
                              Duration(
                                seconds: tDiff,
                              ),
                            );
                          }
                          Navigator.pop(context);
                        }
                        model.formKey.currentState!.save();
                        // model.clearText();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(widget.screenArguments!.isUpdate! ? null : Icons.add),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.screenArguments!.isUpdate! ? "Update Reminder" : "Create Reminder",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onModelReady: (model) async {
        this.model = model;
        model.getData();
        model.localNotification();
      },
    );
  }
}
