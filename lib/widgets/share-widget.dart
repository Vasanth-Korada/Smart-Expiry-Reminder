import 'package:share/share.dart';

Future<void> share({String title, String subject}) async {
  return Share.share(
      title == null
          ? "Hey I've found this app very useful where you can get expiration reminders for your medicines, grocery items & other products.\nDownload Smart Expiry Reminder App from Google Play \nhttps://play.google.com/store/apps/details?id=com.vktech.expiry_remainder "
          : title +
              subject +
              "\n\nDownload Daily Coding Challenges, Concepts & Articles App from Google Play:\nhttps://play.google.com/store/apps/details?id=com.vktech.daily_coding_challenges",
      subject: "\nDownload Smart Expiry Reminder App from Google Play");
}
