class Event {
  final String title,
      description,
      location,
      startdate,
      starttime,
      enddate,
      endtime,
      host,
      id;
  final List categoryIds;

  Event(
      {required this.id,
      required this.title,
      required this.description,
      required this.location,
      required this.startdate,
      required this.starttime,
      required this.enddate,
      required this.endtime,
      required this.categoryIds,
      required this.host});
}

final fiveKmRunEvent = Event(
    title: "5 Kilometer Downtown Run",
    description: "It is a trek",
    location: "Pleasant Park",
    startdate: "11/17/2023",
    starttime: "7:00 AM",
    enddate: "11/17/2023",
    endtime: "12:00 PM",
    host: "Host Name",
    id: '5235923grg',
    categoryIds: [0, 1]);

// final cookingEvent = Event(
//     title: "Granite Cooking Class",
//     description: "Guest list fill up fast so be sure to apply before handto secure a spot.",
//     location: "Food Court Avenue",
//     duration: "4h",
//     punchLine1: "Granite Cooking",
//     punchLine2: "The latest fad in foodology, get the inside scoup.",
//     categoryIds: [0, 2],
// );
// final musicConcert = Event(
//     title: "Arijit Music Concert",
//     description: "Listen to Arijit's latest compositions.",
//     location: "D.Y. Patil Stadium, Mumbai",
//     duration: "5h",
//     punchLine1: "Music Lovers!",
//     punchLine2: "The latest fad in foodology, get the inside scoup.",
//     categoryIds: [0, 1]);

// final golfCompetition = Event(
//     title: "Season 2 Golf Estate",
//     description: "",
//     location: "NSIC Ground, Okhla",
//     duration: "1d",
//     punchLine1: "Golf!",
//     punchLine2: "The latest fad in foodology, get the inside scoup.",
//     categoryIds: [0, 3]);

final events = [
  fiveKmRunEvent,
  // cookingEvent,
  // musicConcert,
  // golfCompetition,
];
