class tomcat(
  $version = '6'
) {
  case $version {
    6: { include tomcat::tomcat6 }
    default: { fail("This class only knows how to handle tomcat 6 I'm afraid :(") }
  }
}