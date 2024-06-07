import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_test/data/cubit/news_state.dart';

class NewsCubit extends Cubit<NewsStates>{
  NewsCubit() :super(NewsInitial());
}