import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'edit_video_state.dart';

class EditVideoCubit extends Cubit<EditVideoState> {
  EditVideoCubit() : super(EditVideoInitial());
}
