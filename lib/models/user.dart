class CurrentUser {
  final String uid;
  final String name;
  final String sem;
  final String email;
  final String id_card;
  final String set_num;
  final String phone;
  final List courses;
  CurrentUser({
    required this.uid,
    required this.name,
    required this.sem,
    required this.email,
    required this.courses,
    required this.id_card,
    required this.phone,
    required this.set_num,
  });
}
