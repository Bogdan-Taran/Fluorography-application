// используется для передачи состояния в ..._bloc.dart, а также для получения состояния,
// его категоризации и отображения пользовательского интерфейса в соответствии с ним.

abstract class MedicState
{
  int counter = 0;
  MedicState({required this.counter});
}

class MedicInitialState extends MedicState
{
  MedicInitialState():super(counter: 0);
}

class MedicIncrementState extends MedicState
{
  MedicIncrementState(int increasedMedic):super(counter: increasedMedic);
}

class MedicDecrementState extends MedicState
{
  MedicDecrementState(int decreasedMedic):super(counter: decreasedMedic);
}