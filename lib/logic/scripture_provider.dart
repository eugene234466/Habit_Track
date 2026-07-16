const scriptures = [
  "Verse 1 text - Reference",
  "Verse 2 text - Reference"
];
int getDayOfYear(DateTime date){
  final firstdayofyear = DateTime(date.year, 1, 1);
  return date.difference(firstdayofyear).inDays + 1;
}
String getTodaysScripture(){
  int dayOfYear = getDayOfYear(DateTime.now());
  return scriptures[dayOfYear % scriptures.length];
}