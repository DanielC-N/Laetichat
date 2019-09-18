
class Messages {
  String username;
  String text;
  String timestamp;
  String received;
  String read;

  Messages({this.username, this.text, this.timestamp, this.received, this.read});

  Messages.fromString(String strMessage) {
    List<String> subList = strMessage.split("<+++>");
    this.username = subList[0];
    this.text = subList[1];
    this.timestamp = subList[2];
    this.received = subList[3];
    this.read = subList[4];
  }

  Messages.fromText(String usr, String txt) {
    this.username = usr;
    this.text = txt;
    this.timestamp = DateTime.now().toString();
    this.received = "0";
    this.read = "0";
  }

  Messages.fromReceived(String usr, String txt, String timeStamp) {
    this.username = usr;
    this.text = txt;
    this.timestamp = timeStamp;
    this.received = "1";
    this.read = "1";
  }

  Map<String, String> toMap() {
    return {
      'username': this.username,
      'text': this.text,
      'timestamp': this.timestamp,
      'received': this.received,
      'read': this.read
    };
  }

  @override
  String toString() {
    return this.username+"<+++>"+this.text+"<+++>"+this.timestamp+"<+++>"+this.received+"<+++>"+this.read;
  }
}