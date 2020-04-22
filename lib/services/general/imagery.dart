import 'package:image_picker/image_picker.dart';

class Imagery{
  static void GetImageFromCamera(Function after) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    after(image);
  }
}