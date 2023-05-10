class Notice {
  final String title;
  final String date;
  final String body;
  final Origin origin;

  Notice(this.title, this.date, this.body, this.origin);
}

class Origin {
  final String name;
  final String description;
  final String baseUri;

  Origin(this.name, this.description, this.baseUri);
}
