class User {
  final String name;
  final String email;
  final String id;
  final String location;
  final List hiddenPosts;
  final String photoUrl;

  const User({
    this.name,
    this.email,
    this.id,
    this.location,
    this.hiddenPosts,
    this.photoUrl,
  });

  Map<String, dynamic> makeUser(
      {id, name, email, location, hiddenPosts, photoUrl}) {
    return {
      id: id,
      name: name,
      email: email,
      location: location,
      hiddenPosts: hiddenPosts,
      photoUrl: photoUrl
    };
  }
}
