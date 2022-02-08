import 'package:shop_app/models/shop_login_model.dart';

abstract class SearchStates{}

class SearchInitialState extends SearchStates {}

class SearchLoadingState extends SearchStates {}

class SearchSuccessState extends SearchStates {}

class SearchErrorState extends SearchStates {}