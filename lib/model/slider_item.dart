
import '../app.dart';

class SliderItem {
  final String description;
  final List<String> points;
  final String imageUrl;
  final String title;
  final String heading;

  SliderItem({
    required this.description,
    required this.imageUrl,
    required this.title,
    required this.heading,
    required this.points,
  });
}

final listSlide = [
  // SliderItem(
  //   description:
  //       'Experience the best sports app ever',
  //   imageUrl: App.onboarding_img,
  //   title: 'How the app can\nhelp you',
  //   heading: '',
  // ),
  SliderItem(
    points: [
      "Virtual and physical booking options ",
      "Buddy up with other players at different levels", // ie professional",
      "Challenge mode- can you beat other opponents in skill games which you decide?",
    ],
    description: "Experience the best sports app ever",
    imageUrl: App.onboarding_player,
    title: 'Player Benefits',
    heading: "Book sessions with coaches face to face or virtually\n"+
      "Challenge mode' compete against other players. See who is the best!\n"
      "Train with other payers in 'Buddy up' mode\n"+
      "Record your fixtures and results\n"+
      "Set your won targets and track your progress\n"+
      "Share your progress with your social media" ),
  SliderItem(
      points: [
        "Virtual and Physical booking for 121 and group sessions ",
        "Train in multiple sports ",
        "Provide IAP (Individual action plans)",
      ],
      description: "Experience the best sports app ever",
     imageUrl: App.onboarding_coach,
      title: 'Coach Benefits',
      heading: "Increase your customer base - coach from anywhere in the UK\n"+
      "Increase exposure by coaching in multiple sports\n"+
      "Coach face to face, groups,bootcamps (virtually also!)\n"+
      "Greater engagement with players through action plans\n"+
      "Secure payments facility\n"+
      "Access player mode features"),
];
