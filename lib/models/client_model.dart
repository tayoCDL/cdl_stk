
class Client {
  int id;
  String name;
  int miles;

  Client(this.id, this.name, this.miles);

  Client.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    miles = map['miles'];
  }

  Map<String, dynamic> toMap() {
    return {
   //   ClientDatabaseHelper.columnName: name,
   //   ClientDatabaseHelper.columnMiles: miles,
    };
  }
}