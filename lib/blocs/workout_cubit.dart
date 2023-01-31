import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app_complete/models/workout.dart';
import 'package:flutter_bloc_app_complete/states/workout_states.dart';
import 'package:wakelock/wakelock.dart';

class WorkoutCubit extends Cubit<WorkoutState>{
  WorkoutCubit(): super(const WorkoutInitial());

  Timer? _timer;


  editWorkout(Workout workout, int index)=>
      emit(WorkoutEditing(workout, index, null));


  editExercise(int? exIndex)=> emit(WorkoutEditing
    (state.workout,(state as WorkoutEditing).index, exIndex));

  pauseWorkout()=>emit(WorkoutPaused(state.workout, state.elapsed));

  resumeWorkout()=>emit(WorkoutInProgress(state.workout, state.elapsed));



   goHome()=>emit(const WorkoutInitial());

   onTick(Timer timer){
     if(state is WorkoutInProgress){
      WorkoutInProgress wip =  state as WorkoutInProgress;
      if(wip.elapsed!< wip.workout!.getTotal()){
        emit(WorkoutInProgress(wip.workout, wip.elapsed!+1));
      }else{
        _timer!.cancel();
        Wakelock.disable();
        emit(WorkoutInitial());
      }
     }
   }

   startWorkout(Workout workout, [int? index]){
    Wakelock.enable();
    if(index !=null){

    }else{
      emit(WorkoutInProgress(workout, 0));
    }
    _timer = Timer.periodic(const Duration(seconds: 1), onTick);
   }

}