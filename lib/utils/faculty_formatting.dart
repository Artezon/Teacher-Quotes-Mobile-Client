String formatFaculty(String facultyName) {
  facultyName = facultyName.replaceAll('_', ' ');
  facultyName = "${facultyName[0].toUpperCase()}${facultyName.substring(1)}";
  facultyName = facultyName.replaceAll("кубгу", "КубГУ");
  return facultyName;
}
