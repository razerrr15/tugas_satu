void main(list<String> args) {
    map<String, dynamic> users = {
    'admin': 'admin',
    'user': 'user',
    'guest': 'guest'
    };
    String username = 'admin';
    int password = 123;  
users.forEach((key, value) {
  if (key == username && value == password) {
    print("Login Berhasil");
  } else {
    print("Login Gagal");
  }
});
}