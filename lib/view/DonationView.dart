// ignore_for_file: unused_element
import 'package:bldapp/Provider/ProvidetUser.dart';
import 'package:bldapp/services/donation_model.dart';
import 'package:bldapp/view/wait_view.dart';
import 'package:bldapp/widget/custom_card.dart';
import 'package:bldapp/widget/custom_radio_button.dart';
import 'package:bldapp/widget/custom_space.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Colors.dart';
import '../Provider/theme_provider.dart';

class DonationView extends StatefulWidget {
  const DonationView({super.key});
  static String id = '15';

  @override
  State<DonationView> createState() => _DonationViewState();
}

class _DonationViewState extends State<DonationView> {
  TextEditingController _textEditingController = TextEditingController();
  void initState() {
    super.initState();
    _textEditingController.text = _selectedOption ?? '';
  }

  String? _selectedOption;
  GlobalKey<FormState> key = GlobalKey();
  GlobalKey<FormState> key2 = GlobalKey();

  List<String> _options = [
    'A+',
    'A-',
    'AB+',
    'AB-',
    'O-',
    'O+',
    'B+',
    'B-',
  ];

  int currentStep = 0;
  int? age;
  int? pressure;
  int? bmi;
  double? level;
  String button = 'Continue';
  final snackbar = SnackBar(
    backgroundColor: Colors.amber,
    content: Text(
      'Location is required to use app! ',
      style: TextStyle(color: background),
    ),
  );

