import 'package:flutter/services.dart';

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

class CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex == 2 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

// class NameInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     final text = newValue.text;
//     if (text.length < oldValue.text.length) {
//       return newValue;
//     }
//
//     final parts = text.split(' ');
//     if (parts.length == 2) {
//       if (parts[1].length == 1 && !parts[1].endsWith('.')) {
//         return TextEditingValue(
//           text: '${parts[0]} ${parts[1]}.',
//           selection: TextSelection.collapsed(offset: text.length + 1),
//         );
//       }
//       else if (parts[1].length == 3 && parts[1][1] == '.' && !parts[1].endsWith('.')) {
//         return TextEditingValue(
//           text: '${parts[0]} ${parts[1]}.',
//           selection: TextSelection.collapsed(offset: text.length + 1),
//         );
//       }
//     }
//     else if (parts.length == 3) {
//       if (parts[1].endsWith('.') && parts[2].length == 1 && !parts[2].endsWith('.')) {
//         return TextEditingValue(
//           text: '${parts[0]} ${parts[1]}${parts[2]}.',
//           selection: TextSelection.collapsed(offset: text.length + 1),
//         );
//       }
//     }
//     return newValue;
//   }
// }

class NameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.length < oldValue.text.length) {
      return newValue;
    }

    final parts = text.split(' ');
    if (parts.length >= 2) {
      if (parts[1].length == 1 && !parts[1].endsWith('.')) {
        return TextEditingValue(
          text: '${parts[0]} ${parts[1]}.',
          selection: TextSelection.collapsed(offset: text.length + 1),
        );
      }
      else if (parts[1].length == 3 && parts[1][1] == '.' && !parts[1].endsWith('.')) {
        return newValue;
      }
    }
    return newValue;
  }
}
