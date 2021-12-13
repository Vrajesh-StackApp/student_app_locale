import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_app/preferences.dart';
import 'package:student_app/select_language.dart';
import 'package:student_app/student.dart';
import 'package:student_app/student_database.dart';
import 'package:student_app/style_constants.dart';
import 'package:student_app/translations/Locale_keys.g.dart';

import 'add_user_page.dart';
import 'color_constants.dart';
import 'custom_gradient_background.dart';
import 'home_page_grid_view.dart';
import 'home_page_list_view.dart';
import 'package:easy_localization/easy_localization.dart';

enum View { grid, list }
enum Sort { none, name, marks, id, rank }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var view = View.list;
  List<Student> studentList = [];
  List<Student> sortedStudentList = [];
  var sortBy = Sort.none;
  bool isLoading = true;
  bool selectDarkTheme = false;
  bool selectLightTheme = false;
  List<int> indexSelectedList = [];
  List<Student> selectedStudent = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  void fetchStudents() async {
    final List<Student> list = await StudentDatabase.instance.readAllNotes();

    setState(() {
      studentList.addAll(list);
      isLoading = false;
    });
  }

  sorting(Sort sort) {
    sortedStudentList.clear();
    sortedStudentList.addAll(studentList);
    if (sort == Sort.marks) {
      sortedStudentList.sort((a, b) => b.marks!.compareTo(a.marks!));
      sortBy = Sort.marks;
    } else if (sort == Sort.id) {
      sortedStudentList.sort((a, b) => a.studentId!.compareTo(b.studentId!));
      sortBy = Sort.id;
    } else if (sort == Sort.name) {
      sortedStudentList.sort((a, b) => a.name!.compareTo(b.name!));
      sortBy = Sort.name;
    } else if (sort == Sort.rank) {
      sortedStudentList.sort((a, b) => b.marks!.compareTo(a.marks!));
      var r = 1;
      for (var stu in sortedStudentList) {
        stu.rank = r++;
      }
      sortBy = Sort.rank;
    }
    print(sortedStudentList);
    setState(() {});
  }

  void updateStudent(Student stu) {
    studentList
        .removeAt(studentList.indexWhere((element) => element.id == stu.id));
    studentList.add(stu);
    if (sortBy != Sort.none) {
      sortedStudentList.removeAt(
          sortedStudentList.indexWhere((element) => element.id == stu.id));
      sortedStudentList.add(stu);
    }
    sorting(sortBy);
    StudentDatabase.instance.update(stu);
  }

  void deleteStudent(Student stu) {
    if (sortBy != Sort.none) {
      sortedStudentList.removeAt(
          sortedStudentList.indexWhere((element) => element.id == stu.id));
    }
    studentList
        .removeAt(studentList.indexWhere((element) => element.id == stu.id));
    setState(() {});
    StudentDatabase.instance.delete(stu.id!);
  }

  void deleteAllSelected() {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: LocaleKeys.delete.tr(),
          contentText: LocaleKeys.do_you_want_to_delete_data.tr(),
          onPositiveClick: () {
            Navigator.of(context).pop();
            setState(() {
              for (int i = 0; i < selectedStudent.length; i++) {
                studentList.remove(selectedStudent[i]);
              }
              indexSelectedList.clear();
              selectedStudent = [];
            });
          },
          positiveTextStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
          onNegativeClick: () {
            Navigator.of(context).pop();
          },
          negativeTextStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
      },
      animationType: DialogTransitionType.slideFromRight,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? willPop = false;

        willPop = await showAnimatedDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return ClassicGeneralDialogWidget(
              titleText: 'Exit',
              contentText: 'Do You Want to Exit From App',
              onPositiveClick: () {
                Navigator.of(context).pop(true);
              },
              positiveTextStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
              onNegativeClick: () {
                Navigator.of(context).pop(false);
              },
              negativeTextStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            );
          },
          animationType: DialogTransitionType.slideFromRight,
          curve: Curves.fastOutSlowIn,
          duration: const Duration(seconds: 1),
        );
        return willPop!;
      },
      child: CustomGradientBackground(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Scaffold(
                drawer: Container(
                  width: 274.w,
                  color: PreferencesApp().getDarkTheme
                      ? const Color(0xff252B43)
                      : const Color(0xff8D67FF),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Center(child: Icon(Icons.person, size: 24,)),
                      Container(
                          width: double.infinity,
                          height: 100,
                          alignment: AlignmentDirectional.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.person,
                                size: 70.h,
                              ),
                              SizedBox(
                                width: 25.h,
                              ),
                              Text(
                                LocaleKeys.hello.tr(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ],
                          )),

                      const Divider(),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 30),
                        child: Row(
                          children: [
                            Text(
                              LocaleKeys.theme.tr(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectDarkTheme = false;
                                    selectLightTheme = true;
                                    PreferencesApp()
                                        .setDarkTheme(selectDarkTheme);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    primary:
                                        PreferencesApp().getDarkTheme == false
                                            ? const Color(0xff8D67FF)
                                            : Colors.white),
                                child: Text(LocaleKeys.light.tr(),
                                    style: TextStyle(
                                      color: PreferencesApp().getDarkTheme
                                          ? const Color(0xff8D67FF)
                                          : Colors.white,
                                    ))),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectDarkTheme = true;
                                    selectLightTheme = false;
                                    PreferencesApp()
                                        .setDarkTheme(selectDarkTheme);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: PreferencesApp().getDarkTheme
                                        ? const Color(0xff8D67FF)
                                        : Colors.white),
                                child: Text(LocaleKeys.dark.tr(),
                                    style: TextStyle(
                                      color:
                                          PreferencesApp().getDarkTheme == false
                                              ? const Color(0xff8D67FF)
                                              : Colors.white,
                                    ))),
                          ],
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 30),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectLanguage()));
                          },
                          child: Text(LocaleKeys.select_language.tr(),
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    Visibility(
                      visible: selectedStudent.isNotEmpty,
                      child: IconButton(
                          onPressed: () {
                            deleteAllSelected();
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                    PopupMenuButton(
                      child: Icon(
                        FlutterRemix.menu_3_line,
                        color: PreferencesApp().getDarkTheme
                            ? Colors.white
                            : const Color(0xff2F3651),
                        size: 24.w,
                      ),
                      color: const Color(0xff983BE1),
                      initialValue: view == View.list ? 1 : 2,
                      onSelected: (index) {
                        if (index == 1) {
                          setState(() {
                            view = View.list;
                          });
                        } else if (index == 2) {
                          setState(() {
                            view = View.grid;
                          });
                        } else if (index == 4) {
                          sorting(Sort.name);
                        } else if (index == 5) {
                          sorting(Sort.id);
                        } else if (index == 6) {
                          sorting(Sort.rank);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text(
                            LocaleKeys.list_view.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text(
                            LocaleKeys.grid_view.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                          value: 2,
                        ),
                        PopupMenuItem(
                          enabled: false,
                          child: Text(
                            LocaleKeys.sort_by.tr(),
                            style: popUpMenuTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: primaryColorDark),
                          ),
                          value: 3,
                        ),
                        PopupMenuItem(
                          child: Text(
                            LocaleKeys.name.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                          value: 4,
                        ),
                        PopupMenuItem(
                          child: Text(
                            LocaleKeys.id.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                          value: 5,
                        ),
                        PopupMenuItem(
                          child: Text(
                            LocaleKeys.rank.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                          value: 6,
                        )
                      ],
                    ),
                  ],
                ),
                floatingActionButton: Container(
                  decoration: const BoxDecoration(
                    gradient: linearGradient,
                    shape: BoxShape.circle,
                  ),
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    onPressed: () async {
                      final Student? student = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return AddUserPage(
                              studentList: studentList,
                            );
                          },
                        ),
                      );
                      if (student != null) {
                        studentList.add(student);
                        StudentDatabase.instance.create(student);
                        if (sortBy == Sort.none) {
                          setState(() {});
                        } else {
                          sorting(sortBy);
                        }
                      }
                    },
                    child: Icon(
                      Icons.add,
                      color: primaryColorLight,
                      size: 24.w,
                    ),
                  ),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [],
                      ),
                    ),
                    Expanded(
                      child: view == View.list
                          ? HomePageListView(
                              studentList: sortBy == Sort.none
                                  ? studentList
                                  : sortedStudentList,
                              sortByRank: sortBy == Sort.rank,
                              updateStudent: (Student stu, int index) {
                                updateStudent(stu);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.purple,
                                        content: Text(
                                          LocaleKeys.data_updated_successfully
                                              .tr(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        )));
                              },
                              deleteStudent: (Student stu, int index) {
                                deleteStudent(stu);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.purple,
                                        content: Text(
                                          LocaleKeys.data_deleted_successfully
                                              .tr(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        )));
                              },
                            )
                          : HomePageGridView(
                              studentList: sortBy == Sort.none
                                  ? studentList
                                  : sortedStudentList,
                              setIndex: (index) {
                                indexSelectedList.contains(index)
                                    ? indexSelectedList.remove(index)
                                    : indexSelectedList.add(index);
                                selectedStudent.contains(index)
                                    ? selectedStudent.remove(studentList[index])
                                    : selectedStudent.add(studentList[index]);
                                setState(() {});
                              },
                              indexSelectedList: indexSelectedList,
                              sortByRank: sortBy == Sort.rank,
                              updateStudent: (Student stu, int index) {
                                updateStudent(stu);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.purple,
                                        content: Text(
                                          LocaleKeys.data_updated_successfully
                                              .tr(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        )));
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