  next() async {
    if (currentStep < 1) {
      setState(() {
        currentStep += 1;
      });
    } else if (currentStep < 2) {
      if (key2.currentState!.validate()) {
        setState(() {
          currentStep += 1;
        });
      } else {}
    } else {
      if (key.currentState!.validate()) {
        var provider = Provider.of<FormProvider>(context, listen: false);

        int i = await Services().makePrediction(
            bloodPressure: provider.selectPressure,
            levelHemoglobin: level!,
            age: age!,
            bmi: bmi!,
            gender: provider.selectedGender,
            pregancy: provider.selectedPregnancy,
            smoking: provider.selectedSmoking,
            chronicKidney: provider.selectedChronicKidneyDisease,
            adrenalAndThyroidDisorders:
                provider.selectedAdrenalAndThyroidDisorders,
            bloodType: _textEditingController.text);
        var prov = Provider.of<FormProvider>(context, listen: false);
        prov.getDonate(selectIndex: 0);
        prov.getGender(selectIndex: 0);
        prov.getKidneyDisease(selectIndex: 0);
        prov.getPregnancy(selectIndex: 0);
        prov.getPressure(selectIndex: 0);
        prov.getSmoking(selectIndex: 0);
        prov.getThyroidDisorders(selectIndex: 0);

        if (i == 0) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return LoadingView(
                ability: 0,
                bloodType: _textEditingController.text,
              );
            },
          ));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return LoadingView(
              ability: 1,
              bloodType: _textEditingController.text,
            );
          }));
        }
      }
    }
  }

  previous() {
    if (currentStep > 0) {
      setState(() {
        currentStep -= 1;
      });
    } else {
      Navigator.pop(context);
    }
  }

  tapped(int index) {
    setState(() {
      currentStep = index;
    });
  }

  Widget CustomController(context, details) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Color(0xffFFCA28), width: 3)),
          color: Colors.amber[400],
          onPressed: details.onStepCancel,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Back',
              style: TextStyle(
                  // color: Color(0xffFFCA28),
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.amber[400],
          onPressed: details.onStepContinue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              button,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    currentStep > 1
        ? setState(() {
            button = 'Finish';
          })
        : setState(() {
            button = 'Next';
          }); // Navigator.push(context, route)
    var prov = Provider.of<FormProvider>(context);
    getData() async {
      await Services().makePrediction(
          bloodPressure: prov.selectPressure,
          levelHemoglobin: level!,
          age: age!,
          bmi: bmi!,
          gender: prov.selectedGender,
          pregancy: prov.selectedPregnancy,
          smoking: prov.selectedSmoking,
          chronicKidney: prov.selectedChronicKidneyDisease,
          adrenalAndThyroidDisorders: prov.selectedAdrenalAndThyroidDisorders,
          bloodType: 'B+');
      print(prov.selectPressure);
    }

    var _theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Theme(
        data: ThemeData(
            // canvasColor: Colors.amber[400],
            // primaryColor: background,
            //
            ),
        child: SafeArea(
          top: true,
          child: Stepper(
              elevation: 0.0,
              currentStep: currentStep,
              onStepContinue: next,
              onStepCancel: previous,
              onStepTapped: tapped,
              physics: BouncingScrollPhysics(),
              controlsBuilder: CustomController,
              type: StepperType.horizontal,
              steps: [
                Step(
                    isActive: currentStep >= 0,
                    state: currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                    title: Text('Step 1'),
                    content: Container(
                      padding: EdgeInsets.only(top: 30),
                      height: MediaQuery.of(context).size.height - 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gender : ',
                            style: TextStyle(
                              // color: Colors.amber[400],
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomCard(
                                  path: 'Assets/Images/male.png',
                                  name: 'Male',
                                  index: 1,
                                  select: prov.selectedGender,
                                  fun: () {
                                    prov.getGender(selectIndex: 1);
                                    prov.getPregnancy(selectIndex: 0);
                                  }),
                              CustomCard(
                                path: 'Assets/Images/female.png',
                                name: 'Female',
                                index: 2,
                                fun: () {
                                  prov.getGender(selectIndex: 2);
                                },
                                select: prov.selectedGender,
                              ),
                            ],
                          ),
                          CustomDivider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pregnancy :',
                                style: TextStyle(
                                  color: prov.selectedGender == 2
                                      ? Colors.amber[400]
                                      : Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CustomRadioButton(
                                    index: 1,
                                    selected: prov.selectedPregnancy,
                                    text: 'No',
                                    fun: prov.selectedGender == 2
                                        ? () {
                                            prov.getPregnancy(selectIndex: 1);
                                          }
                                        : () {
                                            prov.getPregnancy(selectIndex: 0);
                                          },
                                  ),
                                  CustomRadioButton(
                                    index: 2,
                                    selected: prov.selectedPregnancy,
                                    text: 'Yes',
                                    fun: prov.selectedGender == 2
                                        ? () {
                                            prov.getPregnancy(selectIndex: 2);
                                          }
                                        : () {
                                            prov.getPregnancy(selectIndex: 0);
                                          },
                                  )
                                ],
                              ),
                              CustomDivider(),
                            ],
                          ),
                          Text(
                            'Smoking : ',
                            style: TextStyle(
                              // color: Colors.amber[400],
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomRadioButton(
                                  index: 1,
                                  selected: prov.selectedSmoking,
                                  text: "No",
                                  fun: () {
                                    prov.getSmoking(selectIndex: 1);
                                  }),
                              CustomRadioButton(
                                  index: 2,
                                  selected: prov.selectedSmoking,
                                  text: "Yes",
                                  fun: () {
                                    prov.getSmoking(selectIndex: 2);
                                  }),
                            ],
                          ),
                        ],
                      ),
                    )),
                Step(
                    isActive: currentStep >= 1,
                    state: currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                    title: Text('Step 2'),
                    content: Container(
                      padding: EdgeInsets.only(top: 10),
                      height: MediaQuery.of(context).size.height - 200,
                      child: Form(
                        key: key2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Blood Pressure :',
                              style: TextStyle(
                                // color: Colors.amber[400],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomRadioButton(
                                    index: 1,
                                    selected: prov.selectPressure,
                                    text: "No",
                                    fun: () {
                                      prov.getPressure(selectIndex: 1);
                                    }),
                                CustomRadioButton(
                                    index: 2,
                                    selected: prov.selectPressure,
                                    text: "Yes",
                                    fun: () {
                                      prov.getPressure(selectIndex: 2);
                                    }),
                              ],
                            ),
                            CustomDivider(),
                            Text(
                              'Level of Hemoglobin :',
                              style: TextStyle(
                                // color: Colors.amber[400],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your level of Hemoglobin';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: _theme.isDarkMode
                                      ? Colors.white
                                      : background,
                                  fontWeight: FontWeight.bold),
                              onChanged: (value) {
                                setState(() {
                                  level = double.tryParse(value);
                                });
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter your Level of Hemoglobin ',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      // color: Color(0xffFFCA28),
                                      ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _theme.isDarkMode
                                          ? Colors.white
                                          : background,
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _theme.isDarkMode
                                          ? Colors.white
                                          : background,
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                            CustomDivider(),
                            Text(
                              'Age :',
                              style: TextStyle(
                                // color: Colors.amber[400],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              style: TextStyle(
                                color: _theme.isDarkMode
                                    ? Colors.white
                                    : background,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  age = int.tryParse(value);
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your Age';
                                }
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _theme.isDarkMode
                                          ? Colors.white
                                          : background,
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                                hintText: 'Enter your age',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: _theme.isDarkMode
                                        ? Colors.white
                                        : background,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _theme.isDarkMode
                                          ? Colors.white
                                          : background,
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                            CustomDivider(),
                            Text(
                              'BMI :',
                              style: TextStyle(
                                //  color: Colors.amber[400],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              style: TextStyle(
                                color: _theme.isDarkMode
                                    ? Colors.white
                                    : background,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  bmi = int.tryParse(value);
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your BMI';
                                }
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _theme.isDarkMode
                                          ? Colors.white
                                          : background,
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                                hintText: 'Enter your weight',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: _theme.isDarkMode
                                        ? Colors.white
                                        : background,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _theme.isDarkMode
                                          ? Colors.white
                                          : background,
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                Step(
                    isActive: currentStep >= 2,
                    state: currentStep >= 2
                        ? StepState.complete
                        : StepState.disabled,
                    title: Text('Step 3'),
                    content: Container(
                      padding: EdgeInsets.only(top: 30),
                      height: MediaQuery.of(context).size.height - 200,
                      child: Form(
                        key: key,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chronic Kidney Disease :',
                              style: TextStyle(
                                // color: Colors.amber[400],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomRadioButton(
                                    index: 1,
                                    selected: prov.selectedChronicKidneyDisease,
                                    text: 'No',
                                    fun: () {
                                      prov.getKidneyDisease(selectIndex: 1);
                                    }),
                                CustomRadioButton(
                                    index: 2,
                                    selected: prov.selectedChronicKidneyDisease,
                                    text: 'Yes',
                                    fun: () {
                                      prov.getKidneyDisease(selectIndex: 2);
                                    })
                              ],
                            ),
                            CustomDivider(),
                            Text(
                              'Adrenal And Thyroid Disorders :',
                              style: TextStyle(
                                // color: Colors.amber[400],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomRadioButton(
                                    index: 1,
                                    selected:
                                        prov.selectedAdrenalAndThyroidDisorders,
                                    text: 'No',
                                    fun: () {
                                      prov.getThyroidDisorders(selectIndex: 1);
                                    }),
                                CustomRadioButton(
                                    index: 2,
                                    selected:
                                        prov.selectedAdrenalAndThyroidDisorders,
                                    text: 'Yes',
                                    fun: () {
                                      prov.getThyroidDisorders(selectIndex: 2);
                                    }),
                              ],
                            ),
                            CustomDivider(),
                            Text(
                              'Have you donated previously ? ',
                              style: TextStyle(
                                // color: Colors.amber[400],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomRadioButton(
                                    index: 1,
                                    selected: prov.selectedDonated,
                                    text: 'No',
                                    fun: () {
                                      prov.getDonate(selectIndex: 1);
                                    }),
                                CustomRadioButton(
                                    index: 2,
                                    selected: prov.selectedDonated,
                                    text: 'Yes',
                                    fun: () {
                                      prov.getDonate(selectIndex: 2);
                                    })
                              ],
                            ),
                            CustomDivider(),
                            TextFormField(
                                readOnly: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your blood type';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: _theme.isDarkMode
                                      ? Colors.white
                                      : background,

                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.white,
                                ),
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 2,
                                      // color: Color(0xffFFCA28),
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  errorStyle: TextStyle(color: Colors.white),
                                  hintText: 'Select your blood type',
                                  hintStyle: TextStyle(
                                    color: _theme.isDarkMode
                                        ? Colors.white
                                        : background,
                                    fontSize: 18,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: _theme.isDarkMode
                                          ? Colors.white
                                          : background,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: _theme.isDarkMode
                                          ? Colors.white
                                          : background,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        icon: Icon(
                                          Icons.arrow_drop_down_outlined,
                                          size: 30,
                                          // color: Color(0xffFFCA28),
                                        ),
                                        items: _options.map((String option) {
                                          return DropdownMenuItem<String>(
                                            value: option,
                                            child: Text(option),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedOption = newValue;
                                            _textEditingController.text =
                                                newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    )),
              ]),
        ),
      ),
    );
  }
}
