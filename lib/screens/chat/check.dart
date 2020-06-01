import 'dart:async';

Future<String> createOrderMessage() async {
  String order = await Future.delayed(Duration(seconds: 2), () {
    return 'Large Latte';
  });

  print('asdsd');

  return 'Your order is: $order';
}

void main() {
  var x = createOrderMessage();
  print(x);
  print('Fetching user order...');
}
