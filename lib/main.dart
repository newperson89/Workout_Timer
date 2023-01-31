import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app_complete/blocs/workouts_qubit.dart';
import 'package:flutter_bloc_app_complete/states/workout_states.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'blocs/workout_cubit.dart';
import 'models/workout.dart';
import 'screens/edit_workout_screen.dart';
import 'screens/home_page.dart';
import 'package:path_provider/path_provider.dart';

import 'screens/workout_in_progress.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory()
  );
  HydratedBlocOverrides.runZoned(
          () => runApp(WorkoutTime()),
           storage: storage
    );
}


class WorkoutTime extends StatelessWidget {
  const WorkoutTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Workouts',
      theme: ThemeData(
        primaryColor: Colors.blue,
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Color.fromARGB(255, 66, 74, 96)),
        )
      ),
      home: MultiBlocProvider(
          providers: [ BlocProvider<WorkoutsCubit>(
          create: (BuildContext context){
          WorkoutsCubit workoutsCubit = WorkoutsCubit();
          if(workoutsCubit.state.isEmpty){
          print("..Load Json please");
          workoutsCubit.getWorkouts();
        } else {
        print("....The state is not empty");
        }
        return workoutsCubit;
        }),
          BlocProvider<WorkoutCubit>(create: (BuildContext context)=>WorkoutCubit())
          ],
          child: BlocBuilder<WorkoutCubit, WorkoutState>(
              builder: (context, state){
                if(state is WorkoutInitial){
                  return HomePage();
                }else if(state is WorkoutEditing){
                  return EditWorkoutScreen();
                }
                return WorkoutProgress();
              },
          ),
          ),
          );
        }
      }

