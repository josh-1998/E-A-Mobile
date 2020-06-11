import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/blocs/competition/competition_bloc.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'result_event.dart';

part 'result_state.dart';

class ResultBloc extends Bloc<ResultEvent, ResultState> {
  final UserRepository _userRepository;
  final Result _result;
  final bool _isCompetitionConverter;
  final Competition competition;
  //0:title, 1:position,
  List<bool> conditions = [false, false];


  ResultBloc(this._userRepository, {Result result, bool isCompetitionConverter,
    this.competition}):
        _result = result ?? Result(),
        _isCompetitionConverter = isCompetitionConverter ?? false;

  @override
  ResultState get initialState => InitialResultState(_result);

  @override
  Stream<ResultState> mapEventToState(ResultEvent event) async* {
    if(event is AddTitle){
      if(event.title!=null && event.title !='') {
        conditions[0] = true;
      }else{
        conditions[0] = false;
      }
      _result.name = event.title;
      yield UpdatedResultState(_result);
    }else if(event is AddPosition){
      if(event.position>0) {
        conditions[1] = true;
      }else{
        conditions[1] = false;
      }
      _result.position = event.position;
      yield UpdatedResultState(_result);
    }else if(event is ChangeDate){
      _result.date = event.date;
      yield UpdatedResultState(_result);
    }else if(event is AddReflections){
      _result.reflections = event.reflections;
      yield UpdatedResultState(_result);
    }else if(event is Submit){
      yield IsSubmitting(_result);
      int numberOfFalse = 0;
      for(bool condition in conditions){
        if(condition == false)numberOfFalse++;
      }
//      if(numberOfFalse == 0) {
        try {
          Result _newResult = await _result.uploadResult(
              _userRepository);
          if(_isCompetitionConverter) {
            await deleteCompetition(await _userRepository.refreshIdToken(), competition);
            _userRepository.diary.competitionList = await getCompetitionList(await _userRepository.refreshIdToken());
          }
          if(_result.id == null) _userRepository.diary.resultList.add(_newResult);
          yield SubmissionSuccessful(_result);
        } catch (e) {
          print(e);
          yield SubmissionFailed(_result);
        }
//      }else{
//        yield IncompleteInformation(_result, conditions);
//      }
      }



    }
  }

