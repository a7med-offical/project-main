import 'package:flutter/material.dart';

class FormProvider extends ChangeNotifier {


   bool signOut = false ;
   
   void userSignOut(){
    signOut = true ;
     notifyListeners();
   }  

  int selectPressure = 0;
  int selectedDonated = 0;
  int selectedGender = 0;
  int selectedPregnancy = 0;
  int selectedSmoking = 0;
  int selectedChronicKidneyDisease = 0;
  int selectedAdrenalAndThyroidDisorders = 0;

  void getPressure({required int selectIndex}) {
    selectPressure = selectIndex;
    notifyListeners();
  }

  void getGender({required int selectIndex}) {
    selectedGender = selectIndex;
    notifyListeners();
  }

  void getPregnancy({required int selectIndex}) {
    selectedPregnancy = selectIndex;
    notifyListeners();
  }

  void getSmoking({required int selectIndex}) {
    selectedSmoking = selectIndex;
    notifyListeners();
  }

  void getKidneyDisease({required int selectIndex}) {
    selectedChronicKidneyDisease = selectIndex;
    notifyListeners();
  }

  void getThyroidDisorders({required int selectIndex}) {
    selectedAdrenalAndThyroidDisorders = selectIndex;
    notifyListeners();
  }

  void getDonate({required int selectIndex}) {
    selectedDonated = selectIndex;
    notifyListeners();
  }
}
