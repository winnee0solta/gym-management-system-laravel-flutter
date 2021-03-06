import 'package:gym_app/index.dart';
import 'package:http/http.dart' as http;

class MemberPayment extends StatefulWidget {
  MemberPayment({Key key}) : super(key: key);

  @override
  _MemberPaymentState createState() => _MemberPaymentState();
}

class _MemberPaymentState extends State<MemberPayment> {
  bool isloading = true;

  var payments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: memberAppBar(context),
      drawer: memberAppDrawer(context),
      body: isloading
          ? LoadingLayout()
          : Container(
              height: MediaQuery.of(context).size.height,
              color: Color(0xfff2f3f5),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: payments.length,
                itemBuilder: _buildItemsForListView,
              )),
    );
  }

  Widget _buildItemsForListView(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: ListTile(
              title: Text("Amount - Rs${payments[index]['amount']} ",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xff0a0a0a),
                  )),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: Text(payments[index]['note'],
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xff0a0a0a),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _populateData();
  }

  Future<void> _populateData() async {
    Authentication().userId().then((userId) async {
      print(userId);
      var response = await http.get(
          ApiHelper.memberPayment + "/" + userId.toString(),
          headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        var data = json.decode(response.body);

        setState(() {
          // member = data['member'];
          // user = data['user'];
          payments = data['payments'];

          isloading = false;
        });
      } else {
        print('Request failed with status: ${response.reasonPhrase}.');
        throw Exception('Failed to get data');
      }
    });
  }
}
