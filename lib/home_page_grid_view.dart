import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_app/student.dart';
import 'package:student_app/style_constants.dart';
import 'package:student_app/translations/Locale_keys.g.dart';

import 'color_constants.dart';
import 'edit_page.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePageGridView extends StatefulWidget {
  final List<Student> studentList;
  final Function updateStudent;
  final bool sortByRank;
  final List<int> indexSelectedList;
  final Function setIndex ;
  const HomePageGridView(
      {Key? key,
        required this.studentList,
        required this.sortByRank,
        required this.updateStudent,
        required this.indexSelectedList,required this.setIndex,
        })
      : super(key: key);

  @override
  State<HomePageGridView> createState() => _HomePageGridViewState();
}

class _HomePageGridViewState extends State<HomePageGridView> {



  @override
  Widget build(BuildContext context) {
    print(widget.indexSelectedList);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: GridView.builder(
          itemCount: widget.studentList.length,
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15.h,
            crossAxisSpacing: 15.w,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: (){
                widget.setIndex(index);
              },
              onTap: () async {

                if(widget.indexSelectedList.isEmpty){
                  final Student? student = await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return EditPage(
                      student: widget.studentList[index],
                      studentList: widget.studentList,
                    );
                  }));
                  if (student != null) {
                    widget.updateStudent(student, index);
                  }

                }else{
                  widget.setIndex(index);

                }


              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: primaryColorDark,
                    ),
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 25.h),
                    child: Column(
                      children: [
                        SizedBox(height: 45.h),
                        Text(
                          "${LocaleKeys.grid_view.tr()}: ${widget.studentList[index].name}",
                          textAlign: TextAlign.center,
                          style: textStyle.copyWith(fontSize: 14.sp),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "${LocaleKeys.id.tr()}: ${widget.studentList[index].studentId}",
                          textAlign: TextAlign.center,
                          style: textStyle.copyWith(fontSize: 14.sp),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "${LocaleKeys.marks.tr()}: ${widget.studentList[index].marks}",
                          textAlign: TextAlign.center,
                          style: textStyle.copyWith(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                  if (widget.sortByRank)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 55.h,
                        width: 55.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: linearGradient,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                            LocaleKeys.rank.tr(),
                              style: TextStyle(
                                color: primaryColorLight,
                                fontSize: 11.sp,
                              ),
                            ),
                            Text(
                              widget.studentList[index].rank.toString(),
                              style: TextStyle(
                                color: primaryColorLight,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if(widget.indexSelectedList.contains(index))
                    const PositionedDirectional(
                      start: 10,
                      top: 10,
                      child: Icon(Icons.check_circle,color: Colors.red,),
                    )
                ],
              ),
            );
          }),
    );
  }
}
