import 'package:flutter/material.dart';

class MyDateUtil {
  // for getting formatted time from milliSecondsSinceEpochs String
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  // for getting formatted time for sent & read
  static String getMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }

    return now.year == sent.year
        ? '$formattedTime - ${sent.day} ${_getMonth(sent)}'
        : '$formattedTime - ${sent.day} ${_getMonth(sent)} ${sent.year}';
  }

  //get last message time (used in chat user card)
  static String getLastMessageTime(
      {required BuildContext context,
      required String time,
      bool showYear = false}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return showYear
        ? '${sent.day} ${_getMonth(sent)} ${sent.year}'
        : '${sent.day} ${_getMonth(sent)}';
  }

  //get user's post time
  static String getUsersPostTime(
      {required BuildContext context,
      required String time,
      bool showYear = false}) {
    final DateTime theTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.minute == theTime.minute &&
        now.hour == theTime.hour &&
        now.day == theTime.day) {
      print('difference in seconds');
      int differenceInSeconds = now.second - theTime.second;

      return '$differenceInSeconds seconds ago';
    } else if (now.hour == theTime.hour && now.day == theTime.day) {
      print('difference in minutes');
      int differenceInMinutes = now.minute - theTime.minute;

      return differenceInMinutes == 1
          ? 'a minute ago'
          : '$differenceInMinutes minutes ago';
    } else if (now.day == theTime.day) {
      print('difference in hours');
      int differenceInHours = now.hour - theTime.hour;

      return differenceInHours == 1
          ? 'an hour ago'
          : '$differenceInHours hours ago';
    } else if (now.month == theTime.month && now.day != theTime.day) {
      print('different in days');

      int differenceInDays = now.day - theTime.day;
      return differenceInDays == 1 ? 'a day ago' : '$differenceInDays days ago';
    } else if (now.year == theTime.year && now.day != theTime.day) {
      print('different in months');

      int differenceInMonths = now.month - theTime.month;
      return differenceInMonths == 1
          ? 'a month ago'
          : '$differenceInMonths months ago';
    }

    return showYear
        ? '${theTime.day} ${_getMonth(theTime)} ${theTime.year}'
        : '${theTime.day} ${_getMonth(theTime)}';
  }

  //get user's story time
  static String getUsersStoryTime({
    required BuildContext context,
    required String time,
  }) {
    final DateTime theTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(theTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hrs';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days';
    } else {
      return '${theTime.day} ${_getMonth(theTime)} ${theTime.year}';
    }
  }

  //get formatted last active time of user in chat screen
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    //if time is not available then return below statement
    if (i == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == time.year) {
      return 'Last seen today at $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);

    return 'Last seen on ${time.day} $month on $formattedTime';
  }

  // get month name from month no. or index
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}
