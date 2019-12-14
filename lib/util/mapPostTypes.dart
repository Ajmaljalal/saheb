mapPostType(type, appLanguage) {
  if (type == appLanguage['health'].toLowerCase()) {
    return type = 'health';
  }
  if (type == appLanguage['education'].toLowerCase()) {
    return type = 'education';
  }
  if (type == appLanguage['computer'].toLowerCase()) {
    return type = 'computer and mobile';
  }
  if (type == appLanguage['electrician'].toLowerCase()) {
    return type = 'electricity';
  }
  if (type == appLanguage['painting'].toLowerCase()) {
    return type = 'painting';
  }
  if (type == appLanguage['construction'].toLowerCase()) {
    return type = 'construction';
  }
  if (type == appLanguage['carpenter'].toLowerCase()) {
    return type = 'carpenters';
  }
  if (type == appLanguage['mechanic'].toLowerCase()) {
    return type = 'mechanics';
  }
  if (type == appLanguage['laundry'].toLowerCase()) {
    return type = 'laundry';
  }
  if (type == appLanguage['transportation'].toLowerCase()) {
    return type = 'transportation';
  }
  if (type == appLanguage['cleaning'].toLowerCase()) {
    return type = 'cleaning';
  }
  if (type == appLanguage['legal'].toLowerCase()) {
    return type = 'law and legal';
  }
  if (type == appLanguage['decoration'].toLowerCase()) {
    return type = 'decoration';
  }
  if (type == appLanguage['cosmetics'].toLowerCase()) {
    return type = 'barbershops and hair saloons';
  }
  if (type == appLanguage['plumber'].toLowerCase()) {
    return type = 'plumbering';
  }
}
